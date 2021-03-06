using Revise
using LibPQ
using DataKnots: DataKnot
using FunSQL:
    FunSQL, SQLTable, From, Select, Where, Join, Group, Window, Append, Agg,
    Fun, Get, to_sql, normalize
using PostgresCatalog

FunSQL.SQLTable(tbl::PostgresCatalog.PGTable) =
    SQLTable(Symbol(tbl.schema.name), Symbol(tbl.name), Symbol[Symbol(col.name) for col in tbl])

conn = LibPQ.Connection("postgresql:///synpuf-5pct?host=/var/run/postgresql")
#conn = LibPQ.Connection("postgresql:///synpuf-10p?host=/var/run/postgresql")

function run(q)
    sql = to_sql(normalize(q))
    println(sql, ";")
    println()
    @time result = execute(conn, sql)
    println(convert(DataKnot, result))
    println('-'^80)
end


cat = PostgresCatalog.introspect(conn)
for tbl in cat["public"]
    @eval $(Symbol(tbl.name)) = SQLTable($tbl)
end

SNOMED(code) =
    (codesystem = "SNOMED", code = code)

SNOMED(codes...) =
    [SNOMED(code) for code in codes]

VISIT(code) =
    (codesystem = "Visit", code = code)

VISIT(codes...) =
    [VISIT(code) for code in codes]

const myocardial_infarction = SNOMED("22298006")

const old_myocardial_infarction = SNOMED("1755008")

const inpatient_or_er = VISIT("ERIP", "ER", "IP")

IsCoded(t) =
    Fun.And(Fun."="(Get.vocabulary_id, t.codesystem),
            Fun."="(Get.concept_code, t.code))

IsCoded(ts::AbstractVector) =
    Fun.Or((IsCoded(t) for t in ts)...)

FromConcept() =
    From(concept) |>
    Where(Fun."IS_NULL"(Get.invalid_reason))

FromConceptOnly(t) =
    FromConcept() |> Where(IsCoded(t))

FromConcept(t) =
    FromConceptOnly(t) |>
    Append(
        FromConcept() |>
        Join(concept_ancestor,
             Fun."="(Get.concept_id, Get.descendant_concept_id)) |>
        Join(:ancestor => FromConceptOnly(t),
             Fun."="(Get.ancestor_concept_id, Get.ancestor.concept_id))) |>
    ((t isa AbstractVector) ? Group(Get.concept_id) : identity)

FromConcept(t, et) =
    FromConcept(t) |>
    Join(:excluded => FromConcept(et),
         Fun."="(Get.concept_id, Get.excluded.concept_id),
         is_left=true) |>
    Where(Fun."IS NULL"(Get.excluded.concept_id))

QInfarctions =
    FromConcept(myocardial_infarction,
                old_myocardial_infarction)
run(QInfarctions)

QInpatientOrER =
    FromConcept(inpatient_or_er)
run(QInpatientOrER)

#=
    @define candidate_events = begin
        condition
        keep(index_date => start_date)
        filter(concept.is_myocardial_infarction)
    end

    @query sp10 begin
        candidate_events
        { person, index_date }
    end
=#

QInfarctionConditions =
    From(condition_occurrence) |>
    Join(:infarction_concept => QInfarctions,
         Fun."="(Get.condition_concept_id, Get.infarction_concept.concept_id)) |>
    Select(Get.person_id,
           :index_date => Get.condition_start_date)
run(QInfarctionConditions)

QInfarctionConditionsInOP =
    QInfarctionConditions |>
    Join(:OP => observation_period,
         Fun.And(Fun."="(Get.person_id, Get.OP.person_id),
                 Fun."<="(Get.OP.observation_period_start_date, Get.index_date),
                 Fun."<="(Get.index_date, Get.OP.observation_period_end_date)))
run(QInfarctionConditionsInOP |>
    Select(Get.person_id,
           Get.OP.observation_period_start_date,
           :start_date => Get.index_date,
           :end_date => Fun."+"(Get.index_date, 7),
           Get.OP.observation_period_end_date))

QAcuteVisits =
    From(visit_occurrence) |>
    Join(:inpatient_or_er_concept => QInpatientOrER,
         Fun."="(Get.visit_concept_id, Get.inpatient_or_er_concept.concept_id))
run(QAcuteVisits)

QInfarctionConditionsInOPDuringAcuteVisit =
    QInfarctionConditionsInOP |>
    Join(:acute_visit => QAcuteVisits,
         Fun.And(Fun."="(Get.person_id,
                         Get.acute_visit.person_id),
                 Fun."<="(Get.OP.observation_period_start_date,
                          Get.acute_visit.visit_start_date),
                 Fun."<="(Get.acute_visit.visit_end_date,
                          Get.OP.observation_period_end_date),
                 Fun."<="(Get.acute_visit.visit_start_date,
                          Get.index_date),
                 Fun."<="(Get.index_date,
                          Get.acute_visit.visit_end_date)))
run(QInfarctionConditionsInOPDuringAcuteVisit)

run(QInfarctionConditionsInOPDuringAcuteVisit |>
    Group(Get.person_id) |>
    Where(Fun.">"(Agg.Count(Get.index_date, distinct=true), 3)))

run(person |>
    Window(Get.gender_concept_id) |>
    Select(Get.person_id, Agg.Count(), Agg.Row_Number()))

QInfarctionConditionsInOPDuringAcuteVisitCollapsed =
    QInfarctionConditionsInOPDuringAcuteVisit |>
    Window(Get.person_id, order=[Get.index_date]) |>
    Select(Get.person_id, Get.index_date, Agg.Row_Number()) |>
    Where(Fun."="(Get.person_id, 42891))
run(QInfarctionConditionsInOPDuringAcuteVisitCollapsed)


