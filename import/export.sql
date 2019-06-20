\copy (SELECT * FROM concept WHERE concept_id in (44819025,44819232,7,44819279,44819147,44819233,44819247) ORDER BY concept_id) TO 'concept.csv' WITH CSV HEADER
\copy (SELECT * FROM vocabulary WHERE vocabulary_id in ('Concept Class','Vocabulary','Domain') ORDER BY vocabulary_id) TO 'vocabulary.csv' WITH CSV HEADER
\copy (SELECT * FROM domain WHERE domain_id in ('Metadata') ORDER BY domain_id) TO 'domain.csv' WITH CSV HEADER
\copy (SELECT * FROM concept_class WHERE concept_class_id in ('Vocabulary','Concept Class','Domain') ORDER BY concept_class_id) TO 'concept_class.csv' WITH CSV HEADER
