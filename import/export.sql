-----------------------------------
-- generate list of concepts included
CREATE TEMPORARY TABLE concepts (id INTEGER);
INSERT INTO concepts(id) values (44819025), (44819232), (7), (44819279), (44819147), (44819233), (44819247), (44819097), (44818997), (44818821), (19), (44818723), (44819235), (44819274);

--, (316866), (40398391), (134057);

-- calculate ancestor concepts
WITH RECURSIVE t(n) AS (
    SELECT id FROM concepts
  UNION ALL
    SELECT concept_id_2 as id FROM concept_relationship, t WHERE t.n = concept_relationship.concept_id_1 and concept_relationship.relationship_id = 'Is a'
)
INSERT INTO concepts(id) SELECT DISTINCT n FROM t;
WITH RECURSIVE t(n) AS (
    SELECT id FROM concepts
  UNION ALL
    SELECT ancestor_concept_id as id FROM concept_ancestor, t WHERE t.n = concept_ancestor.descendant_concept_id
)
INSERT INTO concepts(id) SELECT DISTINCT n FROM t;

-----------------------------------
-- generate data files
\copy (SELECT * FROM relationship WHERE relationship_id in ('Is a', 'Subsumes') ORDER BY relationship_id) TO 'relationship.csv' WITH CSV HEADER
\copy (SELECT * FROM concept WHERE concept_id in (SELECT id FROM concepts) ORDER BY concept_id) TO 'concept.csv' WITH CSV HEADER
\copy (SELECT * FROM vocabulary WHERE vocabulary_id in ('Concept Class','Vocabulary','Domain','SNOMED','Relationship') ORDER BY vocabulary_id) TO 'vocabulary.csv' WITH CSV HEADER
\copy (SELECT * FROM domain WHERE domain_id in ('Metadata','Condition') ORDER BY domain_id) TO 'domain.csv' WITH CSV HEADER
\copy (SELECT * FROM concept_class WHERE concept_class_id in ('Vocabulary','Concept Class','Domain','Clinical Finding','Relationship') ORDER BY concept_class_id) TO 'concept_class.csv' WITH CSV HEADER
\copy (SELECT * FROM concept_ancestor WHERE descendant_concept_id in (SELECT id FROM concepts) ORDER BY descendant_concept_id) TO 'concept_ancestor.csv' WITH CSV HEADER
\copy (SELECT * FROM concept_relationship WHERE concept_id_1 in (SELECT id FROM concepts) AND relationship_id IN ('Is a') ORDER BY concept_id_1) TO 'concept_relationship.csv' WITH CSV HEADER
