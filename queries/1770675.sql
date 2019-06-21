

CREATE TEMP TABLE Codesets  (codeset_id int NOT NULL,

  concept_id bigint NOT NULL

)

;



INSERT INTO Codesets (codeset_id, concept_id)
SELECT 0 as codeset_id, c.concept_id FROM (select distinct I.concept_id FROM

( 

  select concept_id from @vocabulary_database_schema.CONCEPT where concept_id in (316866)and invalid_reason is null

UNION  select c.concept_id

  from @vocabulary_database_schema.CONCEPT c

  join @vocabulary_database_schema.CONCEPT_ANCESTOR ca on c.concept_id = ca.descendant_concept_id

  and ca.ancestor_concept_id in (316866)

  and c.invalid_reason is null



) I

) C;
INSERT INTO Codesets (codeset_id, concept_id)
SELECT 2 as codeset_id, c.concept_id FROM (select distinct I.concept_id FROM

( 

  select concept_id from @vocabulary_database_schema.CONCEPT where concept_id in (1319998,1317967,991382,1332418,1314002,40235485,1335471,1322081,1338005,932745,1351557,1340128,1346823,1395058,1398937,1328165,1363053,1341927,1309799,1346686,1353776,1363749,956874,1344965,1373928,974166,978555,1347384,1326012,1386957,1308216,1367500,1305447,907013,1307046,1309068,1310756,1313200,1314577,1318137,1318853,1319880,40226742,1327978,1373225,1345858,1350489,1353766,1331235,1334456,970250,1317640,1341238,942350,1342439,904542,1308842,1307863)and invalid_reason is null

UNION  select c.concept_id

  from @vocabulary_database_schema.CONCEPT c

  join @vocabulary_database_schema.CONCEPT_ANCESTOR ca on c.concept_id = ca.descendant_concept_id

  and ca.ancestor_concept_id in (1319998,1317967,991382,1332418,1314002,40235485,1335471,1322081,1338005,932745,1351557,1340128,1346823,1395058,1398937,1328165,1363053,1341927,1309799,1346686,1353776,1363749,956874,1344965,1373928,974166,978555,1347384,1326012,1386957,1308216,1367500,1305447,907013,1307046,1309068,1310756,1313200,1314577,1318137,1318853,1319880,40226742,1327978,1373225,1345858,1350489,1353766,1331235,1334456,970250,1317640,1341238,942350,1342439,904542,1308842,1307863)

  and c.invalid_reason is null



) I

) C;
INSERT INTO Codesets (codeset_id, concept_id)
SELECT 3 as codeset_id, c.concept_id FROM (select distinct I.concept_id FROM

( 

  select concept_id from @vocabulary_database_schema.CONCEPT where concept_id in (1335471,1340128,1341927,1363749,1308216,1310756,1373225,1331235,1334456,1342439)and invalid_reason is null

UNION  select c.concept_id

  from @vocabulary_database_schema.CONCEPT c

  join @vocabulary_database_schema.CONCEPT_ANCESTOR ca on c.concept_id = ca.descendant_concept_id

  and ca.ancestor_concept_id in (1335471,1340128,1341927,1363749,1308216,1310756,1373225,1331235,1334456,1342439)

  and c.invalid_reason is null



) I

) C;





CREATE TEMP TABLE qualified_events


AS
WITH primary_events (event_id, person_id, start_date, end_date, op_start_date, op_end_date, visit_occurrence_id)  AS (

-- Begin Primary Events

select P.ordinal as event_id, P.person_id, P.start_date, P.end_date, op_start_date, op_end_date, cast(P.visit_occurrence_id as bigint) as visit_occurrence_id

FROM

(

  select E.person_id, E.start_date, E.end_date, row_number() OVER (PARTITION BY E.person_id ORDER BY E.start_date ASC) ordinal, OP.observation_period_start_date as op_start_date, OP.observation_period_end_date as op_end_date, cast(E.visit_occurrence_id as bigint) as visit_occurrence_id

  FROM 

  (

  -- Begin Drug Exposure Criteria

select C.person_id, C.drug_exposure_id as event_id, C.drug_exposure_start_date as start_date, COALESCE(C.drug_exposure_end_date, (C.drug_exposure_start_date + 1*INTERVAL'1 day')) as end_date, C.drug_concept_id as TARGET_CONCEPT_ID, C.visit_occurrence_id

from 

(

  select de.* , row_number() over (PARTITION BY de.person_id ORDER BY de.drug_exposure_start_date, de.drug_exposure_id) as ordinal

  FROM @cdm_database_schema.DRUG_EXPOSURE de

JOIN Codesets codesets on ((de.drug_concept_id = codesets.concept_id and codesets.codeset_id = 3))

) C



WHERE C.ordinal = 1

-- End Drug Exposure Criteria



  ) E

	JOIN @cdm_database_schema.observation_period OP on E.person_id = OP.person_id and E.start_date >=  OP.observation_period_start_date and E.start_date <= op.observation_period_end_date

  WHERE (OP.OBSERVATION_PERIOD_START_DATE + 365*INTERVAL'1 day') <= E.START_DATE AND (E.START_DATE + 0*INTERVAL'1 day') <= OP.OBSERVATION_PERIOD_END_DATE

) P

WHERE P.ordinal = 1

-- End Primary Events



)

 SELECT
event_id, person_id, start_date, end_date, op_start_date, op_end_date, visit_occurrence_id


FROM
(

  select pe.event_id, pe.person_id, pe.start_date, pe.end_date, pe.op_start_date, pe.op_end_date, row_number() over (partition by pe.person_id order by pe.start_date ASC) as ordinal, cast(pe.visit_occurrence_id as bigint) as visit_occurrence_id

  FROM primary_events pe

  

) QE



;
ANALYZE qualified_events

;



--- Inclusion Rule Inserts



CREATE TEMP TABLE Inclusion_0


AS
SELECT
0 as inclusion_rule_id, person_id, event_id


FROM
(

  select pe.person_id, pe.event_id

  FROM qualified_events pe

  
JOIN (
-- Begin Criteria Group

select 0 as index_id, person_id, event_id

FROM

(

  select E.person_id, E.event_id 

  FROM qualified_events E

  INNER JOIN

  (

    -- Begin Correlated Criteria

SELECT 0 as index_id, p.person_id, p.event_id

FROM qualified_events P

INNER JOIN

(

  -- Begin Condition Occurrence Criteria

SELECT C.person_id, C.condition_occurrence_id as event_id, C.condition_start_date as start_date, COALESCE(C.condition_end_date, (C.condition_start_date + 1*INTERVAL'1 day')) as end_date, C.CONDITION_CONCEPT_ID as TARGET_CONCEPT_ID, C.visit_occurrence_id

FROM 

(

  SELECT co.* 

  FROM @cdm_database_schema.CONDITION_OCCURRENCE co

  JOIN Codesets codesets on ((co.condition_concept_id = codesets.concept_id and codesets.codeset_id = 0))

) C





-- End Condition Occurrence Criteria



) A on A.person_id = P.person_id and A.START_DATE >= P.OP_START_DATE AND A.START_DATE <= P.OP_END_DATE AND A.START_DATE >= (P.START_DATE + -365*INTERVAL'1 day') AND A.START_DATE <= (P.START_DATE + 0*INTERVAL'1 day')

GROUP BY p.person_id, p.event_id

HAVING COUNT(A.TARGET_CONCEPT_ID) >= 1

-- End Correlated Criteria



  ) CQ on E.person_id = CQ.person_id and E.event_id = CQ.event_id

  GROUP BY E.person_id, E.event_id

  HAVING COUNT(index_id) = 1

) G

-- End Criteria Group

) AC on AC.person_id = pe.person_id AND AC.event_id = pe.event_id

) Results

;
ANALYZE Inclusion_0

;


CREATE TEMP TABLE Inclusion_1


AS
SELECT
1 as inclusion_rule_id, person_id, event_id


FROM
(

  select pe.person_id, pe.event_id

  FROM qualified_events pe

  
JOIN (
-- Begin Criteria Group

select 0 as index_id, person_id, event_id

FROM

(

  select E.person_id, E.event_id 

  FROM qualified_events E

  INNER JOIN

  (

    -- Begin Correlated Criteria

SELECT 0 as index_id, p.person_id, p.event_id

FROM qualified_events P

LEFT JOIN

(

  -- Begin Drug Exposure Criteria

select C.person_id, C.drug_exposure_id as event_id, C.drug_exposure_start_date as start_date, COALESCE(C.drug_exposure_end_date, (C.drug_exposure_start_date + 1*INTERVAL'1 day')) as end_date, C.drug_concept_id as TARGET_CONCEPT_ID, C.visit_occurrence_id

from 

(

  select de.* 

  FROM @cdm_database_schema.DRUG_EXPOSURE de

JOIN Codesets codesets on ((de.drug_concept_id = codesets.concept_id and codesets.codeset_id = 2))

) C





-- End Drug Exposure Criteria



) A on A.person_id = P.person_id and A.START_DATE >= P.OP_START_DATE AND A.START_DATE <= P.OP_END_DATE AND A.START_DATE >= P.OP_START_DATE AND A.START_DATE <= (P.START_DATE + -1*INTERVAL'1 day')

GROUP BY p.person_id, p.event_id

HAVING COUNT(A.TARGET_CONCEPT_ID) = 0

-- End Correlated Criteria



  ) CQ on E.person_id = CQ.person_id and E.event_id = CQ.event_id

  GROUP BY E.person_id, E.event_id

  HAVING COUNT(index_id) = 1

) G

-- End Criteria Group

) AC on AC.person_id = pe.person_id AND AC.event_id = pe.event_id

) Results

;
ANALYZE Inclusion_1

;


CREATE TEMP TABLE Inclusion_2


AS
SELECT
2 as inclusion_rule_id, person_id, event_id


FROM
(

  select pe.person_id, pe.event_id

  FROM qualified_events pe

  
JOIN (
-- Begin Criteria Group

select 0 as index_id, person_id, event_id

FROM

(

  select E.person_id, E.event_id 

  FROM qualified_events E

  INNER JOIN

  (

    -- Begin Correlated Criteria

SELECT 0 as index_id, p.person_id, p.event_id

FROM qualified_events P

INNER JOIN

(

  -- Begin Drug Era Criteria

select C.person_id, C.drug_era_id as event_id, C.drug_era_start_date as start_date, C.drug_era_end_date as end_date, C.drug_concept_id as TARGET_CONCEPT_ID, CAST(NULL as bigint) as visit_occurrence_id

from 

(

  select de.* 

  FROM @cdm_database_schema.DRUG_ERA de

where de.drug_concept_id in (SELECT concept_id from  Codesets where codeset_id = 2)

) C





-- End Drug Era Criteria



) A on A.person_id = P.person_id and A.START_DATE >= P.OP_START_DATE AND A.START_DATE <= P.OP_END_DATE AND A.START_DATE >= (P.START_DATE + 0*INTERVAL'1 day') AND A.START_DATE <= (P.START_DATE + 7*INTERVAL'1 day')

GROUP BY p.person_id, p.event_id

HAVING COUNT(DISTINCT A.TARGET_CONCEPT_ID) = 1

-- End Correlated Criteria



  ) CQ on E.person_id = CQ.person_id and E.event_id = CQ.event_id

  GROUP BY E.person_id, E.event_id

  HAVING COUNT(index_id) = 1

) G

-- End Criteria Group

) AC on AC.person_id = pe.person_id AND AC.event_id = pe.event_id

) Results

;
ANALYZE Inclusion_2

;


CREATE TEMP TABLE inclusion_events

AS
SELECT
inclusion_rule_id, person_id, event_id

FROM
(select inclusion_rule_id, person_id, event_id from Inclusion_0
UNION ALL
select inclusion_rule_id, person_id, event_id from Inclusion_1
UNION ALL
select inclusion_rule_id, person_id, event_id from Inclusion_2) I;
ANALYZE inclusion_events
;
TRUNCATE TABLE Inclusion_0;
DROP TABLE Inclusion_0;

TRUNCATE TABLE Inclusion_1;
DROP TABLE Inclusion_1;

TRUNCATE TABLE Inclusion_2;
DROP TABLE Inclusion_2;




CREATE TEMP TABLE included_events


AS
WITH cteIncludedEvents(event_id, person_id, start_date, end_date, op_start_date, op_end_date, ordinal)  AS (

  SELECT event_id, person_id, start_date, end_date, op_start_date, op_end_date, row_number() over (partition by person_id order by start_date ASC) as ordinal

  from

  (

    select Q.event_id, Q.person_id, Q.start_date, Q.end_date, Q.op_start_date, Q.op_end_date, SUM(coalesce(POWER(cast(2 as bigint), I.inclusion_rule_id), 0)) as inclusion_rule_mask

    from qualified_events Q

    LEFT JOIN inclusion_events I on I.person_id = Q.person_id and I.event_id = Q.event_id

    GROUP BY Q.event_id, Q.person_id, Q.start_date, Q.end_date, Q.op_start_date, Q.op_end_date

  ) MG -- matching groups



  -- the matching group with all bits set ( POWER(2,# of inclusion rules) - 1 = inclusion_rule_mask

  WHERE (MG.inclusion_rule_mask = POWER(cast(2 as bigint),3)-1)



)

 SELECT
event_id, person_id, start_date, end_date, op_start_date, op_end_date


FROM
cteIncludedEvents Results

WHERE Results.ordinal = 1

;
ANALYZE included_events

;



-- custom era strategy



CREATE TEMP TABLE drugTarget


AS
WITH ctePersons(person_id)  AS (

	select distinct person_id from included_events

)



 SELECT
person_id, drug_exposure_start_date, drug_exposure_end_date


FROM
(

	select de.PERSON_ID, DRUG_EXPOSURE_START_DATE,  COALESCE(DRUG_EXPOSURE_END_DATE, (DRUG_EXPOSURE_START_DATE + DAYS_SUPPLY*INTERVAL'1 day'), (DRUG_EXPOSURE_START_DATE + 1*INTERVAL'1 day')) as DRUG_EXPOSURE_END_DATE 

	FROM @cdm_database_schema.DRUG_EXPOSURE de

	JOIN ctePersons p on de.person_id = p.person_id

	JOIN Codesets cs on cs.codeset_id = 3 AND de.drug_concept_id = cs.concept_id



	UNION ALL



	select de.PERSON_ID, DRUG_EXPOSURE_START_DATE,  COALESCE(DRUG_EXPOSURE_END_DATE, (DRUG_EXPOSURE_START_DATE + DAYS_SUPPLY*INTERVAL'1 day'), (DRUG_EXPOSURE_START_DATE + 1*INTERVAL'1 day')) as DRUG_EXPOSURE_END_DATE 

	FROM @cdm_database_schema.DRUG_EXPOSURE de

	JOIN ctePersons p on de.person_id = p.person_id

	JOIN Codesets cs on cs.codeset_id = 3 AND de.drug_source_concept_id = cs.concept_id

) E

;
ANALYZE drugTarget

;



CREATE TEMP TABLE strategy_ends


AS
SELECT
et.event_id, et.person_id, ERAS.era_end_date as end_date


FROM
included_events et

JOIN 

(

  select ENDS.person_id, min(drug_exposure_start_date) as era_start_date, (ENDS.era_end_date + 0*INTERVAL'1 day') as era_end_date

  from

  (

    select de.person_id, de.drug_exposure_start_date, MIN(e.END_DATE) as era_end_date

    FROM drugTarget DE

    JOIN 

    (

      --cteEndDates

      select PERSON_ID, (EVENT_DATE + -1 * 30*INTERVAL'1 day') as END_DATE -- unpad the end date by 30

      FROM

      (

				select PERSON_ID, EVENT_DATE, EVENT_TYPE, 

				MAX(START_ORDINAL) OVER (PARTITION BY PERSON_ID ORDER BY event_date, event_type ROWS UNBOUNDED PRECEDING) AS start_ordinal,

				ROW_NUMBER() OVER (PARTITION BY PERSON_ID ORDER BY EVENT_DATE, EVENT_TYPE) AS OVERALL_ORD -- this re-numbers the inner UNION so all rows are numbered ordered by the event date

				from

				(

					-- select the start dates, assigning a row number to each

					Select PERSON_ID, DRUG_EXPOSURE_START_DATE AS EVENT_DATE, 0 as EVENT_TYPE, ROW_NUMBER() OVER (PARTITION BY PERSON_ID ORDER BY DRUG_EXPOSURE_START_DATE) as START_ORDINAL

					from drugTarget D



					UNION ALL



					-- add the end dates with NULL as the row number, padding the end dates by 30 to allow a grace period for overlapping ranges.

					select PERSON_ID, (DRUG_EXPOSURE_END_DATE + 30*INTERVAL'1 day'), 1 as EVENT_TYPE, NULL

					FROM drugTarget D

				) RAWDATA

      ) E

      WHERE 2 * E.START_ORDINAL - E.OVERALL_ORD = 0

    ) E on DE.PERSON_ID = E.PERSON_ID and E.END_DATE >= DE.DRUG_EXPOSURE_START_DATE

    GROUP BY de.person_id, de.drug_exposure_start_date

  ) ENDS

  GROUP BY ENDS.person_id, ENDS.era_end_date

) ERAS on ERAS.person_id = et.person_id 

WHERE et.start_date between ERAS.era_start_date and ERAS.era_end_date;
ANALYZE strategy_ends

;



TRUNCATE TABLE drugTarget;

DROP TABLE drugTarget;





-- generate cohort periods into #final_cohort

CREATE TEMP TABLE cohort_rows


AS
WITH cohort_ends (event_id, person_id, end_date)  AS (

	-- cohort exit dates

  -- By default, cohort exit at the event's op end date
select event_id, person_id, op_end_date as end_date from included_events
UNION ALL
-- End Date Strategy
SELECT event_id, person_id, end_date from strategy_ends


),

first_ends (person_id, start_date, end_date) as

(

	select F.person_id, F.start_date, F.end_date

	FROM (

	  select I.event_id, I.person_id, I.start_date, E.end_date, row_number() over (partition by I.person_id, I.event_id order by E.end_date) as ordinal 

	  from included_events I

	  join cohort_ends E on I.event_id = E.event_id and I.person_id = E.person_id and E.end_date >= I.start_date

	) F

	WHERE F.ordinal = 1

)

 SELECT
person_id, start_date, end_date


FROM
first_ends;
ANALYZE cohort_rows

;



CREATE TEMP TABLE final_cohort


AS
WITH cteEndDates (person_id, end_date)  AS (	

	SELECT

		person_id

		, (event_date + -1 * 0*INTERVAL'1 day')  as end_date

	FROM

	(

		SELECT

			person_id

			, event_date

			, event_type

			, MAX(start_ordinal) OVER (PARTITION BY person_id ORDER BY event_date, event_type ROWS UNBOUNDED PRECEDING) AS start_ordinal 

			, ROW_NUMBER() OVER (PARTITION BY person_id ORDER BY event_date, event_type) AS overall_ord

		FROM

		(

			SELECT

				person_id

				, start_date AS event_date

				, -1 AS event_type

				, ROW_NUMBER() OVER (PARTITION BY person_id ORDER BY start_date) AS start_ordinal

			FROM cohort_rows

		

			UNION ALL

		



			SELECT

				person_id

				, (end_date + 0*INTERVAL'1 day') as end_date

				, 1 AS event_type

				, NULL

			FROM cohort_rows

		) RAWDATA

	) e

	WHERE (2 * e.start_ordinal) - e.overall_ord = 0

),

cteEnds (person_id, start_date, end_date) AS

(

	SELECT

		 c.person_id

		, c.start_date

		, MIN(e.end_date) AS era_end_date

	FROM cohort_rows c

	JOIN cteEndDates e ON c.person_id = e.person_id AND e.end_date >= c.start_date

	GROUP BY c.person_id, c.start_date

)

 SELECT
person_id, min(start_date) as start_date, end_date


FROM
cteEnds

group by person_id, end_date

;
ANALYZE final_cohort

;



DELETE FROM @target_database_schema.@target_cohort_table where cohort_definition_id = @target_cohort_id;

INSERT INTO @target_database_schema.@target_cohort_table (cohort_definition_id, subject_id, cohort_start_date, cohort_end_date)

select @target_cohort_id as cohort_definition_id, person_id, start_date, end_date 
FROM final_cohort CO

;







TRUNCATE TABLE strategy_ends;
DROP TABLE strategy_ends;




TRUNCATE TABLE cohort_rows;

DROP TABLE cohort_rows;



TRUNCATE TABLE final_cohort;

DROP TABLE final_cohort;



TRUNCATE TABLE inclusion_events;

DROP TABLE inclusion_events;



TRUNCATE TABLE qualified_events;

DROP TABLE qualified_events;



TRUNCATE TABLE included_events;

DROP TABLE included_events;



TRUNCATE TABLE Codesets;

DROP TABLE Codesets;

