using Dates, LibPQ, DataKnots, DataKnots4Postgres
using DataKnots: Query, Environment, Pipeline, ValueOf, BlockOf,
                 target, lookup, cover, uncover, lift, compose,
                 syntaxof, relabel, assemble, designate, fits,
                 relabel
import DataKnots: translate, lookup, Lift, Label
import Base: show

# For the macro variants of some combinators here, we wish to permit
# keyword arguments to be used. This macro translation does this.
function translate_kwargs(mod, names, args)
    unpacked = []
    for (name, arg) in zip(names, args)
        if Meta.isexpr(arg, :kw)
            key = arg.args[1]
            if key !== name
                err = "expected argument named `$(name)`, got `$(key)`"
                throw(ArgumentError(err))
            end
            push!(unpacked, arg.args[2])
        else
            push!(unpacked, arg)
        end
    end
    return translate.(Ref(mod), unpacked)
end

# So that queries can be used inside a macro without the dollar sign,
# let's create a macro that injects a translation. This permits
# query macros to be created and then reused later.

macro define(expr)
    @assert expr.head === Symbol("=")
    name = Expr(:quote, expr.args[1])
    body = :(translate($__module__, $(Expr(:quote, expr.args[2]))))
    return :(DataKnots.translate(mod::Module, ::Val{$(name)}) = $(body))
end

#
# Sometimes we wish to do dispatch by the type of input elements. For
# example, if the input is already a date we may wish to treat it a
# particular way, otherwise we may want to make it a date first.
#

DispatchByType(tests::Pair{DataType}...) =
    Query(DispatchByType, collect(Pair{DataType}, tests))

function DispatchByType(env::Environment, p::Pipeline,
                        tests::Vector{Pair{DataType}})
    for (typ, query) in tests
        if fits(target(uncover(p)), BlockOf(ValueOf(typ)))
            return assemble(env, p, query)
        end
    end
    error("doesn't match any type: $(syntaxof(target(p)))")
end

# This is a temporary work-around till we have better naming
# support in the PostgreSQL adapter. Basically, we want to be able
# to use `concept` in a query and either access the main concept
# table in the root context, or the primary link to that table
# from other contexts.

CascadeGet(names...) =
    Query(CascadeGet, names...)

function CascadeGet(env::Environment, p::Pipeline, names...)
    tgt = target(p)
    for name in names
        q = lookup(tgt, name)
        if q != nothing
            return compose(p, cover(q))
        end
    end
    error("cannot find any of $(join(string.(names), ", "))" *
          " at\n$(syntaxof(tgt))")
end

const ObservationPeriod =
    CascadeGet(:observation_period,
               :observation_period_via_fpk_observation_period_person) >>
    Label(:observation_period)

translate(::Module, ::Val{:observation_period}) = ObservationPeriod

const Visit =
    CascadeGet(:visit, :fpk_drug_visit, :visit_occurrence,
               :visit_occurrence_via_fpk_visit_person,
               :visit_occurrence_via_fpk_drug_visit) >>
    Label(:visit)

translate(::Module, ::Val{:visit}) = Visit

const DrugExposure =
    CascadeGet(:drug_exposure,
              :drug_exposure_via_fpk_drug_person) >>
    Label(:drug_exposure)

translate(::Module, ::Val{:drug_exposure}) = DrugExposure

const Concept =
    CascadeGet(:concept, :fpk_observation_concept,
               :fpk_visit_concept, :fpk_condition_concept,
               :fpk_device_concept, :fpk_procedure_concept,
               :fpk_drug_era_concept, :fpk_drug_concept) >>
    Label(:concept)

translate(::Module, ::Val{:concept}) = Concept

const Person =
    CascadeGet(:person, :fpk_observation_person,
               :fpk_visit_person, :fpk_condition_person,
               :fpk_device_person, :fpk_procedure_person,
               :fpk_drug_era_person, :fpk_drug_person) >>
    Label(:person)

translate(::Module, ::Val{:person}) = Person

# Let's also make `condition` work globally and locally to retrieve
# condition_occurrence records by patient. Unfortunately, `Condition`
# is a built-in name of a type, so we won't make a native version.

translate(::Module, ::Val{:condition}) =
              CascadeGet(:condition, :condition_occurrence,
                  :condition_occurrence_via_fpk_condition_person) >>
              Label(:condition)

translate(::Module, ::Val{:days_supply}) =
              Get(:days_supply) .* Dates.Day(1)
              Label(:days_supply)

# Depending upon the type of record, the actual start date field
# has a different name.  To make this usable, let's normalize it.
# For procedures, let's take it as the start and ending date.

const StartDate =
        CascadeGet(:start_date, :observation_period_start_date,
                       :condition_start_date, :drug_era_start_date,
                       :drug_exposure_start_date, :visit_start_date,
                       :device_exposure_start_date, :procedure_date) >>
        Date.(It) >>
        Label(:start_date)

translate(::Module, ::Val{:start_date}) = StartDate

const EndDate =
        CascadeGet(:end_date, :observation_period_end_date,
                       :condition_end_date, :drug_era_end_date,
                       :drug_exposure_end_date, :visit_end_date,
                       :device_exposure_end_date, :procedure_date) >>
        Date.(It) >>
        Label(:end_date)

translate(::Module, ::Val{:end_date}) = EndDate

# Many query operations involve date intervals. We can't use native
# Julia range object since it's a vector, and vectors are lifted to a
# plural value rather than treated as a tuple. That said, we could
# create a custom type, `DateInterval`, lifted to combinators. This
# sort of interval is inclusive of endpoints.

struct DateInterval
    start_date::Date
    end_date::Date
end
Base.show(io::IO, i::DateInterval) =
    print(io, "$(i.start_date) to $(i.end_date)")

DateInterval(start_date::String, end_date::String) =
    DateInterval(Date(start_date), Date(end_date))
translate(mod::Module, ::Val{:date_interval}, args::Tuple{Any, Any}) =
    DateInterval.(translate.(Ref(mod), args)...)

Lift(::Type{DateInterval}) =
    DispatchByType(DateInterval => It,
                   Date => DateInterval.(It, It),
                   String => DateInterval.(Date.(It), Date.(It)),
                   Any => DateInterval.(StartDate, EndDate)) >>
    Label(:date_interval)
translate(::Module, ::Val{:date_interval}) = Lift(DateInterval)

lookup(ity::Type{DateInterval}, name::Symbol) =
    if name in (:start_date, :end_date)
        lift(getfield, name) |> designate(ity, Date)
    end

includes(period::DateInterval, val::String) =
    includes(period, Date(val))

includes(period::DateInterval, val::Date) =
    period.end_date >= val >= period.start_date

includes(period::DateInterval, val::DateInterval) =
   (val.start_date >= period.start_date) &&
   (period.end_date >= val.end_date)

and_prior(init::Date, len::Day) =
    DateInterval(init - len, init)
and_subsequent(init::Date, len::Day) =
    DateInterval(init, init + len)
and_prior(di::DateInterval, len::Day) =
    DateInterval(di.start_date - len, di.end_date)
and_subsequent(di::DateInterval, len::Day) =
    DateInterval(di.start_date, di.end_date + len)

"""
    collapse_intervals(intervals, allowance)

This function collapses a vector of intervals based upon an
allowance, such as 180days between the end of a previous interval,
and the start of the next.
"""
function collapse_intervals(intervals::Vector{DateInterval},
                            allowance::Day)
    intervals′ = Vector{DateInterval}()
    c = nothing
    for i in sort(intervals, by=(i -> i.start_date))
        if c === nothing
            c = i
        elseif c.end_date + allowance < i.start_date
            push!(intervals′, c)
            c = i
        elseif c.end_date < i.end_date
            c = DateInterval(c.start_date, i.end_date)
        end
    end
    if c !== nothing
        push!(intervals′, c)
    end
    intervals′
end

CollapseIntervals(I, A) = collapse_intervals.(I, A)
CollapseIntervals(A) = DataKnots.Then(CollapseIntervals, (A,))

translate(mod::Module, ::Val{:collapse_intervals},
          args::Tuple{Any, Any}) =
    CollapseIntervals(translate.(Ref(mod), args)...)

translate(mod::Module, ::Val{:collapse_intervals},
          args::Tuple{Any}) =
    CollapseIntervals(translate.(Ref(mod), args)...)

"""
X >> Includes(Y)

This combinator is true if the interval of `Y` is completely included
in the interval for `X`.  That is, if the starting point of `Y` is
greater than or equal to the starting point of `X`, and also if the
ending point of `Y` is less than or equal to the ending point of `X`.
This combinator accepts a `DateInterval` for its arguments, but also
any object that has `StartDate` and `EndDate` defined.
"""
Includes(O, Y) = includes.(It >> DateInterval >> O, Y >> DateInterval)
Includes(Y) = includes.(It >> DateInterval, Y >> DateInterval)
translate(mod::Module, ::Val{:includes}, args::Tuple{Any}) =
    Includes(translate.(Ref(mod), args)...)
translate(mod::Module, ::Val{:includes}, args::Tuple{Any, Any}) =
    Includes(translate.(Ref(mod), args)...)

During(O, Y) = includes.(Y >> DateInterval, It >> DateInterval >> O)
During(Y) = includes.(Y >> DateInterval, It >> DateInterval)
translate(mod::Module, ::Val{:during}, args::Tuple{Any}) =
    During(translate.(Ref(mod), args)...)
translate(mod::Module, ::Val{:during}, args::Tuple{Any, Any}) =
    During(translate.(Ref(mod), args)...)

AndPrior(Y) = and_prior.(It >> DateInterval, Lift(Day, (Y,)))
translate(mod::Module, ::Val{:and_prior}, args::Tuple{Any}) =
    AndPrior(translate.(Ref(mod), args)...)

AndSubsequent(Y) = and_subsequent.(It >> DateInterval, Lift(Day, (Y,)))
translate(mod::Module, ::Val{:and_subsequent}, args::Tuple{Any}) =
    AndSubsequent(translate.(Ref(mod), args)...)

# Sometimes it's useful to list the concepts ancestors.

AncestorConcept =
    It.concept_ancestor_via_fpk_concept_ancestor_concept_2 >>
    It.fpk_concept_ancestor_concept_1 >>
    Label(:ancestor_concept)

translate(::Module, ::Val{:ancestor_concept}) = AncestorConcept

# This is used to define `HasCode` which checks if the concept
# associated with this entity matches the given codes, or if
# one of its ancestors matches.

AnyOf(Xs...) = Lift(|, (Xs...,))
OneOf(X, Ys...) = AnyOf((X .== Y for Y in Ys)...)
HasCode(vocabulary_id, codes...) =
    (It.vocabulary_id .== vocabulary_id) .&
    OneOf(It.concept_code, (string.(code) for code in codes)...) .&
    .! Exists(It.invalid_reason)
IsCoded(vocabulary_id, codes...) =
    Exists(
        Filter(HasCode(vocabulary_id, codes...) .|
               Exists(AncestorConcept >>
                      Filter(HasCode(vocabulary_id, codes...)))))

translate(mod::Module, ::Val{:hascode}, args::Tuple{Any,Vararg{Any}}) =
    HasCode(translate.(Ref(mod), args)...)
translate(mod::Module, ::Val{:iscoded}, args::Tuple{Any,Vararg{Any}}) =
    IsCoded(translate.(Ref(mod), args)...)

# In macros, which wish to write things like `90days`. For Julia
# this interpreted as "90 * days", hence we just need to make "days"
# be a constant of 1 day.

translate(::Module, ::Val{:days}) = Dates.Day(1)

# Temporary sort since it's not implemented yet, it happens that
# group provides the functionality needed though.

DataKnots.Label(::Nothing) = Query(Label, nothing);
DataKnots.Label(::Environment, p::Pipeline, ::Nothing) =
    relabel(p, nothing)

Sort(X) = Given(:source => It, Group(X) >> It.source >> Label(nothing))

translate(mod::Module, ::Val{:sort}, args::Tuple{Any}) =
    Sort(translate.(Ref(mod), args)...)

# This creates our test database for us.

sp10 = DataKnot(LibPQ.Connection(""))
