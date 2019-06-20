-----------------------------------
-- generate list of concepts included
CREATE TEMPORARY TABLE concepts (id INTEGER);
INSERT INTO concepts(id) values (44819025), (44819232), (7), (44819279), (44819147), (44819233), (44819247), (44819097), (44818997), (44818821), (19), (44818723), (44819235), (44819274);
--INSERT INTO concepts(id) values (316866); -- Hypertensive Disorder

-- calculate ancestor concepts
WITH RECURSIVE t(n) AS (
    SELECT id FROM concepts
  UNION ALL
    SELECT concept_id_2 as id FROM concept_relationship, t WHERE t.n = concept_relationship.concept_id_1 and concept_relationship.relationship_id = 'Is a'
)
INSERT INTO concepts(id)
 SELECT DISTINCT n FROM t
  EXCEPT SELECT id from concepts;
WITH RECURSIVE t(n) AS (
    SELECT id FROM concepts
  UNION ALL
    SELECT ancestor_concept_id as id FROM concept_ancestor, t WHERE t.n = concept_ancestor.descendant_concept_id
)
INSERT INTO concepts(id)
 SELECT DISTINCT n FROM t
  EXCEPT SELECT id from concepts;
\copy (SELECT * FROM concepts) TO 'concepts.csv' CSV HEADER;
