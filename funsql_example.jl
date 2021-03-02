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
    Group(Get.gender_concept_id) |>
    Select(
        Get.gender_concept_id,
        Agg.Count())
run(q)

q = person |>
    Group() |>
    Select(Agg.Count())
run(q)

q = person |>
    Group() |>
    Select(
        Agg.Count(),
        Agg.Min(Get.year_of_birth),
        Agg.Max(Get.year_of_birth))
run(q)

q = (:p_group => person |> Group()) |>
    Select(
        Agg.Count(over=Get.p_group),
        Agg.Min(Get.year_of_birth, over=Get.p_group),
        Agg.Max(Get.year_of_birth, over=Get.p_group))
run(q)

q = person |>
    Join(:condition => condition_occurrence |> Group(Get.person_id),
         Fun."="(Get.person_id, Get.condition.person_id)) |>
    Select(
        Get.person_id,
        Agg.Count(),
        Agg.Min(Get.condition_start_date),
        Agg.Max(Get.condition_start_date))
run(q)

q = person |>
    Join(:condition => condition_occurrence |> Group(Get.person_id),
         Fun."="(Get.person_id, Get.condition.person_id)) |>
    Where(Fun.">"(Agg.Count(), 2)) |>
    Select(Get.person_id, Agg.Count())
run(q)

q = person |>
    Join(:condition => condition_occurrence |> Group(Get.person_id),
         Fun."="(Get.person_id, Get.condition.person_id)) |>
    Group("# conditions" => Agg.Count()) |>
    Select(
        Get."# conditions",
        "# patients" => Agg.Count(),
        "min year of birth" => Agg.Min(Get.year_of_birth))
run(q)

q = person |>
    Join(:condition => condition_occurrence |> Group(Get.person_id),
         Fun."="(Get.person_id, Get.condition.person_id)) |>
    Join(:visit => visit_occurrence |> Group(Get.person_id),
         Fun."="(Get.person_id, Get.visit.person_id)) |>
    Select(
        Get.person_id,
        Agg.Count(over=Get.condition),
        Agg.Min(Get.condition_start_date, over=Get.condition),
        Agg.Max(Get.condition_start_date, over=Get.condition),
        Agg.Count(over=Get.visit),
        Agg.Min(Get.visit_start_date, over=Get.visit),
        Agg.Max(Get.visit_start_date, over=Get.visit))
run(q)
