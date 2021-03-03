using Revise
using LibPQ
using DataKnots: DataKnot
using FunSQL: FunSQL, SQLTable, From, Select, Where, Join, Group, Append, Agg, Fun, Get, to_sql, normalize
using PostgresCatalog

FunSQL.SQLTable(tbl::PostgresCatalog.PGTable) =
    SQLTable(Symbol(tbl.schema.name), Symbol(tbl.name), Symbol[Symbol(col.name) for col in tbl])

conn = LibPQ.Connection("postgresql:///synpuf-hcfu?host=/var/run/postgresql")

function run(q)
    sql = to_sql(normalize(q))
    println(sql, ";")
    println()
    result = execute(conn, sql)
    println(convert(DataKnot, result))
    println('-'^80)
end


cat = PostgresCatalog.introspect(conn)
for tbl in cat["public"]
    @eval $(Symbol(tbl.name)) = SQLTable($tbl)
end

const myocardial_infarction = (codesystem = "SNOMED", code = "22298006")
const old_myocardial_infarction = (codesystem = "SNOMED", code = "1755008")

IsCoded(t) =
    Fun.And(Fun."="(Get.vocabulary_id, t.codesystem), Fun."="(Get.concept_code, t.code))

IsCoded′(t) =
    Get.vocabulary_id."="(t.codesystem)."AND"(Get.concept_code."="(t.code))

IsCoded′′(t) =
    (Get.vocabulary_id .== t.codesystem) .& (Get.concept_id .== t.code)

#=
Fun.=(X, Y) => FunCall{:(=)}(X, Y)
X .== Y => FunCall{==}(X, Y)
=#

# @query sp10 concept.filter(is_myocardial_infarction).
#                  { code => concept_code, name => concept_name }

FromValidConcept() =
    From(concept) |>
    Where(Fun."IS_NULL"(Get.invalid_reason))

FromValidConcept(t) =
    FromValidConcept() |> Where(IsCoded(t))

QInfarctionConcept =
    FromValidConcept() |>
    Where(IsCoded(myocardial_infarction)) |>
    Select(Get.concept_id)
run(QInfarctionConcept)

QInfarctionConceptDescendants =
    (:ancestor => FromValidConcept(myocardial_infarction)) |>
    Join(concept_ancestor,
         Fun."="(Get.ancestor.concept_id, Get.ancestor_concept_id)) |>
    Join(:descendant => FromValidConcept(),
         Fun."="(Get.descendant.concept_id, Get.descendant_concept_id)) |>
    Select(Get.descendant.concept_id)
run(QInfarctionConceptDescendants)

QInfarctionConceptWithDescendants =
    FromValidConcept(myocardial_infarction) |>
    Append(
        FromValidConcept() |>
        Join(concept_ancestor,
             Fun."="(Get.concept_id, Get.descendant_concept_id)) |>
        Join(:ancestor => FromValidConcept(myocardial_infarction),
             Fun."="(Get.ancestor_concept_id, Get.ancestor.concept_id)))
run(QInfarctionConceptWithDescendants)

run(QInfarctionConceptWithDescendants |> Select(Get.concept_id))
