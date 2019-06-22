

CREATE TEMP TABLE Codesets  (codeset_id int NOT NULL,

  concept_id bigint NOT NULL

)

;



INSERT INTO Codesets (codeset_id, concept_id)
SELECT 0 as codeset_id, c.concept_id FROM (select distinct I.concept_id FROM

( 

  select concept_id from CONCEPT where concept_id in (432791)and invalid_reason is null

UNION  select c.concept_id

  from CONCEPT c

  join CONCEPT_ANCESTOR ca on c.concept_id = ca.descendant_concept_id

  and ca.ancestor_concept_id in (432791)

  and c.invalid_reason is null



) I

) C;
INSERT INTO Codesets (codeset_id, concept_id)
SELECT 1 as codeset_id, c.concept_id FROM (select distinct I.concept_id FROM

( 

  select concept_id from CONCEPT where concept_id in (262,9203,9201)and invalid_reason is null

UNION  select c.concept_id

  from CONCEPT c

  join CONCEPT_ANCESTOR ca on c.concept_id = ca.descendant_concept_id

  and ca.ancestor_concept_id in (262,9203,9201)

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

  -- Begin Condition Occurrence Criteria

SELECT C.person_id, C.condition_occurrence_id as event_id, C.condition_start_date as start_date, COALESCE(C.condition_end_date, (C.condition_start_date + 1*INTERVAL'1 day')) as end_date, C.CONDITION_CONCEPT_ID as TARGET_CONCEPT_ID, C.visit_occurrence_id

FROM 

(

  SELECT co.* 

  FROM CONDITION_OCCURRENCE co

  JOIN Codesets codesets on ((co.condition_concept_id = codesets.concept_id and codesets.codeset_id = 0))

) C





-- End Condition Occurrence Criteria



  ) E

	JOIN observation_period OP on E.person_id = OP.person_id and E.start_date >=  OP.observation_period_start_date and E.start_date <= op.observation_period_end_date

  WHERE (OP.OBSERVATION_PERIOD_START_DATE + 0*INTERVAL'1 day') <= E.START_DATE AND (E.START_DATE + 0*INTERVAL'1 day') <= OP.OBSERVATION_PERIOD_END_DATE

) P



-- End Primary Events



)

 SELECT
event_id, person_id, start_date, end_date, op_start_date, op_end_date, visit_occurrence_id


FROM
(

  select pe.event_id, pe.person_id, pe.start_date, pe.end_date, pe.op_start_date, pe.op_end_date, row_number() over (partition by pe.person_id order by pe.start_date ASC) as ordinal, cast(pe.visit_occurrence_id as bigint) as visit_occurrence_id

  FROM primary_events pe

  
JOIN (
-- Begin Criteria Group

select 0 as index_id, person_id, event_id

FROM

(

  select E.person_id, E.event_id 

  FROM primary_events E

  INNER JOIN

  (

    -- Begin Correlated Criteria

SELECT 0 as index_id, p.person_id, p.event_id

FROM primary_events P

INNER JOIN

(

  -- Begin Visit Occurrence Criteria

select C.person_id, C.visit_occurrence_id as event_id, C.visit_start_date as start_date, C.visit_end_date as end_date, C.visit_concept_id as TARGET_CONCEPT_ID, C.visit_occurrence_id

from 

(

  select vo.* 

  FROM VISIT_OCCURRENCE vo

JOIN Codesets codesets on ((vo.visit_concept_id = codesets.concept_id and codesets.codeset_id = 1))

) C





-- End Visit Occurrence Criteria



) A on A.person_id = P.person_id and A.START_DATE >= P.OP_START_DATE AND A.START_DATE <= P.OP_END_DATE AND A.START_DATE >= P.OP_START_DATE AND A.START_DATE <= (P.START_DATE + 0*INTERVAL'1 day') AND A.END_DATE >= (P.START_DATE + 0*INTERVAL'1 day') AND A.END_DATE <= P.OP_END_DATE

GROUP BY p.person_id, p.event_id

HAVING COUNT(A.TARGET_CONCEPT_ID) >= 1

-- End Correlated Criteria



  ) CQ on E.person_id = CQ.person_id and E.event_id = CQ.event_id

  GROUP BY E.person_id, E.event_id

  HAVING COUNT(index_id) = 1

) G

-- End Criteria Group

) AC on AC.person_id = pe.person_id and AC.event_id = pe.event_id


) QE



;
ANALYZE qualified_events

;



--- Inclusion Rule Inserts



CREATE TEMP TABLE inclusion_events  (inclusion_rule_id bigint,
	person_id bigint,
	event_id bigint
);



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



)

 SELECT
event_id, person_id, start_date, end_date, op_start_date, op_end_date


FROM
cteIncludedEvents Results



;
ANALYZE included_events

;



-- date offset strategy



CREATE TEMP TABLE strategy_ends


AS
SELECT
event_id, person_id, 

  case when (start_date + 7*INTERVAL'1 day') > start_date then (start_date + 7*INTERVAL'1 day') else start_date end as end_date


FROM
included_events;
ANALYZE strategy_ends

;





-- generate cohort periods into #final_cohort

CREATE TEMP TABLE cohort_rows


AS
WITH cohort_ends (event_id, person_id, end_date)  AS (

	-- cohort exit dates

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

		, (event_date + -1 * 30*INTERVAL'1 day')  as end_date

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

				, (end_date + 30*INTERVAL'1 day') as end_date

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



DELETE FROM cohort where cohort_definition_id = 1770673;

INSERT INTO cohort (cohort_definition_id, subject_id, cohort_start_date, cohort_end_date)

select 1770673 as cohort_definition_id, person_id, start_date, end_date 
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

