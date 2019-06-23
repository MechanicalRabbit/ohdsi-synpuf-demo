-----------------------------------
-- generate list of concepts included
CREATE TEMPORARY TABLE concepts (id INTEGER);
INSERT INTO concepts(id) values (44819025), (44819232), (7), (44819279), (44819147), (44819233), (44819247), (44819097), (44818997), (44818821), (19), (44818723), (44819235), (44819274), (44819058), (56), (44819246), (44819123);
INSERT INTO concepts(id) values (38003564), (8532), (8527); -- Person 107680.
INSERT INTO concepts(id) values (4), (44819134), (44819035), (44819108), (44819086), (2), (44819109), (44819030), (3);
INSERT INTO concepts(id) values (262),(9203),(9201),(44819119),(44819023),(9201),(9202),(44818517),(44819119),(44819023), (8), (44819044), (44819096), (44819039), (58), (44819150); -- Visit concepts
INSERT INTO concepts(id) values (44814722), (44819149), (44819062); -- Observational Period
INSERT INTO concepts(id) values (8717), (8756), (8940), (44819110);

INSERT INTO concepts(id) values (4329847), (444406); -- Myocardial infarction
INSERT INTO concepts(id) values (444406), (38000200), (44825429), (44819127), (44819248), (5046), (45754877), (45754870), (45754876); -- condition_occurrence
INSERT INTO concepts(id) values (0), (8507), (8516); 
INSERT INTO concepts(id) values (38000230), (44835928), (312327), (438438), (44820858), (438170), (44832374), (434376), (44819697);

INSERT INTO concepts(id) values (316866); -- Hypertensive Disorder
INSERT INTO concepts(id) values (45768449); -- Hypertensive Crisis
INSERT INTO concepts(id) values (319826), (317895), (318437), (44835925), (44830078), (44824236), (317898), (44823109), (44830637), (45754869);


INSERT INTO concepts(id) values (44819126), (13), (44819252), (44819104), (44819028), (44819105), (44819243), (44819063), (44818981);
-- Antihypertensives & ACE drug concepts
INSERT INTO concepts(id) values (40174825), (38000175), (45039771), (19019044), (45082806), (19074673), (45036483), (1395073), (44841767), (1334459), (44941256), (19080128), (44948932), (19080129), (44922810), (44922810), (44981339), (40165773), (44871708), (40165773), (44871708), (1347386), (45159452), (19078106), (45336217), (907020), (45243001), (44967315);
-- Antihypertensive & ACE ingredient concepts
INSERT INTO concepts(id) values (907013), (974166), (974166), (1308216), (1308216), (1334456), (1340128), (1341927), (1347384), (1373928), (1395058);
-- Thiazine diuretic
INSERT INTO concepts(id) values (1395058), (974166), (978555), (907013);

-- calculate ancestor concepts
WITH RECURSIVE t(n) AS (
    SELECT id FROM concepts
  UNION ALL
    SELECT concept_id_2 as id
      FROM concept_relationship, t, concept
    WHERE t.n = concept_relationship.concept_id_1
      AND concept_relationship.relationship_id = 'Is a'
      AND concept_relationship.concept_id_2 = concept.concept_id
      AND concept.vocabulary_id != 'SNOMED'
)
INSERT INTO concepts(id)
 SELECT DISTINCT n FROM t
  EXCEPT SELECT id from concepts;

\copy (SELECT * FROM concepts ORDER by id) TO 'concepts.csv' CSV HEADER;
