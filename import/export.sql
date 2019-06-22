-----------------------------------
-- generate list of concepts included
CREATE TEMPORARY TABLE concepts (id INTEGER);
\copy concepts FROM 'concepts.csv' WITH CSV HEADER;
-----------------------------------
-- generate data files
\copy (SELECT * FROM relationship WHERE relationship_id in ('Is a', 'Subsumes') ORDER BY relationship_id) TO 'relationship.csv' WITH CSV HEADER;
\copy (SELECT * FROM concept WHERE concept_id in (SELECT id FROM concepts) ORDER BY concept_id) TO 'concept.csv' WITH CSV HEADER;
\copy (SELECT * FROM vocabulary WHERE vocabulary_id in ('Concept Class','Vocabulary','Domain','SNOMED','Relationship','Gender','Race','Ethnicity','Visit','None','Visit Type','Obs Period Type','CMS Place of Service') ORDER BY vocabulary_id) TO 'vocabulary.csv' WITH CSV HEADER;
\copy (SELECT * FROM domain WHERE domain_id in ('Metadata','Condition','Gender','Race','Ethnicity','Visit','Type Concept') ORDER BY domain_id) TO 'domain.csv' WITH CSV HEADER;
\copy (SELECT * FROM concept_class WHERE concept_class_id in ('Vocabulary','Concept Class','Domain','Clinical Finding','Relationship','Model Comp','Gender','Race','Ethnicity','Visit','Undefined','Visit Type','Obs Period Type') ORDER BY concept_class_id) TO 'concept_class.csv' WITH CSV HEADER;
\copy (SELECT * FROM location WHERE location_id in (116) order by location_id) TO 'location.csv' WITH CSV HEADER;
\copy (SELECT * FROM person WHERE person_id in (107680) order by person_id) TO 'person.csv'  WITH CSV HEADER;
\copy (SELECT * FROM observation_period WHERE person_id in (107680) order by observation_period_id) TO 'observation_period.csv'  WITH CSV HEADER;
\copy (SELECT * FROM provider where provider_id in (select provider_id from visit_occurrence where person_id = 107680) order by provider_id) TO 'provider.csv'  WITH CSV HEADER;
\copy (select * from care_site where care_site_id in ((select care_site_id from provider where provider_id in (select provider_id from visit_occurrence where person_id = 107680)) union (select care_site_id from visit_occurrence where person_id = 107680)) order by care_site_id) TO 'care_site.csv'  WITH CSV HEADER;
\copy (SELECT * FROM visit_occurrence WHERE person_id in (107680) order by visit_occurrence_id) TO 'visit_occurrence.csv'  WITH CSV HEADER;
\copy (SELECT * FROM concept_ancestor WHERE descendant_concept_id in (SELECT id FROM concepts) ORDER BY ancestor_concept_id, descendant_concept_id) TO 'concept_ancestor.csv' WITH CSV HEADER;
\copy (SELECT * FROM concept_relationship WHERE concept_id_1 in (SELECT id FROM concepts) AND relationship_id IN ('Is a') ORDER BY concept_id_1, concept_id_2) TO 'concept_relationship.csv' WITH CSV HEADER;
