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
        { person_id, concept.concept_name }
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
        { person_id, concept.concept_name }
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

    @query sp10 Date("2008-04-10").includes("2008-04-10")
    #=>
    ┼──────┼
    │ true │
    =#

    @query sp10 DateInterval("2008-04-08", "2008-04-11").
                    includes("2008-04-10")
    #=>
    ┼──────┼
    │ true │
    =#

    @query sp10 begin
         visit.filter(includes("2008-04-10"))
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
         visit.filter(start_date.includes("2008-04-10"))
         { it, start_date, end_date }
    end
    #=>
      │ visit                         │
      │ visit  start_date  end_date   │
    ──┼───────────────────────────────┼
    1 │ 88246  2008-04-10  2008-04-10 │
    =#

    @query sp10 visit.group(concept).keep(concept).
        collapse_intervals(
          visit.date_interval(
            start_date,
            max(end_date, start_date + 7days)), 90days).
        { concept, interval=>it }
    #=>
       │ concept  interval                 │
    ───┼───────────────────────────────────┼
     1 │ 0        2008-03-18 to 2008-04-17 │
     2 │ 0        2008-10-20 to 2009-02-01 │
     3 │ 0        2009-05-22 to 2009-09-09 │
     4 │ 0        2010-04-15 to 2010-08-19 │
     ⋮
     9 │ 9202     2008-09-07 to 2008-09-16 │
    10 │ 9202     2009-01-09 to 2009-01-16 │
    11 │ 9202     2009-08-02 to 2009-08-09 │
    12 │ 9202     2010-05-06 to 2010-05-13 │
    =#

    @query sp10 visit{ date_interval, earlier => and_previous(3days) }
    #=>
       │ visit                                              │
       │ date_interval             earlier                  │
    ───┼────────────────────────────────────────────────────┼
     1 │ 2008-04-09 to 2008-04-13  2008-04-06 to 2008-04-13 │
     2 │ 2008-11-22 to 2008-11-22  2008-11-19 to 2008-11-22 │
     3 │ 2008-04-10 to 2008-04-10  2008-04-07 to 2008-04-10 │
     ⋮
    27 │ 2010-06-07 to 2010-06-07  2010-06-04 to 2010-06-07 │
    =#

    @query sp10 visit{ date_interval, later => and_subsequent(3days) }
    #=>
       │ visit                                              │
       │ date_interval             later                    │
    ───┼────────────────────────────────────────────────────┼
     1 │ 2008-04-09 to 2008-04-13  2008-04-09 to 2008-04-16 │
     2 │ 2008-11-22 to 2008-11-22  2008-11-22 to 2008-11-25 │
     3 │ 2008-04-10 to 2008-04-10  2008-04-10 to 2008-04-13 │
     ⋮
    27 │ 2010-06-07 to 2010-06-07  2010-06-07 to 2010-06-10 │
    =#

    @query sp10 condition{ earlier => start_date.and_previous(3days),
                           later => start_date.and_subsequent(3days) }
    #=>
       │ condition                                          │
       │ earlier                   later                    │
    ───┼────────────────────────────────────────────────────┼
     1 │ 2008-04-07 to 2008-04-10  2008-04-10 to 2008-04-13 │
     2 │ 2009-05-19 to 2009-05-22  2009-05-22 to 2009-05-25 │
     3 │ 2008-11-19 to 2008-11-22  2008-11-22 to 2008-11-25 │
     4 │ 2008-11-09 to 2008-11-12  2008-11-12 to 2008-11-15 │
     5 │ 2009-07-30 to 2009-08-02  2009-08-02 to 2009-08-05 │
     6 │ 2010-08-09 to 2010-08-12  2010-08-12 to 2010-08-15 │
     ⋮
    22 │ 2008-09-04 to 2008-09-07  2008-09-07 to 2008-09-10 │
    23 │ 2009-06-27 to 2009-06-30  2009-06-30 to 2009-07-03 │
    24 │ 2010-06-04 to 2010-06-07  2010-06-07 to 2010-06-10 │
    25 │ 2008-09-04 to 2008-09-07  2008-09-07 to 2008-09-10 │
    26 │ 2009-09-27 to 2009-09-30  2009-09-30 to 2009-10-03 │
    =#

    @query sp10 visit.keep(it){it,
                   person.condition.filter(
                         start_date.during(visit))}
    #=>
       │ visit                       │
       │ visit    condition          │
    ───┼─────────────────────────────┼
     1 │ 88179    228161             │
     2 │ 88214    228060             │
     3 │ 88246    228161             │
     ⋮
    25 │ 5314671  13769189; 13769190 │
    26 │ 5314690  13769242           │
    27 │ 5314696  13769260           │
    =#
