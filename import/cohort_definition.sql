INSERT INTO cohort_definition (cohort_definition_id,definition_type_concept_id,subject_concept_id,cohort_definition_name)
VALUES 
(1770673,44819246,56,'Angioedema events'),
(1770674,44819246,56,'Acute myocardial infarction events'),
(1770675,44819246,56,'New users of ACE inhibitors as first-line monotherapy for hypertension'),
(1770676,44819246,56,'New users of Thiazide-like diuretics as first-line monotherapy for hypertension');

CREATE OR REPLACE VIEW cohort_ang AS (select * from cohort where
    cohort_definition_id = 1770673);
CREATE OR REPLACE VIEW cohort_ami AS (select * from cohort where
    cohort_definition_id = 1770674);
CREATE OR REPLACE VIEW cohort_ace AS (select * from cohort where
    cohort_definition_id = 1770675);
CREATE OR REPLACE VIEW cohort_dia AS (select * from cohort where
    cohort_definition_id = 1770676);
CREATE OR REPLACE VIEW cohort_all AS (select * from cohort where
    cohort_definition_id IN (1770673,1770674,1770675,1770676));
