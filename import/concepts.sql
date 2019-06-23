-----------------------------------
-- generate list of concepts included
CREATE TEMPORARY TABLE concepts (id INTEGER);
INSERT INTO concepts(id) values (44819025), (44819232), (7), (44819279), (44819147), (44819233), (44819247), (44819097), (44818997), (44818821), (19), (44818723), (44819235), (44819274), (44819058), (56), (44819246), (44819123);
INSERT INTO concepts(id) values (316866); -- Hypertensive Disorder
INSERT INTO concepts(id) values (45768449); -- Hypertensive Crisis
INSERT INTO concepts(id) values (38003564), (8532), (8527); -- Person 107680.
INSERT INTO concepts(id) values (4), (44819134), (44819035), (44819108), (44819086), (2), (44819109), (44819030), (3);
INSERT INTO concepts(id) values (0), (8507);
INSERT INTO concepts(id) values (262),(9203),(9201),(44819119),(44819023),(9201),(9202),(44818517),(44819119),(44819023), (8), (44819044), (44819096), (44819039), (58), (44819150); -- Visit concepts
INSERT INTO concepts(id) values (44814722), (44819149), (44819062); -- Observational Period
INSERT INTO concepts(id) values (8717), (8756), (8940), (44819110);

INSERT INTO concepts(id) values (4329847), (444406); -- Myocardial infarction
INSERT INTO concepts(id) values (444406), (38000200), (44825429), (44819127), (44819248), (5046), (45754877), (45754870), (45754876); -- condition_occurrence

-- calculate ancestor concepts
WITH RECURSIVE t(n) AS (
    SELECT id FROM concepts
  UNION ALL
    SELECT concept_id_2 as id FROM concept_relationship, t
    WHERE t.n = concept_relationship.concept_id_1
      AND concept_relationship.relationship_id = 'Is a'
)
INSERT INTO concepts(id)
 SELECT DISTINCT n FROM t
  EXCEPT SELECT id from concepts;

\copy (SELECT * FROM concepts ORDER by id) TO 'concepts.csv' CSV HEADER;
