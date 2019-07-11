# Exploration of SymPuf-10 Data

This test case acts as pratical introduction to DataKnots by
exploring the SynPuf-10 dataset with a domain specific lauguage
specific to the generation of OHDSI Cohorts. To get started,
we'll import some boilerplate definitions. This will create the
*DataKnot* called `sp10` that represents our test database.

    include("copybook.jl")

Before we start our translation, let's run our first query.

    @query sp10 count(person)
    #=>
    ┼────┼
    │ 10 │
    =#

## Concept Coding

We could list all drug exposure concepts.

    @query sp10 begin
        drug_exposure
        group(concept)
        { concept.concept_code, count(drug_exposure) }
    end
    #=>
       │ concept_code  #B │
    ───┼──────────────────┼
     1 │ 311671         1 │
     2 │ 198188         1 │
     3 │ 153666         1 │
     4 │ 197499         1 │
     5 │ 197770         2 │
     6 │ 308964         1 │
     7 │ 310798         1 │
     8 │ 314076         1 │
     9 │ 314077         1 │
    10 │ 858810         2 │
    11 │ 905395         1 │
    =#

We could list all concepts that are considered hypertensive.

    IsHypertensive = IsCoded("SNOMED", 38341003)

    @query sp10 concept.filter($IsHypertensive){concept_name}
    #=>
      │ concept                          │
      │ concept_name                     │
    ──┼──────────────────────────────────┼
    1 │ Hypertensive disorder            │
    2 │ Renovascular hypertension        │
    3 │ Malignant essential hypertension │
    4 │ Malignant secondary hypertension │
    5 │ Secondary hypertension           │
    6 │ Hypertensive crisis              │
    =#

We could define a code set and use it to check for the occurrence of a
particular condition.

    @query sp10 begin
        condition
        filter(concept.$IsHypertensive)
        {person_id, concept.concept_name}
    end
    #=>
       │ condition                                   │
       │ person_id  concept_name                     │
    ───┼─────────────────────────────────────────────┼
     1 │      1780  Renovascular hypertension        │
     2 │      1780  Secondary hypertension           │
     ⋮
    15 │    110862  Malignant essential hypertension │
    =#

Let's consider specified visit types.

    @define is_inpatient_or_er =
         concept.iscoded("Visit", "ERIP", "ER", "IP")

    @query sp10 begin
        visit
        filter(is_inpatient_or_er)
        {person_id, concept.concept_name}
    end
    #=>
      │ visit                      │
      │ person_id  concept_name    │
    ──┼────────────────────────────┼
    1 │      1780  Inpatient Visit │
    2 │     30091  Inpatient Visit │
    3 │     69985  Inpatient Visit │
     ⋮
    =#

## Temporal Functions

    @query sp10 Date("2008-04-10").includes(Date("2008-04-10"))
    #=>
    ┼──────┼
    │ true │
    =#

    @query sp10 DateInterval("2008-04-08","2008-04-11").
                    includes(Date("2008-04-10"))
    #=>
    ERROR: ⋮
    =#

    @query sp10 begin
         visit.filter(includes(Date("2008-04-10")))
         { it, start_date, end_date }
    end
    #=>
      │ visit                         │
      │ visit  start_date  end_date   │
    ──┼───────────────────────────────┼
    1 │ 88179  2008-04-09  2008-04-13 │
    2 │ 88246  2008-04-10  2008-04-10 │
    =#

    @query sp10 begin
         visit.filter(start_date.includes(Date("2008-04-10")))
         { it, start_date, end_date }
    end
    #=>
      │ visit                         │
      │ visit  start_date  end_date   │
    ──┼───────────────────────────────┼
    1 │ 88246  2008-04-10  2008-04-10 │
    =#
