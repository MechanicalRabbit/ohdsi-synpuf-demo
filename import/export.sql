-----------------------------------
-- generate list of concepts included
CREATE TEMPORARY TABLE concepts (id INTEGER);
\copy concepts FROM 'concepts.csv' WITH CSV HEADER;
-----------------------------------
-- generate data files
\copy (SELECT * FROM relationship WHERE relationship_id in ('Is a', 'Subsumes') ORDER BY relationship_id) TO 'relationship.csv' WITH CSV HEADER
\copy (SELECT * FROM concept WHERE concept_id in (SELECT id FROM concepts) ORDER BY concept_id) TO 'concept.csv' WITH CSV HEADER
\copy (SELECT * FROM vocabulary WHERE vocabulary_id in ('Concept Class','Vocabulary','Domain','SNOMED','Relationship') ORDER BY vocabulary_id) TO 'vocabulary.csv' WITH CSV HEADER
\copy (SELECT * FROM domain WHERE domain_id in ('Metadata','Condition') ORDER BY domain_id) TO 'domain.csv' WITH CSV HEADER
\copy (SELECT * FROM concept_class WHERE concept_class_id in ('Vocabulary','Concept Class','Domain','Clinical Finding','Relationship') ORDER BY concept_class_id) TO 'concept_class.csv' WITH CSV HEADER
\copy (SELECT * FROM concept_ancestor WHERE descendant_concept_id in (SELECT id FROM concepts) ORDER BY descendant_concept_id) TO 'concept_ancestor.csv' WITH CSV HEADER
\copy (SELECT * FROM concept_relationship WHERE concept_id_1 in (SELECT id FROM concepts) AND relationship_id IN ('Is a') ORDER BY concept_id_1) TO 'concept_relationship.csv' WITH CSV HEADER
