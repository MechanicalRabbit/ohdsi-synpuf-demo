using Revise
using LibPQ
using DataKnots: DataKnot
using FunSQL: FunSQL, SQLTable, From, Select, Where, Join, Group, Agg, Fun, Get, to_sql, normalize
using PostgresCatalog
using Tables

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

q = From(person)
run(q)

q = person |>
    Select(Get.person_id, Get.year_of_birth)
run(q)

q = person |>
    Group(Get.gender_concept_id)
run(q)

q = person |>
    Group() |>
    Select(
        Agg.Count(),
        Agg.Min(Get.year_of_birth),
        Agg.Max(Get.year_of_birth))
run(q)

q = person |>
    Join(:condition => (condition_occurrence |> Group(Get.person_id)),
         Fun."="(Get.person_id, Get.condition.person_id)) |>
    Select(
        Get.person_id,
        Agg.Count(),
        Agg.Min(Get.condition.condition_start_date),
        Agg.Max(Get.condition.condition_start_date))
run(q)

