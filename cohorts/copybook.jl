using Dates, LibPQ, DataKnots, DataKnots4Postgres
using DataKnots: Query, Environment, Pipeline, target, lookup,
                 compose, cover, syntaxof
import DataKnots: translate

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

const Concept =
    CascadeGet(:concept, :fpk_observation_concept,
               :fpk_visit_concept, :fpk_condition_concept,
               :fpk_device_concept, :fpk_procedure_concept,
               :fpk_drug_era_concept, :fpk_drug_concept) >>
    Label(:concept)

translate(::Module, ::Val{:concept}) = Concept

const StartDate =
    Is1to1(
        CascadeGet(:start_date, :condition_start_date,
                   :visit_start_date, :observation_period_start_date,
                   :drug_exposure_start_date, :drug_era_start_date,
                   :procedure_date, :device_exposure_start_date) >>
        Date.(It) >>
        Label(:start_date))

translate(::Module, ::Val{:start_date}) = StartDate

const EndDate =
    Is1to1(
           Given(:start_date => StartDate,
              :end_date => CascadeGet(:end_date, :condition_end_date,
                                      :visit_end_date, :procedure_date,
                                      :observation_period_end_date,
                                      :device_exposure_end_date,
                                      :drug_exposure_end_date,
                                      :drug_era_end_date),
              coalesce.(It.end_date, It.start_date .+ Day(1))) >>
        Date.(It) >>
        Label(:end_date))

translate(::Module, ::Val{:end_date}) = EndDate

# Let's also make `condition` work globally and locally to retrieve
# condition_occurrence records by patient. Unfortunately, `Condition`
# is a built-in name of a type, so we won't make a native version.

translate(::Module, ::Val{:condition}) =
              CascadeGet(:condition_occurrence,
                  :condition_occurrence_via_fpk_condition_person) >>
              Label(:condition)

translate(::Module, ::Val{:visit}) =
              CascadeGet(:visit_occurrence,
                  :visit_occurrence_via_fpk_visit_person) >>
              Label(:visit)

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

sp10 = DataKnot(LibPQ.Connection(""))

# playground...
 
PrimaryEvents =
    It.condition_occurrence >>
    Filter(Concept >> IsCoded("SNOMED", 22298006)) >>
    Keep(:condition => It) >>
    Record(:co => It, :person_id => It.person_id) >>
    Join(It.observation_period >>
         Filter(It.person_id .== It.condition.person_id) >>
         Record(It.person_id, It.condition.person_id,
                It.observation_period_start_date,
                It.observation_period_end_date)) >>
    It.observation_period


