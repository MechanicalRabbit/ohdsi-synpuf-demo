using LibPQ, DataKnots, DataKnots4Postgres
using DataKnots: Query, Environment, Pipeline, target, lookup, 
                 compose, cover, syntaxof

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

const Concept = CascadeGet(:concept, :fpk_observation_concept,
                           :fpk_visit_concept, :fpk_condition_concept, 
                           :fpk_device_concept, :fpk_procedure_concept,
                           :fpk_drug_era_concept, :fpk_drug_concept) >>
                Label(:concept)
DataKnots.translate(::Module, ::Val{:concept}) = Concept

AnyOf(Xs...) = Lift(|, (Xs...,))
OneOf(X, Ys...) = AnyOf((X .== Y for Y in Ys)...)
HasCode(vocabulary_id, codes...) = 
    Concept >> 
    Filter((It.vocabulary_id .== string(vocabulary_id)) .&
           OneOf(It.concept_code, string.(codes)...)) >>
    Exists

sp10 = DataKnot(LibPQ.Connection(""))

