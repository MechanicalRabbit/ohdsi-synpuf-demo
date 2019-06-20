CREATE TEMPORARY TABLE concepts (id INTEGER);
INSERT INTO concepts(id) values (44819025), (44819232), (7), (44819279), (44819147), (44819233), (44819247);
\copy (SELECT * FROM concept WHERE concept_id in (SELECT id FROM concepts) ORDER BY concept_id) TO 'concept.csv' WITH CSV HEADER
\copy (SELECT * FROM concept_ancestor WHERE descendant_concept_id in (SELECT id FROM concepts) ORDER BY descendant_concept_id) TO 'concept_ancestor.csv' WITH CSV HEADER
\copy (SELECT * FROM concept_relationship WHERE concept_id_1 in (SELECT id FROM concepts) ORDER BY concept_id_1) TO 'concept_relationship.csv' WITH CSV HEADER
\copy (SELECT * FROM vocabulary WHERE vocabulary_id in ('Concept Class','Vocabulary','Domain') ORDER BY vocabulary_id) TO 'vocabulary.csv' WITH CSV HEADER
\copy (SELECT * FROM domain WHERE domain_id in ('Metadata') ORDER BY domain_id) TO 'domain.csv' WITH CSV HEADER
\copy (SELECT * FROM concept_class WHERE concept_class_id in ('Vocabulary','Concept Class','Domain') ORDER BY concept_class_id) TO 'concept_class.csv' WITH CSV HEADER
