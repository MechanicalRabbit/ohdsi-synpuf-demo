-----------------------------------
CREATE TEMPORARY TABLE concepts (id INTEGER);
\copy concepts FROM 'concepts.csv' WITH CSV HEADER;
-----------------------------------
\copy (SELECT * FROM relationship WHERE relationship_id in ('Is a', 'Subsumes') ORDER BY relationship_id) TO 'relationship.csv' WITH CSV HEADER;
\copy (SELECT * FROM concept WHERE concept_id in (SELECT id FROM concepts) ORDER BY concept_id) TO 'concept.csv' WITH CSV HEADER;
\copy (SELECT * FROM vocabulary WHERE vocabulary_id in ('Concept Class','Vocabulary','Domain','SNOMED','Relationship','Gender','Race','Ethnicity','Visit','None','Visit Type','Obs Period Type','CMS Place of Service','Cohort', 'Condition Type','ICD9CM') ORDER BY vocabulary_id) TO 'vocabulary.csv' WITH CSV HEADER;
\copy (SELECT * FROM domain WHERE domain_id in ('Metadata','Condition','Gender','Race','Ethnicity','Visit','Type Concept') ORDER BY domain_id) TO 'domain.csv' WITH CSV HEADER;
\copy (SELECT * FROM concept_class WHERE concept_class_id in ('Vocabulary','Concept Class','Domain','Clinical Finding','Relationship','Model Comp','Gender','Race','Ethnicity','Visit','Undefined','Visit Type','Obs Period Type','Cohort','Condition Type','4-dig nonbill code','5-dig billing code','3-dig nonbill code') ORDER BY concept_class_id) TO 'concept_class.csv' WITH CSV HEADER;
---------------------------------------------
CREATE TEMPORARY TABLE visit_concepts AS
    SELECT descendant_concept_id AS id
      FROM concept_ancestor
     WHERE ancestor_concept_id IN (262,9203,9201);
CREATE TEMPORARY TABLE condition_concepts AS
    SELECT descendant_concept_id AS id
      FROM concept_ancestor
     WHERE ancestor_concept_id IN (4329847);
CREATE TEMPORARY TABLE conditions AS
    SELECT * from condition_occurrence
     WHERE person_id IN ( 107680, 95538, 46608, 1780)
       AND condition_concept_id IN (SELECT id from condition_concepts);
CREATE TEMPORARY TABLE persons AS
    SELECT * FROM person
      WHERE person_id IN (SELECT person_id FROM conditions);
CREATE TEMPORARY TABLE nearby_visits AS
    SELECT * FROM visit_occurrence O
      WHERE O.person_id IN (SELECT person_id FROM conditions)
        AND O.visit_concept_id IN (SELECT id from visit_concepts)
        AND EXISTS (
               SELECT 'X'
                 FROM conditions C
                WHERE C.person_id IN (SELECT person_id FROM conditions)
                  AND C.condition_start_date >= O.visit_start_date
                  AND COALESCE(C.condition_end_date, 
                          C.condition_start_date + 0*INTERVAL'1 day')
                      <= O.visit_end_date);
CREATE TEMPORARY TABLE visits AS (
    SELECT * from visit_occurrence
     WHERE visit_occurrence_id IN
         (SELECT visit_occurrence_id FROM conditions)
    UNION SELECT * FROM nearby_visits);
CREATE TEMPORARY TABLE providers AS
    SELECT * FROM provider
     WHERE provider_id IN (
        (SELECT provider_id FROM conditions)
           UNION
        (SELECT provider_id FROM visits));
CREATE TEMPORARY TABLE caresites AS
    SELECT * FROM care_site
     WHERE care_site_id IN (
        (SELECT care_site_id FROM persons)
           UNION
        (SELECT care_site_id FROM providers)
           UNION
        (SELECT care_site_id FROM visits));
CREATE TEMPORARY TABLE locations AS
    SELECT * FROM location
     WHERE location_id IN (
        (SELECT location_id FROM caresites)
           UNION
        (SELECT location_id FROM persons));
CREATE TEMPORARY TABLE periods AS
    SELECT * FROM observation_period
     WHERE person_id IN (
        SELECT person_id from persons);

\copy (select * from conditions order by condition_occurrence_id) TO 'condition_occurrence.csv'  WITH CSV HEADER;
\copy (SELECT * FROM visits order by visit_occurrence_id) TO 'visit_occurrence.csv'  WITH CSV HEADER;
\copy (SELECT * FROM persons order by person_id) TO 'person.csv'  WITH CSV HEADER;
\copy (SELECT * FROM providers order by provider_id) TO 'provider.csv'  WITH CSV HEADER;
\copy (select * from caresites order by care_site_id) TO 'care_site.csv'  WITH CSV HEADER;
\copy (SELECT * FROM locations order by location_id) TO 'location.csv' WITH CSV HEADER;
\copy (SELECT * FROM periods order by observation_period_id) TO 'observation_period.csv'  WITH CSV HEADER;

----
\copy (SELECT * FROM concept_ancestor WHERE descendant_concept_id in (SELECT id FROM concepts) AND ancestor_concept_id in (SELECT id from concepts) ORDER BY ancestor_concept_id, descendant_concept_id) TO 'concept_ancestor.csv' WITH CSV HEADER;
\copy (SELECT * FROM concept_relationship WHERE concept_id_1 in (SELECT id FROM concepts) AND concept_id_2 in (SELECT id FROM concepts) AND relationship_id IN ('Is a') ORDER BY concept_id_1, concept_id_2) TO 'concept_relationship.csv' WITH CSV HEADER;
