


CREATE TABLE attribute_definition (
    attribute_definition_id integer NOT NULL,
    attribute_name character varying(255) NOT NULL,
    attribute_description text,
    attribute_type_concept_id integer NOT NULL,
    attribute_syntax text
);



CREATE TABLE care_site (
    care_site_id integer NOT NULL,
    care_site_name character varying(255),
    place_of_service_concept_id integer,
    location_id integer,
    care_site_source_value character varying(50),
    place_of_service_source_value character varying(50)
);



CREATE TABLE cdm_source (
    cdm_source_name character varying(255) NOT NULL,
    cdm_source_abbreviation character varying(25),
    cdm_holder character varying(255),
    source_description text,
    source_documentation_reference character varying(255),
    cdm_etl_reference character varying(255),
    source_release_date date,
    cdm_release_date date,
    cdm_version character varying(10),
    vocabulary_version character varying(20)
);



CREATE TABLE cohort (
    cohort_definition_id integer NOT NULL,
    subject_id integer NOT NULL,
    cohort_start_date date NOT NULL,
    cohort_end_date date NOT NULL
);



CREATE VIEW cohort_ace AS
 SELECT cohort.cohort_definition_id,
    cohort.subject_id,
    cohort.cohort_start_date,
    cohort.cohort_end_date
   FROM cohort
  WHERE (cohort.cohort_definition_id = 1770675);



CREATE VIEW cohort_all AS
 SELECT cohort.cohort_definition_id,
    cohort.subject_id,
    cohort.cohort_start_date,
    cohort.cohort_end_date
   FROM cohort
  WHERE (cohort.cohort_definition_id = ANY (ARRAY[1770673, 1770674, 1770675, 1770676]));



CREATE VIEW cohort_ami AS
 SELECT cohort.cohort_definition_id,
    cohort.subject_id,
    cohort.cohort_start_date,
    cohort.cohort_end_date
   FROM cohort
  WHERE (cohort.cohort_definition_id = 1770674);



CREATE VIEW cohort_ang AS
 SELECT cohort.cohort_definition_id,
    cohort.subject_id,
    cohort.cohort_start_date,
    cohort.cohort_end_date
   FROM cohort
  WHERE (cohort.cohort_definition_id = 1770673);



CREATE TABLE cohort_attribute (
    cohort_definition_id integer NOT NULL,
    cohort_start_date date NOT NULL,
    cohort_end_date date NOT NULL,
    subject_id integer NOT NULL,
    attribute_definition_id integer NOT NULL,
    value_as_number numeric,
    value_as_concept_id integer
);



CREATE TABLE cohort_definition (
    cohort_definition_id integer NOT NULL,
    cohort_definition_name character varying(255) NOT NULL,
    cohort_definition_description text,
    definition_type_concept_id integer NOT NULL,
    cohort_definition_syntax text,
    subject_concept_id integer NOT NULL,
    cohort_initiation_date date
);



CREATE VIEW cohort_dia AS
 SELECT cohort.cohort_definition_id,
    cohort.subject_id,
    cohort.cohort_start_date,
    cohort.cohort_end_date
   FROM cohort
  WHERE (cohort.cohort_definition_id = 1770676);



CREATE TABLE concept (
    concept_id integer NOT NULL,
    concept_name character varying(255) NOT NULL,
    domain_id character varying(20) NOT NULL,
    vocabulary_id character varying(20) NOT NULL,
    concept_class_id character varying(20) NOT NULL,
    standard_concept character varying(1),
    concept_code character varying(50) NOT NULL,
    valid_start_date date NOT NULL,
    valid_end_date date NOT NULL,
    invalid_reason character varying(1)
);



CREATE TABLE concept_ancestor (
    ancestor_concept_id integer NOT NULL,
    descendant_concept_id integer NOT NULL,
    min_levels_of_separation integer NOT NULL,
    max_levels_of_separation integer NOT NULL
);



CREATE TABLE condition_occurrence (
    condition_occurrence_id integer NOT NULL,
    person_id integer NOT NULL,
    condition_concept_id integer NOT NULL,
    condition_start_date date NOT NULL,
    condition_end_date date,
    condition_type_concept_id integer NOT NULL,
    stop_reason character varying(20),
    provider_id integer,
    visit_occurrence_id bigint,
    condition_source_value character varying(50),
    condition_source_concept_id integer
);




CREATE TABLE concept_class (
    concept_class_id character varying(20) NOT NULL,
    concept_class_name character varying(255) NOT NULL,
    concept_class_concept_id integer NOT NULL
);



CREATE TABLE concept_relationship (
    concept_id_1 integer NOT NULL,
    concept_id_2 integer NOT NULL,
    relationship_id character varying(20) NOT NULL,
    valid_start_date date NOT NULL,
    valid_end_date date NOT NULL,
    invalid_reason character varying(1)
);



CREATE TABLE concept_synonym (
    concept_id integer NOT NULL,
    concept_synonym_name character varying(1000) NOT NULL,
    language_concept_id integer NOT NULL
);



CREATE SEQUENCE condition_era_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



CREATE TABLE condition_era (
    condition_era_id integer DEFAULT nextval('condition_era_sequence'::regclass) NOT NULL,
    person_id integer NOT NULL,
    condition_concept_id integer NOT NULL,
    condition_era_start_date date NOT NULL,
    condition_era_end_date date NOT NULL,
    condition_occurrence_count integer
);



CREATE TABLE death (
    person_id integer NOT NULL,
    death_date date NOT NULL,
    death_type_concept_id integer NOT NULL,
    cause_concept_id integer,
    cause_source_value character varying(50),
    cause_source_concept_id integer
);



CREATE TABLE device_cost (
    device_cost_id integer NOT NULL,
    device_exposure_id integer NOT NULL,
    currency_concept_id integer,
    paid_copay numeric,
    paid_coinsurance numeric,
    paid_toward_deductible numeric,
    paid_by_payer numeric,
    paid_by_coordination_benefits numeric,
    total_out_of_pocket numeric,
    total_paid numeric,
    payer_plan_period_id integer
);



CREATE TABLE device_exposure (
    device_exposure_id integer NOT NULL,
    person_id integer NOT NULL,
    device_concept_id integer NOT NULL,
    device_exposure_start_date date NOT NULL,
    device_exposure_end_date date,
    device_type_concept_id integer NOT NULL,
    unique_device_id character varying(50),
    quantity integer,
    provider_id integer,
    visit_occurrence_id bigint,
    device_source_value character varying(100),
    device_source_concept_id integer
);



CREATE TABLE domain (
    domain_id character varying(20) NOT NULL,
    domain_name character varying(255) NOT NULL,
    domain_concept_id integer NOT NULL
);



CREATE TABLE dose_era (
    dose_era_id integer NOT NULL,
    person_id integer NOT NULL,
    drug_concept_id integer NOT NULL,
    unit_concept_id integer NOT NULL,
    dose_value numeric NOT NULL,
    dose_era_start_date date NOT NULL,
    dose_era_end_date date NOT NULL
);



CREATE TABLE drug_cost (
    drug_cost_id integer NOT NULL,
    drug_exposure_id integer NOT NULL,
    currency_concept_id integer,
    paid_copay numeric,
    paid_coinsurance numeric,
    paid_toward_deductible numeric,
    paid_by_payer numeric,
    paid_by_coordination_benefits numeric,
    total_out_of_pocket numeric,
    total_paid numeric,
    ingredient_cost numeric,
    dispensing_fee numeric,
    average_wholesale_price numeric,
    payer_plan_period_id integer
);



CREATE SEQUENCE drug_era_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



CREATE TABLE drug_era (
    drug_era_id integer DEFAULT nextval('drug_era_sequence'::regclass) NOT NULL,
    person_id integer NOT NULL,
    drug_concept_id integer NOT NULL,
    drug_era_start_date date NOT NULL,
    drug_era_end_date date NOT NULL,
    drug_exposure_count integer,
    gap_days integer
);



CREATE TABLE drug_exposure (
    drug_exposure_id integer NOT NULL,
    person_id integer NOT NULL,
    drug_concept_id integer NOT NULL,
    drug_exposure_start_date date NOT NULL,
    drug_exposure_end_date date,
    drug_type_concept_id integer NOT NULL,
    stop_reason character varying(20),
    refills integer,
    quantity numeric,
    days_supply integer,
    sig text,
    route_concept_id integer,
    effective_drug_dose numeric,
    dose_unit_concept_id integer,
    lot_number character varying(50),
    provider_id integer,
    visit_occurrence_id bigint,
    drug_source_value character varying(50),
    drug_source_concept_id integer,
    route_source_value character varying(50),
    dose_unit_source_value character varying(50)
);



CREATE TABLE drug_strength (
    drug_concept_id integer NOT NULL,
    ingredient_concept_id integer NOT NULL,
    amount_value numeric,
    amount_unit_concept_id integer,
    numerator_value numeric,
    numerator_unit_concept_id integer,
    denominator_value numeric,
    denominator_unit_concept_id integer,
    box_size integer,
    valid_start_date date NOT NULL,
    valid_end_date date NOT NULL,
    invalid_reason character varying(1)
);



CREATE TABLE fact_relationship (
    domain_concept_id_1 integer NOT NULL,
    fact_id_1 integer NOT NULL,
    domain_concept_id_2 integer NOT NULL,
    fact_id_2 integer NOT NULL,
    relationship_concept_id integer NOT NULL
);



CREATE TABLE location (
    location_id integer NOT NULL,
    address_1 character varying(50),
    address_2 character varying(50),
    city character varying(50),
    state character varying(2),
    zip character varying(9),
    county character varying(20),
    location_source_value character varying(50)
);



CREATE TABLE measurement (
    measurement_id integer NOT NULL,
    person_id integer NOT NULL,
    measurement_concept_id integer NOT NULL,
    measurement_date date NOT NULL,
    measurement_time character varying(10),
    measurement_type_concept_id integer NOT NULL,
    operator_concept_id integer,
    value_as_number numeric,
    value_as_concept_id integer,
    unit_concept_id integer,
    range_low numeric,
    range_high numeric,
    provider_id integer,
    visit_occurrence_id bigint,
    measurement_source_value character varying(50),
    measurement_source_concept_id integer,
    unit_source_value character varying(50),
    value_source_value character varying(50)
);



CREATE TABLE note (
    note_id integer NOT NULL,
    person_id integer NOT NULL,
    note_date date NOT NULL,
    note_time character varying(10),
    note_type_concept_id integer NOT NULL,
    note_text text NOT NULL,
    provider_id integer,
    visit_occurrence_id bigint,
    note_source_value character varying(50)
);



CREATE TABLE observation (
    observation_id integer NOT NULL,
    person_id integer NOT NULL,
    observation_concept_id integer NOT NULL,
    observation_date date NOT NULL,
    observation_time character varying(10),
    observation_type_concept_id integer NOT NULL,
    value_as_number numeric,
    value_as_string character varying(60),
    value_as_concept_id integer,
    qualifier_concept_id integer,
    unit_concept_id integer,
    provider_id integer,
    visit_occurrence_id bigint,
    observation_source_value character varying(50),
    observation_source_concept_id integer,
    unit_source_value character varying(50),
    qualifier_source_value character varying(50)
);



CREATE TABLE observation_period (
    observation_period_id integer NOT NULL,
    person_id integer NOT NULL,
    observation_period_start_date date NOT NULL,
    observation_period_end_date date NOT NULL,
    period_type_concept_id integer NOT NULL
);



CREATE TABLE payer_plan_period (
    payer_plan_period_id integer NOT NULL,
    person_id integer NOT NULL,
    payer_plan_period_start_date date NOT NULL,
    payer_plan_period_end_date date NOT NULL,
    payer_source_value character varying(50),
    plan_source_value character varying(50),
    family_source_value character varying(50)
);



CREATE TABLE person (
    person_id integer NOT NULL,
    gender_concept_id integer NOT NULL,
    year_of_birth integer NOT NULL,
    month_of_birth integer,
    day_of_birth integer,
    time_of_birth character varying(10),
    race_concept_id integer NOT NULL,
    ethnicity_concept_id integer NOT NULL,
    location_id integer,
    provider_id integer,
    care_site_id integer,
    person_source_value character varying(50),
    gender_source_value character varying(50),
    gender_source_concept_id integer,
    race_source_value character varying(50),
    race_source_concept_id integer,
    ethnicity_source_value character varying(50),
    ethnicity_source_concept_id integer
);



CREATE TABLE procedure_cost (
    procedure_cost_id integer NOT NULL,
    procedure_occurrence_id integer NOT NULL,
    currency_concept_id integer,
    paid_copay numeric,
    paid_coinsurance numeric,
    paid_toward_deductible numeric,
    paid_by_payer numeric,
    paid_by_coordination_benefits numeric,
    total_out_of_pocket numeric,
    total_paid numeric,
    revenue_code_concept_id integer,
    payer_plan_period_id integer,
    revenue_code_source_value character varying(50)
);



CREATE TABLE procedure_occurrence (
    procedure_occurrence_id integer NOT NULL,
    person_id integer NOT NULL,
    procedure_concept_id integer NOT NULL,
    procedure_date date NOT NULL,
    procedure_type_concept_id integer NOT NULL,
    modifier_concept_id integer,
    quantity integer,
    provider_id integer,
    visit_occurrence_id bigint,
    procedure_source_value character varying(50),
    procedure_source_concept_id integer,
    qualifier_source_value character varying(50)
);



CREATE TABLE provider (
    provider_id integer NOT NULL,
    provider_name character varying(255),
    npi character varying(20),
    dea character varying(20),
    specialty_concept_id integer,
    care_site_id integer,
    year_of_birth integer,
    gender_concept_id integer,
    provider_source_value character varying(50),
    specialty_source_value character varying(50),
    specialty_source_concept_id integer,
    gender_source_value character varying(50),
    gender_source_concept_id integer
);



CREATE TABLE relationship (
    relationship_id character varying(20) NOT NULL,
    relationship_name character varying(255) NOT NULL,
    is_hierarchical character varying(1) NOT NULL,
    defines_ancestry character varying(1) NOT NULL,
    reverse_relationship_id character varying(20) NOT NULL,
    relationship_concept_id integer NOT NULL
);



CREATE TABLE source_to_concept_map (
    source_code character varying(50) NOT NULL,
    source_concept_id integer NOT NULL,
    source_vocabulary_id character varying(20) NOT NULL,
    source_code_description character varying(255),
    target_concept_id integer NOT NULL,
    target_vocabulary_id character varying(20) NOT NULL,
    valid_start_date date NOT NULL,
    valid_end_date date NOT NULL,
    invalid_reason character varying(1)
);



CREATE TABLE specimen (
    specimen_id integer NOT NULL,
    person_id integer NOT NULL,
    specimen_concept_id integer NOT NULL,
    specimen_type_concept_id integer NOT NULL,
    specimen_date date NOT NULL,
    specimen_time character varying(10),
    quantity numeric,
    unit_concept_id integer,
    anatomic_site_concept_id integer,
    disease_status_concept_id integer,
    specimen_source_id character varying(50),
    specimen_source_value character varying(50),
    unit_source_value character varying(50),
    anatomic_site_source_value character varying(50),
    disease_status_source_value character varying(50)
);



CREATE TABLE visit_cost (
    visit_cost_id integer NOT NULL,
    visit_occurrence_id bigint NOT NULL,
    currency_concept_id integer,
    paid_copay numeric,
    paid_coinsurance numeric,
    paid_toward_deductible numeric,
    paid_by_payer numeric,
    paid_by_coordination_benefits numeric,
    total_out_of_pocket numeric,
    total_paid numeric,
    payer_plan_period_id integer
);



CREATE TABLE visit_occurrence (
    visit_occurrence_id bigint NOT NULL,
    person_id integer NOT NULL,
    visit_concept_id integer NOT NULL,
    visit_start_date date NOT NULL,
    visit_start_time character varying(10),
    visit_end_date date NOT NULL,
    visit_end_time character varying(10),
    visit_type_concept_id integer NOT NULL,
    provider_id integer,
    care_site_id integer,
    visit_source_value character varying(50),
    visit_source_concept_id integer
);



CREATE TABLE vocabulary (
    vocabulary_id character varying(20) NOT NULL,
    vocabulary_name character varying(255) NOT NULL,
    vocabulary_reference character varying(255),
    vocabulary_version character varying(255),
    vocabulary_concept_id integer NOT NULL
);






INSERT INTO care_site (care_site_id, care_site_name, place_of_service_concept_id, location_id, care_site_source_value, place_of_service_source_value) VALUES (13, NULL, 8940, NULL, '673314266', ' ');
INSERT INTO care_site (care_site_id, care_site_name, place_of_service_concept_id, location_id, care_site_source_value, place_of_service_source_value) VALUES (40, NULL, 8940, NULL, '532092265', ' ');
INSERT INTO care_site (care_site_id, care_site_name, place_of_service_concept_id, location_id, care_site_source_value, place_of_service_source_value) VALUES (1224, NULL, 8940, NULL, '326159978', ' ');
INSERT INTO care_site (care_site_id, care_site_name, place_of_service_concept_id, location_id, care_site_source_value, place_of_service_source_value) VALUES (1422, NULL, 8756, NULL, '10028V', 'Outpatient Facility');
INSERT INTO care_site (care_site_id, care_site_name, place_of_service_concept_id, location_id, care_site_source_value, place_of_service_source_value) VALUES (1640, NULL, 8940, NULL, '803844699', ' ');
INSERT INTO care_site (care_site_id, care_site_name, place_of_service_concept_id, location_id, care_site_source_value, place_of_service_source_value) VALUES (3547, NULL, 8756, NULL, '0600VR', 'Outpatient Facility');
INSERT INTO care_site (care_site_id, care_site_name, place_of_service_concept_id, location_id, care_site_source_value, place_of_service_source_value) VALUES (3617, NULL, 8717, NULL, '1000AV', 'Inpatient Facility');
INSERT INTO care_site (care_site_id, care_site_name, place_of_service_concept_id, location_id, care_site_source_value, place_of_service_source_value) VALUES (3783, NULL, 8940, NULL, '392790749', ' ');
INSERT INTO care_site (care_site_id, care_site_name, place_of_service_concept_id, location_id, care_site_source_value, place_of_service_source_value) VALUES (3852, NULL, 8717, NULL, '5001PC', 'Inpatient Facility');
INSERT INTO care_site (care_site_id, care_site_name, place_of_service_concept_id, location_id, care_site_source_value, place_of_service_source_value) VALUES (3875, NULL, 8940, NULL, '957009733', ' ');
INSERT INTO care_site (care_site_id, care_site_name, place_of_service_concept_id, location_id, care_site_source_value, place_of_service_source_value) VALUES (3903, NULL, 8717, NULL, '2200MM', 'Inpatient Facility');
INSERT INTO care_site (care_site_id, care_site_name, place_of_service_concept_id, location_id, care_site_source_value, place_of_service_source_value) VALUES (8192, NULL, 8940, NULL, '682184334', ' ');
INSERT INTO care_site (care_site_id, care_site_name, place_of_service_concept_id, location_id, care_site_source_value, place_of_service_source_value) VALUES (8292, NULL, 8940, NULL, '396701521', ' ');
INSERT INTO care_site (care_site_id, care_site_name, place_of_service_concept_id, location_id, care_site_source_value, place_of_service_source_value) VALUES (9812, NULL, 8940, NULL, '565980590', ' ');
INSERT INTO care_site (care_site_id, care_site_name, place_of_service_concept_id, location_id, care_site_source_value, place_of_service_source_value) VALUES (13448, NULL, 8756, NULL, '2585MN', 'Outpatient Facility');
INSERT INTO care_site (care_site_id, care_site_name, place_of_service_concept_id, location_id, care_site_source_value, place_of_service_source_value) VALUES (13456, NULL, 8940, NULL, '744920165', ' ');
INSERT INTO care_site (care_site_id, care_site_name, place_of_service_concept_id, location_id, care_site_source_value, place_of_service_source_value) VALUES (13897, NULL, 8756, NULL, '0600CD', 'Outpatient Facility');
INSERT INTO care_site (care_site_id, care_site_name, place_of_service_concept_id, location_id, care_site_source_value, place_of_service_source_value) VALUES (15128, NULL, 8756, NULL, '3301WB', 'Outpatient Facility');
INSERT INTO care_site (care_site_id, care_site_name, place_of_service_concept_id, location_id, care_site_source_value, place_of_service_source_value) VALUES (16990, NULL, 8940, NULL, '683403127', ' ');
INSERT INTO care_site (care_site_id, care_site_name, place_of_service_concept_id, location_id, care_site_source_value, place_of_service_source_value) VALUES (18956, NULL, 8940, NULL, '043570860', ' ');
INSERT INTO care_site (care_site_id, care_site_name, place_of_service_concept_id, location_id, care_site_source_value, place_of_service_source_value) VALUES (21318, NULL, 8940, NULL, '064907993', ' ');
INSERT INTO care_site (care_site_id, care_site_name, place_of_service_concept_id, location_id, care_site_source_value, place_of_service_source_value) VALUES (23997, NULL, 8717, NULL, '23T1ZR', 'Inpatient Facility');
INSERT INTO care_site (care_site_id, care_site_name, place_of_service_concept_id, location_id, care_site_source_value, place_of_service_source_value) VALUES (33580, NULL, 8940, NULL, '837659996', ' ');
INSERT INTO care_site (care_site_id, care_site_name, place_of_service_concept_id, location_id, care_site_source_value, place_of_service_source_value) VALUES (33583, NULL, 8940, NULL, '880523932', ' ');
INSERT INTO care_site (care_site_id, care_site_name, place_of_service_concept_id, location_id, care_site_source_value, place_of_service_source_value) VALUES (33787, NULL, 8940, NULL, '256810062', ' ');
INSERT INTO care_site (care_site_id, care_site_name, place_of_service_concept_id, location_id, care_site_source_value, place_of_service_source_value) VALUES (34511, NULL, 8940, NULL, '799224819', ' ');
INSERT INTO care_site (care_site_id, care_site_name, place_of_service_concept_id, location_id, care_site_source_value, place_of_service_source_value) VALUES (43378, NULL, 8717, NULL, '25S1YD', 'Inpatient Facility');
INSERT INTO care_site (care_site_id, care_site_name, place_of_service_concept_id, location_id, care_site_source_value, place_of_service_source_value) VALUES (50533, NULL, 8940, NULL, '358716972', ' ');
INSERT INTO care_site (care_site_id, care_site_name, place_of_service_concept_id, location_id, care_site_source_value, place_of_service_source_value) VALUES (103488, NULL, 8940, NULL, '420824437', ' ');
INSERT INTO care_site (care_site_id, care_site_name, place_of_service_concept_id, location_id, care_site_source_value, place_of_service_source_value) VALUES (117750, NULL, 8940, NULL, '507211772', ' ');
INSERT INTO care_site (care_site_id, care_site_name, place_of_service_concept_id, location_id, care_site_source_value, place_of_service_source_value) VALUES (137825, NULL, 8756, NULL, '2513SJ', 'Outpatient Facility');






INSERT INTO cohort (cohort_definition_id, subject_id, cohort_start_date, cohort_end_date) VALUES (1770676, 95538, '2010-01-20', '2010-02-19');
INSERT INTO cohort (cohort_definition_id, subject_id, cohort_start_date, cohort_end_date) VALUES (1770676, 1780, '2009-03-02', '2009-04-01');
INSERT INTO cohort (cohort_definition_id, subject_id, cohort_start_date, cohort_end_date) VALUES (1770676, 107680, '2009-07-06', '2009-08-05');
INSERT INTO cohort (cohort_definition_id, subject_id, cohort_start_date, cohort_end_date) VALUES (1770676, 37455, '2009-08-17', '2009-09-16');
INSERT INTO cohort (cohort_definition_id, subject_id, cohort_start_date, cohort_end_date) VALUES (1770676, 72120, '2009-02-25', '2009-03-27');
INSERT INTO cohort (cohort_definition_id, subject_id, cohort_start_date, cohort_end_date) VALUES (1770675, 82328, '2009-08-24', '2009-09-23');
INSERT INTO cohort (cohort_definition_id, subject_id, cohort_start_date, cohort_end_date) VALUES (1770675, 30091, '2009-03-28', '2009-04-27');
INSERT INTO cohort (cohort_definition_id, subject_id, cohort_start_date, cohort_end_date) VALUES (1770675, 110862, '2010-04-05', '2010-05-05');
INSERT INTO cohort (cohort_definition_id, subject_id, cohort_start_date, cohort_end_date) VALUES (1770675, 69985, '2009-05-05', '2009-06-04');
INSERT INTO cohort (cohort_definition_id, subject_id, cohort_start_date, cohort_end_date) VALUES (1770675, 42383, '2009-11-06', '2009-12-06');
INSERT INTO cohort (cohort_definition_id, subject_id, cohort_start_date, cohort_end_date) VALUES (1770674, 95538, '2009-03-30', '2009-04-06');
INSERT INTO cohort (cohort_definition_id, subject_id, cohort_start_date, cohort_end_date) VALUES (1770674, 110862, '2009-09-30', '2009-10-07');
INSERT INTO cohort (cohort_definition_id, subject_id, cohort_start_date, cohort_end_date) VALUES (1770674, 69985, '2010-07-22', '2010-07-29');
INSERT INTO cohort (cohort_definition_id, subject_id, cohort_start_date, cohort_end_date) VALUES (1770674, 1780, '2008-04-10', '2008-04-17');
INSERT INTO cohort (cohort_definition_id, subject_id, cohort_start_date, cohort_end_date) VALUES (1770674, 107680, '2009-07-20', '2009-07-27');
INSERT INTO cohort (cohort_definition_id, subject_id, cohort_start_date, cohort_end_date) VALUES (1770674, 30091, '2009-08-02', '2009-08-09');






INSERT INTO cohort_definition (cohort_definition_id, cohort_definition_name, cohort_definition_description, definition_type_concept_id, cohort_definition_syntax, subject_concept_id, cohort_initiation_date) VALUES (1770673, 'Angioedema events', NULL, 44819246, NULL, 56, NULL);
INSERT INTO cohort_definition (cohort_definition_id, cohort_definition_name, cohort_definition_description, definition_type_concept_id, cohort_definition_syntax, subject_concept_id, cohort_initiation_date) VALUES (1770674, 'Acute myocardial infarction events', NULL, 44819246, NULL, 56, NULL);
INSERT INTO cohort_definition (cohort_definition_id, cohort_definition_name, cohort_definition_description, definition_type_concept_id, cohort_definition_syntax, subject_concept_id, cohort_initiation_date) VALUES (1770675, 'New users of ACE inhibitors as first-line monotherapy for hypertension', NULL, 44819246, NULL, 56, NULL);
INSERT INTO cohort_definition (cohort_definition_id, cohort_definition_name, cohort_definition_description, definition_type_concept_id, cohort_definition_syntax, subject_concept_id, cohort_initiation_date) VALUES (1770676, 'New users of Thiazide-like diuretics as first-line monotherapy for hypertension', NULL, 44819246, NULL, 56, NULL);



INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (0, 'No matching concept', 'Metadata', 'None', 'Undefined', NULL, 'No matching concept', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (2, 'Gender', 'Metadata', 'Domain', 'Domain', NULL, 'OMOP generated', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (3, 'Race', 'Metadata', 'Domain', 'Domain', NULL, 'OMOP generated', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (4, 'Ethnicity', 'Metadata', 'Domain', 'Domain', NULL, 'OMOP generated', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (7, 'Metadata', 'Metadata', 'Domain', 'Domain', NULL, 'OMOP generated', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (8, 'Visit', 'Metadata', 'Domain', 'Domain', NULL, 'OMOP generated', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (13, 'Drug', 'Metadata', 'Domain', 'Domain', NULL, 'OMOP generated', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (19, 'Condition', 'Metadata', 'Domain', 'Domain', NULL, 'OMOP generated', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (56, 'Person', 'Metadata', 'Domain', 'Domain', NULL, 'OMOP generated', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (58, 'Type Concept', 'Metadata', 'Domain', 'Domain', NULL, 'OMOP generated', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (262, 'Emergency Room and Inpatient Visit', 'Visit', 'Visit', 'Visit', 'S', 'ERIP', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (5046, 'International Classification of Diseases, Ninth Revision, Clinical Modification, Volume 1 and 2 (NCHS)', 'Metadata', 'Vocabulary', 'Vocabulary', NULL, 'OMOP generated', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (8507, 'MALE', 'Gender', 'Gender', 'Gender', 'S', 'M', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (8516, 'Black or African American', 'Race', 'Race', 'Race', 'S', '3', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (8527, 'White', 'Race', 'Race', 'Race', 'S', '5', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (8532, 'FEMALE', 'Gender', 'Gender', 'Gender', 'S', 'F', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (8717, 'Inpatient Hospital', 'Visit', 'CMS Place of Service', 'Visit', 'S', '21', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (8756, 'Outpatient Hospital', 'Visit', 'CMS Place of Service', 'Visit', 'S', '22', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (8940, 'Office', 'Visit', 'CMS Place of Service', 'Visit', NULL, '11', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (9201, 'Inpatient Visit', 'Visit', 'Visit', 'Visit', 'S', 'IP', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (9202, 'Outpatient Visit', 'Visit', 'Visit', 'Visit', 'S', 'OP', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (9203, 'Emergency Room Visit', 'Visit', 'Visit', 'Visit', 'S', 'ER', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (312327, 'Acute myocardial infarction', 'Condition', 'SNOMED', 'Clinical Finding', 'S', '57054005', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (316866, 'Hypertensive disorder', 'Condition', 'SNOMED', 'Clinical Finding', 'S', '38341003', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (317895, 'Renovascular hypertension', 'Condition', 'SNOMED', 'Clinical Finding', 'S', '123799005', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (317898, 'Malignant essential hypertension', 'Condition', 'SNOMED', 'Clinical Finding', 'S', '78975002', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (318437, 'Malignant secondary hypertension', 'Condition', 'SNOMED', 'Clinical Finding', 'S', '89242004', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (319826, 'Secondary hypertension', 'Condition', 'SNOMED', 'Clinical Finding', 'S', '31992008', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (434376, 'Acute myocardial infarction of anterior wall', 'Condition', 'SNOMED', 'Clinical Finding', 'S', '54329005', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (438170, 'Acute myocardial infarction of inferior wall', 'Condition', 'SNOMED', 'Clinical Finding', 'S', '73795002', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (438438, 'Acute myocardial infarction of anterolateral wall', 'Condition', 'SNOMED', 'Clinical Finding', 'S', '70211005', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (444406, 'Acute subendocardial infarction', 'Condition', 'SNOMED', 'Clinical Finding', 'S', '70422006', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (907013, 'Metolazone', 'Drug', 'RxNorm', 'Ingredient', 'S', '6916', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (907020, 'Metolazone 5 MG Oral Tablet', 'Drug', 'RxNorm', 'Clinical Drug', 'S', '311671', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (974166, 'Hydrochlorothiazide', 'Drug', 'RxNorm', 'Ingredient', 'S', '5487', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (1308216, 'Lisinopril', 'Drug', 'RxNorm', 'Ingredient', 'S', '29046', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (1334456, 'Ramipril', 'Drug', 'RxNorm', 'Ingredient', 'S', '35296', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (1334459, 'Ramipril 2.5 MG Oral Capsule', 'Drug', 'RxNorm', 'Clinical Drug', 'S', '198188', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (1340128, 'Captopril', 'Drug', 'RxNorm', 'Ingredient', 'S', '1998', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (1341927, 'Enalapril', 'Drug', 'RxNorm', 'Ingredient', 'S', '3827', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (1347384, 'irbesartan', 'Drug', 'RxNorm', 'Ingredient', 'S', '83818', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (1347386, 'irbesartan 150 MG Oral Tablet [Avapro]', 'Drug', 'RxNorm', 'Branded Drug', 'S', '153666', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (1373928, 'Hydralazine', 'Drug', 'RxNorm', 'Ingredient', 'S', '5470', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (1395058, 'Chlorthalidone', 'Drug', 'RxNorm', 'Ingredient', 'S', '2409', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (1395073, 'Chlorthalidone 25 MG Oral Tablet', 'Drug', 'RxNorm', 'Clinical Drug', 'S', '197499', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (4329847, 'Myocardial infarction', 'Condition', 'SNOMED', 'Clinical Finding', 'S', '22298006', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (19019044, 'Hydrochlorothiazide 50 MG Oral Tablet', 'Drug', 'RxNorm', 'Clinical Drug', 'S', '197770', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (19074673, 'Captopril 50 MG Oral Tablet', 'Drug', 'RxNorm', 'Clinical Drug', 'S', '308964', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (19078106, 'Hydrochlorothiazide 25 MG Oral Tablet', 'Drug', 'RxNorm', 'Clinical Drug', 'S', '310798', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (19080128, 'Lisinopril 10 MG Oral Tablet', 'Drug', 'RxNorm', 'Clinical Drug', 'S', '314076', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (19080129, 'Lisinopril 20 MG Oral Tablet', 'Drug', 'RxNorm', 'Clinical Drug', 'S', '314077', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (38000175, 'Prescription dispensed in pharmacy', 'Type Concept', 'Drug Type', 'Drug Type', 'S', 'OMOP4822239', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (38000200, 'Inpatient header - 1st position', 'Type Concept', 'Condition Type', 'Condition Type', 'S', 'OMOP4822076', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (38000230, 'Outpatient header - 1st position', 'Type Concept', 'Condition Type', 'Condition Type', 'S', 'OMOP4822106', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (38003564, 'Not Hispanic or Latino', 'Ethnicity', 'Ethnicity', 'Ethnicity', 'S', 'Not Hispanic', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (40165773, 'Enalapril Maleate 20 MG Oral Tablet', 'Drug', 'RxNorm', 'Clinical Drug', 'S', '858810', '2009-09-06', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (40174825, 'Hydralazine Hydrochloride 50 MG Oral Tablet', 'Drug', 'RxNorm', 'Clinical Drug', 'S', '905395', '2010-04-04', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (44814722, 'Period while enrolled in insurance', 'Type Concept', 'Obs Period Type', 'Obs Period Type', 'S', 'OMOP4822293', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (44818517, 'Visit derived from encounter on claim', 'Type Concept', 'Visit Type', 'Visit Type', 'S', 'OMOP4822465', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (44818723, 'Subsumes', 'Metadata', 'Relationship', 'Relationship', NULL, 'OMOP generated', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (44818821, 'Is a', 'Metadata', 'Relationship', 'Relationship', NULL, 'OMOP generated', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (44818981, 'Ingredient', 'Metadata', 'Concept Class', 'Concept Class', NULL, 'OMOP generated', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (44818997, 'Clinical Finding', 'Metadata', 'Concept Class', 'Concept Class', NULL, 'OMOP generated', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (44819023, 'OMOP Visit', 'Metadata', 'Concept Class', 'Concept Class', NULL, 'OMOP generated', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (44819025, 'Domain', 'Metadata', 'Concept Class', 'Concept Class', NULL, 'OMOP generated', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (44819028, 'Semantic Clinical Drug', 'Metadata', 'Concept Class', 'Concept Class', NULL, 'OMOP generated', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (44819030, 'Race', 'Metadata', 'Concept Class', 'Concept Class', NULL, 'OMOP generated', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (44819035, 'Ethnicity', 'Metadata', 'Concept Class', 'Concept Class', NULL, 'OMOP generated', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (44819039, 'Visit Type', 'Metadata', 'Concept Class', 'Concept Class', NULL, 'OMOP generated', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (44819044, 'Undefined', 'Metadata', 'Concept Class', 'Concept Class', NULL, 'OMOP generated', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (44819058, 'Model Component', 'Metadata', 'Concept Class', 'Concept Class', NULL, 'OMOP generated', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (44819062, 'Observation Period Type', 'Metadata', 'Concept Class', 'Concept Class', NULL, 'OMOP generated', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (44819063, 'Semantic Branded Drug', 'Metadata', 'Concept Class', 'Concept Class', NULL, 'OMOP generated', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (44819086, 'Gender', 'Metadata', 'Concept Class', 'Concept Class', NULL, 'OMOP generated', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (44819096, 'OMOP Standardized Vocabularies', 'Metadata', 'Vocabulary', 'Vocabulary', NULL, 'OMOP generated', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (44819097, 'Systematic Nomenclature of Medicine - Clinical Terms (IHTSDO)', 'Metadata', 'Vocabulary', 'Vocabulary', NULL, 'OMOP generated', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (44819104, 'RxNorm (NLM)', 'Metadata', 'Vocabulary', 'Vocabulary', NULL, 'OMOP generated', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (44819105, 'National Drug Code (FDA and manufacturers)', 'Metadata', 'Vocabulary', 'Vocabulary', NULL, 'OMOP generated', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (44819108, 'OMOP Gender', 'Metadata', 'Vocabulary', 'Vocabulary', NULL, 'OMOP generated', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (44819109, 'Race and Ethnicity Code Set (USBC)', 'Metadata', 'Vocabulary', 'Vocabulary', NULL, 'OMOP generated', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (44819110, 'CMS Place of Service', 'Metadata', 'Vocabulary', 'Vocabulary', NULL, 'OMOP generated', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (44819119, 'OMOP Visit', 'Metadata', 'Vocabulary', 'Vocabulary', NULL, 'OMOP generated', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (44819123, 'Legacy OMOP HOI or DOI cohort', 'Metadata', 'Vocabulary', 'Vocabulary', NULL, 'OMOP generated', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (44819126, 'OMOP Drug Exposure Type', 'Metadata', 'Vocabulary', 'Vocabulary', NULL, 'OMOP generated', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (44819127, 'OMOP Condition Occurrence Type', 'Metadata', 'Vocabulary', 'Vocabulary', NULL, 'OMOP generated', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (44819134, 'OMOP Ethnicity', 'Metadata', 'Vocabulary', 'Vocabulary', NULL, 'OMOP generated', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (44819147, 'OMOP Domain', 'Metadata', 'Vocabulary', 'Vocabulary', NULL, 'OMOP generated', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (44819149, 'OMOP Observation Period Type', 'Metadata', 'Vocabulary', 'Vocabulary', NULL, 'OMOP generated', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (44819150, 'OMOP Visit Type', 'Metadata', 'Vocabulary', 'Vocabulary', NULL, 'OMOP generated', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (44819232, 'OMOP Vocabulary', 'Metadata', 'Vocabulary', 'Vocabulary', NULL, 'OMOP generated', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (44819233, 'OMOP Concept Class', 'Metadata', 'Vocabulary', 'Vocabulary', NULL, 'OMOP generated', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (44819235, 'OMOP Relationship', 'Metadata', 'Vocabulary', 'Vocabulary', NULL, 'OMOP generated', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (44819243, '11-digit NDC code', 'Metadata', 'Concept Class', 'Concept Class', NULL, 'OMOP generated', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (44819246, 'Cohort', 'Metadata', 'Concept Class', 'Concept Class', NULL, 'OMOP generated', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (44819247, 'OMOP Concept Class', 'Metadata', 'Concept Class', 'Concept Class', NULL, 'OMOP generated', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (44819248, 'OMOP Condition Type', 'Metadata', 'Concept Class', 'Concept Class', NULL, 'OMOP generated', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (44819252, 'Drug Type', 'Metadata', 'Concept Class', 'Concept Class', NULL, 'OMOP generated', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (44819274, 'OMOP Relationship', 'Metadata', 'Concept Class', 'Concept Class', NULL, 'OMOP generated', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (44819279, 'OMOP Vocabulary', 'Metadata', 'Concept Class', 'Concept Class', NULL, 'OMOP generated', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (44819697, 'Acute myocardial infarction of other anterior wall, subsequent episode of care', 'Condition', 'ICD9CM', '5-dig billing code', NULL, '410.12', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (44819701, 'Acute myocardial infarction, subendocardial infarction', 'Condition', 'ICD9CM', '4-dig nonbill code', NULL, '410.7', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (44819702, 'Acute myocardial infarction, unspecified site', 'Condition', 'ICD9CM', '4-dig nonbill code', NULL, '410.9', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (44820857, 'Acute myocardial infarction, of anterolateral wall', 'Condition', 'ICD9CM', '4-dig nonbill code', NULL, '410.0', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (44820858, 'Acute myocardial infarction of anterolateral wall, subsequent episode of care', 'Condition', 'ICD9CM', '5-dig billing code', NULL, '410.02', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (44823109, 'Malignant essential hypertension', 'Condition', 'ICD9CM', '4-dig billing code', NULL, '401.0', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (44823654, 'Complications affecting specified body systems, not elsewhere classified', 'Condition', 'ICD9CM', '3-dig nonbill code', NULL, '997', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (44824236, 'Other malignant secondary hypertension', 'Condition', 'ICD9CM', '5-dig billing code', NULL, '405.09', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (44825428, 'Acute myocardial infarction, of other inferior wall', 'Condition', 'ICD9CM', '4-dig nonbill code', NULL, '410.4', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (44825429, 'Subendocardial infarction, initial episode of care', 'Condition', 'ICD9CM', '5-dig billing code', NULL, '410.71', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (44830078, 'Unspecified renovascular hypertension', 'Condition', 'ICD9CM', '5-dig billing code', NULL, '405.91', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (44830637, 'Complications affecting other specified body systems, not elsewhere classified, hypertension', 'Condition', 'ICD9CM', '5-dig billing code', NULL, '997.91', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (44831233, 'Malignant secondary hypertension', 'Condition', 'ICD9CM', '4-dig nonbill code', NULL, '405.0', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (44832370, 'Secondary hypertension', 'Condition', 'ICD9CM', '3-dig nonbill code', NULL, '405', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (44832372, 'Acute myocardial infarction', 'Condition', 'ICD9CM', '3-dig nonbill code', NULL, '410', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (44832374, 'Acute myocardial infarction of other inferior wall, subsequent episode of care', 'Condition', 'ICD9CM', '5-dig billing code', NULL, '410.42', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (44833556, 'Essential hypertension', 'Condition', 'ICD9CM', '3-dig nonbill code', NULL, '401', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (44834718, 'Acute myocardial infarction, of other anterior wall', 'Condition', 'ICD9CM', '4-dig nonbill code', NULL, '410.1', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (44835301, 'Complications affecting other specified body systems, not elsewhere classified', 'Condition', 'ICD9CM', '4-dig nonbill code', NULL, '997.9', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (44835925, 'Other unspecified secondary hypertension', 'Condition', 'ICD9CM', '5-dig billing code', NULL, '405.99', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (44835928, 'Acute myocardial infarction of unspecified site, episode of care unspecified', 'Condition', 'ICD9CM', '5-dig billing code', NULL, '410.90', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (44837098, 'Unspecified secondary hypertension', 'Condition', 'ICD9CM', '4-dig nonbill code', NULL, '405.9', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (44841767, 'Chlorthalidone 25 MG Oral Tablet', 'Drug', 'NDC', '11-digit NDC', NULL, '00894632103', '2007-06-01', '2011-01-01', 'D');
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (44871708, 'Enalapril Maleate 20 MG Oral Tablet', 'Drug', 'NDC', '11-digit NDC', NULL, '68788092909', '2009-10-01', '2012-06-01', 'D');
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (44922810, 'Lisinopril 20 MG Oral Tablet', 'Drug', 'NDC', '11-digit NDC', NULL, '68180051501', '2007-06-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (44941256, 'Ramipril 2.5 MG Oral Capsule [Altace]', 'Drug', 'NDC', '11-digit NDC', NULL, '00088010427', '2007-06-01', '2013-01-01', 'D');
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (44948932, 'Lisinopril 10 MG Oral Tablet', 'Drug', 'NDC', '11-digit NDC', NULL, '43683014730', '2009-05-01', '2012-06-01', 'D');
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (44967315, 'Enalapril Maleate 20 MG Oral Tablet', 'Drug', 'NDC', '11-digit NDC', NULL, '51672404003', '2009-10-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (44981339, 'Hydrochlorothiazide 50 MG Oral Tablet', 'Drug', 'NDC', '11-digit NDC', NULL, '27444263107', '2008-02-01', '2012-06-01', 'D');
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (45036483, 'Captopril 50 MG Oral Tablet', 'Drug', 'NDC', '11-digit NDC', NULL, '53978051701', '2007-06-01', '2012-06-01', 'D');
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (45039771, 'Hydralazine Hydrochloride 50 MG Oral Tablet', 'Drug', 'NDC', '11-digit NDC', NULL, '61392063739', '2010-04-01', '2012-06-01', 'D');
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (45082806, 'Hydrochlorothiazide 50 MG Oral Tablet', 'Drug', 'NDC', '11-digit NDC', NULL, '12634047150', '2010-06-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (45159452, 'irbesartan 150 MG Oral Tablet [Avapro]', 'Drug', 'NDC', '11-digit NDC', NULL, '63629337303', '2007-06-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (45243001, 'Metolazone 5 MG Oral Tablet', 'Drug', 'NDC', '11-digit NDC', NULL, '58016030821', '2007-06-01', '2012-06-01', 'D');
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (45336217, 'Hydrochlorothiazide 25 MG Oral Tablet', 'Drug', 'NDC', '11-digit NDC', NULL, '00814372014', '2007-06-01', '2011-01-01', 'D');
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (45754869, '4-digit billing code', 'Metadata', 'Concept Class', 'Concept Class', NULL, 'OMOP generated', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (45754870, '5-digit billing code', 'Metadata', 'Concept Class', 'Concept Class', NULL, 'OMOP generated', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (45754876, '3-digit non-billing code', 'Metadata', 'Concept Class', 'Concept Class', NULL, 'OMOP generated', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (45754877, '4-digit non-billing code', 'Metadata', 'Concept Class', 'Concept Class', NULL, 'OMOP generated', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (45768449, 'Hypertensive crisis', 'Condition', 'SNOMED', 'Clinical Finding', 'S', '706882009', '2015-01-31', '2099-12-31', NULL);



INSERT INTO concept_ancestor (ancestor_concept_id, descendant_concept_id, min_levels_of_separation, max_levels_of_separation) VALUES (9201, 8717, 1, 1);
INSERT INTO concept_ancestor (ancestor_concept_id, descendant_concept_id, min_levels_of_separation, max_levels_of_separation) VALUES (9202, 8756, 1, 1);
INSERT INTO concept_ancestor (ancestor_concept_id, descendant_concept_id, min_levels_of_separation, max_levels_of_separation) VALUES (312327, 434376, 1, 1);
INSERT INTO concept_ancestor (ancestor_concept_id, descendant_concept_id, min_levels_of_separation, max_levels_of_separation) VALUES (312327, 438170, 1, 1);
INSERT INTO concept_ancestor (ancestor_concept_id, descendant_concept_id, min_levels_of_separation, max_levels_of_separation) VALUES (312327, 438438, 1, 1);
INSERT INTO concept_ancestor (ancestor_concept_id, descendant_concept_id, min_levels_of_separation, max_levels_of_separation) VALUES (312327, 444406, 1, 1);
INSERT INTO concept_ancestor (ancestor_concept_id, descendant_concept_id, min_levels_of_separation, max_levels_of_separation) VALUES (316866, 317895, 3, 3);
INSERT INTO concept_ancestor (ancestor_concept_id, descendant_concept_id, min_levels_of_separation, max_levels_of_separation) VALUES (316866, 317898, 2, 4);
INSERT INTO concept_ancestor (ancestor_concept_id, descendant_concept_id, min_levels_of_separation, max_levels_of_separation) VALUES (316866, 318437, 2, 4);
INSERT INTO concept_ancestor (ancestor_concept_id, descendant_concept_id, min_levels_of_separation, max_levels_of_separation) VALUES (316866, 319826, 1, 1);
INSERT INTO concept_ancestor (ancestor_concept_id, descendant_concept_id, min_levels_of_separation, max_levels_of_separation) VALUES (316866, 45768449, 1, 1);
INSERT INTO concept_ancestor (ancestor_concept_id, descendant_concept_id, min_levels_of_separation, max_levels_of_separation) VALUES (319826, 317895, 2, 2);
INSERT INTO concept_ancestor (ancestor_concept_id, descendant_concept_id, min_levels_of_separation, max_levels_of_separation) VALUES (319826, 318437, 1, 1);
INSERT INTO concept_ancestor (ancestor_concept_id, descendant_concept_id, min_levels_of_separation, max_levels_of_separation) VALUES (907013, 907020, 2, 3);
INSERT INTO concept_ancestor (ancestor_concept_id, descendant_concept_id, min_levels_of_separation, max_levels_of_separation) VALUES (974166, 19019044, 2, 3);
INSERT INTO concept_ancestor (ancestor_concept_id, descendant_concept_id, min_levels_of_separation, max_levels_of_separation) VALUES (974166, 19078106, 2, 3);
INSERT INTO concept_ancestor (ancestor_concept_id, descendant_concept_id, min_levels_of_separation, max_levels_of_separation) VALUES (1308216, 19080128, 2, 3);
INSERT INTO concept_ancestor (ancestor_concept_id, descendant_concept_id, min_levels_of_separation, max_levels_of_separation) VALUES (1308216, 19080129, 2, 3);
INSERT INTO concept_ancestor (ancestor_concept_id, descendant_concept_id, min_levels_of_separation, max_levels_of_separation) VALUES (1334456, 1334459, 2, 3);
INSERT INTO concept_ancestor (ancestor_concept_id, descendant_concept_id, min_levels_of_separation, max_levels_of_separation) VALUES (1340128, 19074673, 2, 3);
INSERT INTO concept_ancestor (ancestor_concept_id, descendant_concept_id, min_levels_of_separation, max_levels_of_separation) VALUES (1341927, 40165773, 2, 3);
INSERT INTO concept_ancestor (ancestor_concept_id, descendant_concept_id, min_levels_of_separation, max_levels_of_separation) VALUES (1347384, 1347386, 2, 3);
INSERT INTO concept_ancestor (ancestor_concept_id, descendant_concept_id, min_levels_of_separation, max_levels_of_separation) VALUES (1373928, 40174825, 2, 3);
INSERT INTO concept_ancestor (ancestor_concept_id, descendant_concept_id, min_levels_of_separation, max_levels_of_separation) VALUES (1395058, 1395073, 2, 3);
INSERT INTO concept_ancestor (ancestor_concept_id, descendant_concept_id, min_levels_of_separation, max_levels_of_separation) VALUES (4329847, 312327, 1, 1);
INSERT INTO concept_ancestor (ancestor_concept_id, descendant_concept_id, min_levels_of_separation, max_levels_of_separation) VALUES (4329847, 434376, 2, 2);
INSERT INTO concept_ancestor (ancestor_concept_id, descendant_concept_id, min_levels_of_separation, max_levels_of_separation) VALUES (4329847, 438170, 2, 2);
INSERT INTO concept_ancestor (ancestor_concept_id, descendant_concept_id, min_levels_of_separation, max_levels_of_separation) VALUES (4329847, 438438, 2, 2);
INSERT INTO concept_ancestor (ancestor_concept_id, descendant_concept_id, min_levels_of_separation, max_levels_of_separation) VALUES (4329847, 444406, 2, 2);
INSERT INTO concept_ancestor (ancestor_concept_id, descendant_concept_id, min_levels_of_separation, max_levels_of_separation) VALUES (45768449, 317898, 3, 3);
INSERT INTO concept_ancestor (ancestor_concept_id, descendant_concept_id, min_levels_of_separation, max_levels_of_separation) VALUES (45768449, 318437, 3, 3);



INSERT INTO concept_class (concept_class_id, concept_class_name, concept_class_concept_id) VALUES ('11-digit NDC', '11-digit NDC code', 44819243);
INSERT INTO concept_class (concept_class_id, concept_class_name, concept_class_concept_id) VALUES ('3-dig nonbill code', '3-digit non-billing code', 45754876);
INSERT INTO concept_class (concept_class_id, concept_class_name, concept_class_concept_id) VALUES ('4-dig billing code', '4-digit billing code', 45754869);
INSERT INTO concept_class (concept_class_id, concept_class_name, concept_class_concept_id) VALUES ('4-dig nonbill code', '4-digit non-billing code', 45754877);
INSERT INTO concept_class (concept_class_id, concept_class_name, concept_class_concept_id) VALUES ('5-dig billing code', '5-digit billing code', 45754870);
INSERT INTO concept_class (concept_class_id, concept_class_name, concept_class_concept_id) VALUES ('Branded Drug', 'Semantic Branded Drug', 44819063);
INSERT INTO concept_class (concept_class_id, concept_class_name, concept_class_concept_id) VALUES ('Clinical Drug', 'Semantic Clinical Drug', 44819028);
INSERT INTO concept_class (concept_class_id, concept_class_name, concept_class_concept_id) VALUES ('Clinical Finding', 'Clinical Finding', 44818997);
INSERT INTO concept_class (concept_class_id, concept_class_name, concept_class_concept_id) VALUES ('Cohort', 'Cohort', 44819246);
INSERT INTO concept_class (concept_class_id, concept_class_name, concept_class_concept_id) VALUES ('Concept Class', 'OMOP Concept Class', 44819247);
INSERT INTO concept_class (concept_class_id, concept_class_name, concept_class_concept_id) VALUES ('Condition Type', 'Condition Type', 44819248);
INSERT INTO concept_class (concept_class_id, concept_class_name, concept_class_concept_id) VALUES ('Domain', 'Domain', 44819025);
INSERT INTO concept_class (concept_class_id, concept_class_name, concept_class_concept_id) VALUES ('Drug Type', 'Drug Type', 44819252);
INSERT INTO concept_class (concept_class_id, concept_class_name, concept_class_concept_id) VALUES ('Ethnicity', 'Ethnicity', 44819035);
INSERT INTO concept_class (concept_class_id, concept_class_name, concept_class_concept_id) VALUES ('Gender', 'Gender', 44819086);
INSERT INTO concept_class (concept_class_id, concept_class_name, concept_class_concept_id) VALUES ('Ingredient', 'Ingredient', 44818981);
INSERT INTO concept_class (concept_class_id, concept_class_name, concept_class_concept_id) VALUES ('Model Comp', 'Model Component', 44819058);
INSERT INTO concept_class (concept_class_id, concept_class_name, concept_class_concept_id) VALUES ('Obs Period Type', 'Observation Period Type', 44819062);
INSERT INTO concept_class (concept_class_id, concept_class_name, concept_class_concept_id) VALUES ('Race', 'Race', 44819030);
INSERT INTO concept_class (concept_class_id, concept_class_name, concept_class_concept_id) VALUES ('Relationship', 'OMOP Relationship', 44819274);
INSERT INTO concept_class (concept_class_id, concept_class_name, concept_class_concept_id) VALUES ('Undefined', 'Undefined', 44819044);
INSERT INTO concept_class (concept_class_id, concept_class_name, concept_class_concept_id) VALUES ('Visit', 'OMOP Visit', 44819023);
INSERT INTO concept_class (concept_class_id, concept_class_name, concept_class_concept_id) VALUES ('Visit Type', 'Visit Type', 44819039);
INSERT INTO concept_class (concept_class_id, concept_class_name, concept_class_concept_id) VALUES ('Vocabulary', 'OMOP Vocabulary', 44819279);



INSERT INTO concept_relationship (concept_id_1, concept_id_2, relationship_id, valid_start_date, valid_end_date, invalid_reason) VALUES (8717, 9201, 'Is a', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept_relationship (concept_id_1, concept_id_2, relationship_id, valid_start_date, valid_end_date, invalid_reason) VALUES (8756, 9202, 'Is a', '1970-01-01', '2099-12-31', NULL);
INSERT INTO concept_relationship (concept_id_1, concept_id_2, relationship_id, valid_start_date, valid_end_date, invalid_reason) VALUES (312327, 4329847, 'Is a', '2011-07-31', '2099-12-31', NULL);
INSERT INTO concept_relationship (concept_id_1, concept_id_2, relationship_id, valid_start_date, valid_end_date, invalid_reason) VALUES (318437, 319826, 'Is a', '2011-07-31', '2099-12-31', NULL);
INSERT INTO concept_relationship (concept_id_1, concept_id_2, relationship_id, valid_start_date, valid_end_date, invalid_reason) VALUES (319826, 316866, 'Is a', '2011-07-31', '2099-12-31', NULL);
INSERT INTO concept_relationship (concept_id_1, concept_id_2, relationship_id, valid_start_date, valid_end_date, invalid_reason) VALUES (434376, 312327, 'Is a', '2011-07-31', '2099-12-31', NULL);
INSERT INTO concept_relationship (concept_id_1, concept_id_2, relationship_id, valid_start_date, valid_end_date, invalid_reason) VALUES (438170, 312327, 'Is a', '2011-07-31', '2099-12-31', NULL);
INSERT INTO concept_relationship (concept_id_1, concept_id_2, relationship_id, valid_start_date, valid_end_date, invalid_reason) VALUES (438438, 312327, 'Is a', '2011-07-31', '2099-12-31', NULL);
INSERT INTO concept_relationship (concept_id_1, concept_id_2, relationship_id, valid_start_date, valid_end_date, invalid_reason) VALUES (444406, 312327, 'Is a', '2011-07-31', '2099-12-31', NULL);
INSERT INTO concept_relationship (concept_id_1, concept_id_2, relationship_id, valid_start_date, valid_end_date, invalid_reason) VALUES (44819697, 44832372, 'Is a', '2014-10-01', '2099-12-31', NULL);
INSERT INTO concept_relationship (concept_id_1, concept_id_2, relationship_id, valid_start_date, valid_end_date, invalid_reason) VALUES (44819697, 44834718, 'Is a', '2014-10-01', '2099-12-31', NULL);
INSERT INTO concept_relationship (concept_id_1, concept_id_2, relationship_id, valid_start_date, valid_end_date, invalid_reason) VALUES (44819701, 44832372, 'Is a', '2014-10-01', '2099-12-31', NULL);
INSERT INTO concept_relationship (concept_id_1, concept_id_2, relationship_id, valid_start_date, valid_end_date, invalid_reason) VALUES (44819702, 44832372, 'Is a', '2014-10-01', '2099-12-31', NULL);
INSERT INTO concept_relationship (concept_id_1, concept_id_2, relationship_id, valid_start_date, valid_end_date, invalid_reason) VALUES (44820857, 44832372, 'Is a', '2014-10-01', '2099-12-31', NULL);
INSERT INTO concept_relationship (concept_id_1, concept_id_2, relationship_id, valid_start_date, valid_end_date, invalid_reason) VALUES (44820858, 44820857, 'Is a', '2014-10-01', '2099-12-31', NULL);
INSERT INTO concept_relationship (concept_id_1, concept_id_2, relationship_id, valid_start_date, valid_end_date, invalid_reason) VALUES (44820858, 44832372, 'Is a', '2014-10-01', '2099-12-31', NULL);
INSERT INTO concept_relationship (concept_id_1, concept_id_2, relationship_id, valid_start_date, valid_end_date, invalid_reason) VALUES (44823109, 44833556, 'Is a', '2014-10-01', '2099-12-31', NULL);
INSERT INTO concept_relationship (concept_id_1, concept_id_2, relationship_id, valid_start_date, valid_end_date, invalid_reason) VALUES (44824236, 44831233, 'Is a', '2014-10-01', '2099-12-31', NULL);
INSERT INTO concept_relationship (concept_id_1, concept_id_2, relationship_id, valid_start_date, valid_end_date, invalid_reason) VALUES (44824236, 44832370, 'Is a', '2014-10-01', '2099-12-31', NULL);
INSERT INTO concept_relationship (concept_id_1, concept_id_2, relationship_id, valid_start_date, valid_end_date, invalid_reason) VALUES (44825428, 44832372, 'Is a', '2014-10-01', '2099-12-31', NULL);
INSERT INTO concept_relationship (concept_id_1, concept_id_2, relationship_id, valid_start_date, valid_end_date, invalid_reason) VALUES (44825429, 44819701, 'Is a', '2014-10-01', '2099-12-31', NULL);
INSERT INTO concept_relationship (concept_id_1, concept_id_2, relationship_id, valid_start_date, valid_end_date, invalid_reason) VALUES (44825429, 44832372, 'Is a', '2014-10-01', '2099-12-31', NULL);
INSERT INTO concept_relationship (concept_id_1, concept_id_2, relationship_id, valid_start_date, valid_end_date, invalid_reason) VALUES (44830078, 44832370, 'Is a', '2014-10-01', '2099-12-31', NULL);
INSERT INTO concept_relationship (concept_id_1, concept_id_2, relationship_id, valid_start_date, valid_end_date, invalid_reason) VALUES (44830078, 44837098, 'Is a', '2014-10-01', '2099-12-31', NULL);
INSERT INTO concept_relationship (concept_id_1, concept_id_2, relationship_id, valid_start_date, valid_end_date, invalid_reason) VALUES (44830637, 44823654, 'Is a', '2014-10-01', '2099-12-31', NULL);
INSERT INTO concept_relationship (concept_id_1, concept_id_2, relationship_id, valid_start_date, valid_end_date, invalid_reason) VALUES (44830637, 44835301, 'Is a', '2014-10-01', '2099-12-31', NULL);
INSERT INTO concept_relationship (concept_id_1, concept_id_2, relationship_id, valid_start_date, valid_end_date, invalid_reason) VALUES (44831233, 44832370, 'Is a', '2014-10-01', '2099-12-31', NULL);
INSERT INTO concept_relationship (concept_id_1, concept_id_2, relationship_id, valid_start_date, valid_end_date, invalid_reason) VALUES (44832374, 44825428, 'Is a', '2014-10-01', '2099-12-31', NULL);
INSERT INTO concept_relationship (concept_id_1, concept_id_2, relationship_id, valid_start_date, valid_end_date, invalid_reason) VALUES (44832374, 44832372, 'Is a', '2014-10-01', '2099-12-31', NULL);
INSERT INTO concept_relationship (concept_id_1, concept_id_2, relationship_id, valid_start_date, valid_end_date, invalid_reason) VALUES (44834718, 44832372, 'Is a', '2014-10-01', '2099-12-31', NULL);
INSERT INTO concept_relationship (concept_id_1, concept_id_2, relationship_id, valid_start_date, valid_end_date, invalid_reason) VALUES (44835301, 44823654, 'Is a', '2014-10-01', '2099-12-31', NULL);
INSERT INTO concept_relationship (concept_id_1, concept_id_2, relationship_id, valid_start_date, valid_end_date, invalid_reason) VALUES (44835925, 44832370, 'Is a', '2014-10-01', '2099-12-31', NULL);
INSERT INTO concept_relationship (concept_id_1, concept_id_2, relationship_id, valid_start_date, valid_end_date, invalid_reason) VALUES (44835925, 44837098, 'Is a', '2014-10-01', '2099-12-31', NULL);
INSERT INTO concept_relationship (concept_id_1, concept_id_2, relationship_id, valid_start_date, valid_end_date, invalid_reason) VALUES (44835928, 44819702, 'Is a', '2014-10-01', '2099-12-31', NULL);
INSERT INTO concept_relationship (concept_id_1, concept_id_2, relationship_id, valid_start_date, valid_end_date, invalid_reason) VALUES (44835928, 44832372, 'Is a', '2014-10-01', '2099-12-31', NULL);
INSERT INTO concept_relationship (concept_id_1, concept_id_2, relationship_id, valid_start_date, valid_end_date, invalid_reason) VALUES (44837098, 44832370, 'Is a', '2014-10-01', '2099-12-31', NULL);
INSERT INTO concept_relationship (concept_id_1, concept_id_2, relationship_id, valid_start_date, valid_end_date, invalid_reason) VALUES (45768449, 316866, 'Is a', '2015-01-31', '2099-12-31', NULL);









INSERT INTO condition_occurrence (condition_occurrence_id, person_id, condition_concept_id, condition_start_date, condition_end_date, condition_type_concept_id, stop_reason, provider_id, visit_occurrence_id, condition_source_value, condition_source_concept_id) VALUES (228060, 1780, 319826, '2008-11-22', '2008-11-22', 38000230, NULL, 12674, 88214, '40599', 44835925);
INSERT INTO condition_occurrence (condition_occurrence_id, person_id, condition_concept_id, condition_start_date, condition_end_date, condition_type_concept_id, stop_reason, provider_id, visit_occurrence_id, condition_source_value, condition_source_concept_id) VALUES (228161, 1780, 312327, '2008-04-10', '2008-04-10', 38000230, NULL, 61112, 88246, '41090', 44835928);
INSERT INTO condition_occurrence (condition_occurrence_id, person_id, condition_concept_id, condition_start_date, condition_end_date, condition_type_concept_id, stop_reason, provider_id, visit_occurrence_id, condition_source_value, condition_source_concept_id) VALUES (228213, 1780, 317895, '2009-05-22', '2009-05-22', 38000230, NULL, 61118, 88263, '40591', 44830078);
INSERT INTO condition_occurrence (condition_occurrence_id, person_id, condition_concept_id, condition_start_date, condition_end_date, condition_type_concept_id, stop_reason, provider_id, visit_occurrence_id, condition_source_value, condition_source_concept_id) VALUES (3767773, 30091, 444406, '2009-08-02', '2009-08-03', 38000230, NULL, 2185, 1454884, '41071', 44825429);
INSERT INTO condition_occurrence (condition_occurrence_id, person_id, condition_concept_id, condition_start_date, condition_end_date, condition_type_concept_id, stop_reason, provider_id, visit_occurrence_id, condition_source_value, condition_source_concept_id) VALUES (3767867, 30091, 318437, '2008-11-12', '2008-11-12', 38000230, NULL, 36303, 1454922, '40509', 44824236);
INSERT INTO condition_occurrence (condition_occurrence_id, person_id, condition_concept_id, condition_start_date, condition_end_date, condition_type_concept_id, stop_reason, provider_id, visit_occurrence_id, condition_source_value, condition_source_concept_id) VALUES (4696246, 37455, 317898, '2008-10-30', '2008-10-30', 38000230, NULL, 16, 1813776, '4010', 44823109);
INSERT INTO condition_occurrence (condition_occurrence_id, person_id, condition_concept_id, condition_start_date, condition_end_date, condition_type_concept_id, stop_reason, provider_id, visit_occurrence_id, condition_source_value, condition_source_concept_id) VALUES (4696273, 37455, 438438, '2010-08-12', '2010-08-12', 38000230, NULL, 272592, 1813788, '41002', 44820858);
INSERT INTO condition_occurrence (condition_occurrence_id, person_id, condition_concept_id, condition_start_date, condition_end_date, condition_type_concept_id, stop_reason, provider_id, visit_occurrence_id, condition_source_value, condition_source_concept_id) VALUES (4696477, 37455, 318437, '2008-03-18', '2008-03-18', 38000230, NULL, 279614, 1813856, '40509', 44824236);
INSERT INTO condition_occurrence (condition_occurrence_id, person_id, condition_concept_id, condition_start_date, condition_end_date, condition_type_concept_id, stop_reason, provider_id, visit_occurrence_id, condition_source_value, condition_source_concept_id) VALUES (5300888, 42383, 317898, '2010-04-15', '2010-04-15', 38000230, NULL, 1883, 2046364, '4010', 44823109);
INSERT INTO condition_occurrence (condition_occurrence_id, person_id, condition_concept_id, condition_start_date, condition_end_date, condition_type_concept_id, stop_reason, provider_id, visit_occurrence_id, condition_source_value, condition_source_concept_id) VALUES (5300928, 42383, 319826, '2009-06-29', '2009-06-29', 38000230, NULL, 689, 2046380, '40599', 44835925);
INSERT INTO condition_occurrence (condition_occurrence_id, person_id, condition_concept_id, condition_start_date, condition_end_date, condition_type_concept_id, stop_reason, provider_id, visit_occurrence_id, condition_source_value, condition_source_concept_id) VALUES (8701359, 69985, 444406, '2010-07-22', '2010-07-30', 38000200, NULL, 83104, 3359790, '41071', 44825429);
INSERT INTO condition_occurrence (condition_occurrence_id, person_id, condition_concept_id, condition_start_date, condition_end_date, condition_type_concept_id, stop_reason, provider_id, visit_occurrence_id, condition_source_value, condition_source_concept_id) VALUES (8701405, 69985, 312327, '2010-05-06', '2010-05-07', 38000230, NULL, 329631, 3359810, '41090', 44835928);
INSERT INTO condition_occurrence (condition_occurrence_id, person_id, condition_concept_id, condition_start_date, condition_end_date, condition_type_concept_id, stop_reason, provider_id, visit_occurrence_id, condition_source_value, condition_source_concept_id) VALUES (8701422, 69985, 317898, '2009-01-09', '2009-01-09', 38000230, NULL, 21645, 3359817, '4010', 44823109);
INSERT INTO condition_occurrence (condition_occurrence_id, person_id, condition_concept_id, condition_start_date, condition_end_date, condition_type_concept_id, stop_reason, provider_id, visit_occurrence_id, condition_source_value, condition_source_concept_id) VALUES (8701480, 69985, 317898, '2010-04-17', '2010-04-17', 38000230, NULL, 21673, 3359838, '4010', 44823109);
INSERT INTO condition_occurrence (condition_occurrence_id, person_id, condition_concept_id, condition_start_date, condition_end_date, condition_type_concept_id, stop_reason, provider_id, visit_occurrence_id, condition_source_value, condition_source_concept_id) VALUES (8963258, 72120, 317898, '2008-12-15', '2008-12-15', 38000230, NULL, 339214, 3461442, '4010', 44823109);
INSERT INTO condition_occurrence (condition_occurrence_id, person_id, condition_concept_id, condition_start_date, condition_end_date, condition_type_concept_id, stop_reason, provider_id, visit_occurrence_id, condition_source_value, condition_source_concept_id) VALUES (10234411, 82328, 317898, '2009-01-25', '2009-01-25', 38000230, NULL, 5516, 3952172, '4010', 44823109);
INSERT INTO condition_occurrence (condition_occurrence_id, person_id, condition_concept_id, condition_start_date, condition_end_date, condition_type_concept_id, stop_reason, provider_id, visit_occurrence_id, condition_source_value, condition_source_concept_id) VALUES (10234551, 82328, 317898, '2008-10-20', '2008-10-20', 38000230, NULL, 197101, 3952218, '4010', 44823109);
INSERT INTO condition_occurrence (condition_occurrence_id, person_id, condition_concept_id, condition_start_date, condition_end_date, condition_type_concept_id, stop_reason, provider_id, visit_occurrence_id, condition_source_value, condition_source_concept_id) VALUES (11881327, 95538, 444406, '2009-03-30', '2009-04-03', 38000200, NULL, 95836, 4586628, '41071', 44825429);
INSERT INTO condition_occurrence (condition_occurrence_id, person_id, condition_concept_id, condition_start_date, condition_end_date, condition_type_concept_id, stop_reason, provider_id, visit_occurrence_id, condition_source_value, condition_source_concept_id) VALUES (11881388, 95538, 316866, '2009-09-02', '2009-09-02', 38000230, NULL, 435002, 4586653, '99791', 44830637);
INSERT INTO condition_occurrence (condition_occurrence_id, person_id, condition_concept_id, condition_start_date, condition_end_date, condition_type_concept_id, stop_reason, provider_id, visit_occurrence_id, condition_source_value, condition_source_concept_id) VALUES (13374905, 107680, 444406, '2009-07-20', '2009-07-30', 38000200, NULL, 60753, 5162803, '41071', 44825429);
INSERT INTO condition_occurrence (condition_occurrence_id, person_id, condition_concept_id, condition_start_date, condition_end_date, condition_type_concept_id, stop_reason, provider_id, visit_occurrence_id, condition_source_value, condition_source_concept_id) VALUES (13375372, 107680, 317898, '2009-06-07', '2009-06-07', 38000230, NULL, 99551, 5162964, '4010', 44823109);
INSERT INTO condition_occurrence (condition_occurrence_id, person_id, condition_concept_id, condition_start_date, condition_end_date, condition_type_concept_id, stop_reason, provider_id, visit_occurrence_id, condition_source_value, condition_source_concept_id) VALUES (13769162, 110862, 444406, '2009-09-30', '2009-10-01', 38000200, NULL, 31857, 5314664, '41071', 44825429);
INSERT INTO condition_occurrence (condition_occurrence_id, person_id, condition_concept_id, condition_start_date, condition_end_date, condition_type_concept_id, stop_reason, provider_id, visit_occurrence_id, condition_source_value, condition_source_concept_id) VALUES (13769189, 110862, 438170, '2008-09-07', '2008-09-16', 38000230, NULL, 5159, 5314671, '41042', 44832374);
INSERT INTO condition_occurrence (condition_occurrence_id, person_id, condition_concept_id, condition_start_date, condition_end_date, condition_type_concept_id, stop_reason, provider_id, visit_occurrence_id, condition_source_value, condition_source_concept_id) VALUES (13769190, 110862, 434376, '2008-09-07', '2008-09-16', 38000230, NULL, 5159, 5314671, '41012', 44819697);
INSERT INTO condition_occurrence (condition_occurrence_id, person_id, condition_concept_id, condition_start_date, condition_end_date, condition_type_concept_id, stop_reason, provider_id, visit_occurrence_id, condition_source_value, condition_source_concept_id) VALUES (13769242, 110862, 317898, '2009-06-30', '2009-06-30', 38000230, NULL, 31906, 5314690, '4010', 44823109);
INSERT INTO condition_occurrence (condition_occurrence_id, person_id, condition_concept_id, condition_start_date, condition_end_date, condition_type_concept_id, stop_reason, provider_id, visit_occurrence_id, condition_source_value, condition_source_concept_id) VALUES (13769260, 110862, 312327, '2010-06-07', '2010-06-07', 38000230, NULL, 192777, 5314696, '41090', 44835928);












INSERT INTO domain (domain_id, domain_name, domain_concept_id) VALUES ('Condition', 'Condition', 19);
INSERT INTO domain (domain_id, domain_name, domain_concept_id) VALUES ('Drug', 'Drug', 13);
INSERT INTO domain (domain_id, domain_name, domain_concept_id) VALUES ('Ethnicity', 'Ethnicity', 4);
INSERT INTO domain (domain_id, domain_name, domain_concept_id) VALUES ('Gender', 'Gender', 2);
INSERT INTO domain (domain_id, domain_name, domain_concept_id) VALUES ('Metadata', 'Metadata', 7);
INSERT INTO domain (domain_id, domain_name, domain_concept_id) VALUES ('Race', 'Race', 3);
INSERT INTO domain (domain_id, domain_name, domain_concept_id) VALUES ('Type Concept', 'Type Concept', 58);
INSERT INTO domain (domain_id, domain_name, domain_concept_id) VALUES ('Visit', 'Visit', 8);









INSERT INTO drug_era (drug_era_id, person_id, drug_concept_id, drug_era_start_date, drug_era_end_date, drug_exposure_count, gap_days) VALUES (84172, 1780, 974166, '2009-03-02', '2009-04-01', 1, 0);
INSERT INTO drug_era (drug_era_id, person_id, drug_concept_id, drug_era_start_date, drug_era_end_date, drug_exposure_count, gap_days) VALUES (84173, 1780, 1373928, '2009-06-02', '2009-07-02', 1, 0);
INSERT INTO drug_era (drug_era_id, person_id, drug_concept_id, drug_era_start_date, drug_era_end_date, drug_exposure_count, gap_days) VALUES (1491126, 30091, 1340128, '2009-03-28', '2009-04-27', 1, 0);
INSERT INTO drug_era (drug_era_id, person_id, drug_concept_id, drug_era_start_date, drug_era_end_date, drug_exposure_count, gap_days) VALUES (1849996, 37455, 1395058, '2009-08-17', '2009-09-16', 1, 0);
INSERT INTO drug_era (drug_era_id, person_id, drug_concept_id, drug_era_start_date, drug_era_end_date, drug_exposure_count, gap_days) VALUES (2094935, 42383, 1308216, '2010-04-15', '2010-04-25', 1, 0);
INSERT INTO drug_era (drug_era_id, person_id, drug_concept_id, drug_era_start_date, drug_era_end_date, drug_exposure_count, gap_days) VALUES (2094937, 42383, 1334456, '2009-11-06', '2009-12-06', 1, 0);
INSERT INTO drug_era (drug_era_id, person_id, drug_concept_id, drug_era_start_date, drug_era_end_date, drug_exposure_count, gap_days) VALUES (3471617, 69985, 1308216, '2009-05-05', '2009-06-04', 1, 0);
INSERT INTO drug_era (drug_era_id, person_id, drug_concept_id, drug_era_start_date, drug_era_end_date, drug_exposure_count, gap_days) VALUES (3577192, 72120, 974166, '2009-02-25', '2009-03-27', 1, 0);
INSERT INTO drug_era (drug_era_id, person_id, drug_concept_id, drug_era_start_date, drug_era_end_date, drug_exposure_count, gap_days) VALUES (4079150, 82328, 1341927, '2009-08-24', '2009-09-23', 1, 0);
INSERT INTO drug_era (drug_era_id, person_id, drug_concept_id, drug_era_start_date, drug_era_end_date, drug_exposure_count, gap_days) VALUES (4079151, 82328, 1347384, '2010-04-02', '2010-05-02', 1, 0);
INSERT INTO drug_era (drug_era_id, person_id, drug_concept_id, drug_era_start_date, drug_era_end_date, drug_exposure_count, gap_days) VALUES (4731737, 95538, 974166, '2010-01-20', '2010-02-19', 1, 0);
INSERT INTO drug_era (drug_era_id, person_id, drug_concept_id, drug_era_start_date, drug_era_end_date, drug_exposure_count, gap_days) VALUES (5344660, 107680, 907013, '2009-07-06', '2009-08-05', 1, 0);
INSERT INTO drug_era (drug_era_id, person_id, drug_concept_id, drug_era_start_date, drug_era_end_date, drug_exposure_count, gap_days) VALUES (5504602, 110862, 1341927, '2010-04-05', '2010-05-05', 1, 0);



INSERT INTO drug_exposure (drug_exposure_id, person_id, drug_concept_id, drug_exposure_start_date, drug_exposure_end_date, drug_type_concept_id, stop_reason, refills, quantity, days_supply, sig, route_concept_id, effective_drug_dose, dose_unit_concept_id, lot_number, provider_id, visit_occurrence_id, drug_source_value, drug_source_concept_id, route_source_value, dose_unit_source_value) VALUES (92183, 1780, 40174825, '2009-06-02', NULL, 38000175, NULL, NULL, 0.0, 30, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '61392063739', 45039771, NULL, NULL);
INSERT INTO drug_exposure (drug_exposure_id, person_id, drug_concept_id, drug_exposure_start_date, drug_exposure_end_date, drug_type_concept_id, stop_reason, refills, quantity, days_supply, sig, route_concept_id, effective_drug_dose, dose_unit_concept_id, lot_number, provider_id, visit_occurrence_id, drug_source_value, drug_source_concept_id, route_source_value, dose_unit_source_value) VALUES (92184, 1780, 19019044, '2009-03-02', NULL, 38000175, NULL, NULL, 10.0, 30, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '12634047150', 45082806, NULL, NULL);
INSERT INTO drug_exposure (drug_exposure_id, person_id, drug_concept_id, drug_exposure_start_date, drug_exposure_end_date, drug_type_concept_id, stop_reason, refills, quantity, days_supply, sig, route_concept_id, effective_drug_dose, dose_unit_concept_id, lot_number, provider_id, visit_occurrence_id, drug_source_value, drug_source_concept_id, route_source_value, dose_unit_source_value) VALUES (1624988, 30091, 19074673, '2009-03-28', NULL, 38000175, NULL, NULL, 30.0, 30, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '53978051701', 45036483, NULL, NULL);
INSERT INTO drug_exposure (drug_exposure_id, person_id, drug_concept_id, drug_exposure_start_date, drug_exposure_end_date, drug_type_concept_id, stop_reason, refills, quantity, days_supply, sig, route_concept_id, effective_drug_dose, dose_unit_concept_id, lot_number, provider_id, visit_occurrence_id, drug_source_value, drug_source_concept_id, route_source_value, dose_unit_source_value) VALUES (2016569, 37455, 1395073, '2009-08-17', NULL, 38000175, NULL, NULL, 20.0, 30, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '00894632103', 44841767, NULL, NULL);
INSERT INTO drug_exposure (drug_exposure_id, person_id, drug_concept_id, drug_exposure_start_date, drug_exposure_end_date, drug_type_concept_id, stop_reason, refills, quantity, days_supply, sig, route_concept_id, effective_drug_dose, dose_unit_concept_id, lot_number, provider_id, visit_occurrence_id, drug_source_value, drug_source_concept_id, route_source_value, dose_unit_source_value) VALUES (2282940, 42383, 1334459, '2009-11-06', NULL, 38000175, NULL, NULL, 30.0, 30, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '00088010427', 44941256, NULL, NULL);
INSERT INTO drug_exposure (drug_exposure_id, person_id, drug_concept_id, drug_exposure_start_date, drug_exposure_end_date, drug_type_concept_id, stop_reason, refills, quantity, days_supply, sig, route_concept_id, effective_drug_dose, dose_unit_concept_id, lot_number, provider_id, visit_occurrence_id, drug_source_value, drug_source_concept_id, route_source_value, dose_unit_source_value) VALUES (2282941, 42383, 19080128, '2010-04-15', NULL, 38000175, NULL, NULL, 60.0, 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '43683014730', 44948932, NULL, NULL);
INSERT INTO drug_exposure (drug_exposure_id, person_id, drug_concept_id, drug_exposure_start_date, drug_exposure_end_date, drug_type_concept_id, stop_reason, refills, quantity, days_supply, sig, route_concept_id, effective_drug_dose, dose_unit_concept_id, lot_number, provider_id, visit_occurrence_id, drug_source_value, drug_source_concept_id, route_source_value, dose_unit_source_value) VALUES (3778545, 69985, 19080129, '2009-05-05', NULL, 38000175, NULL, NULL, 30.0, 30, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '68180051501', 44922810, NULL, NULL);
INSERT INTO drug_exposure (drug_exposure_id, person_id, drug_concept_id, drug_exposure_start_date, drug_exposure_end_date, drug_type_concept_id, stop_reason, refills, quantity, days_supply, sig, route_concept_id, effective_drug_dose, dose_unit_concept_id, lot_number, provider_id, visit_occurrence_id, drug_source_value, drug_source_concept_id, route_source_value, dose_unit_source_value) VALUES (3894006, 72120, 19019044, '2009-02-25', NULL, 38000175, NULL, NULL, 50.0, 30, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '27444263107', 44981339, NULL, NULL);
INSERT INTO drug_exposure (drug_exposure_id, person_id, drug_concept_id, drug_exposure_start_date, drug_exposure_end_date, drug_type_concept_id, stop_reason, refills, quantity, days_supply, sig, route_concept_id, effective_drug_dose, dose_unit_concept_id, lot_number, provider_id, visit_occurrence_id, drug_source_value, drug_source_concept_id, route_source_value, dose_unit_source_value) VALUES (4442355, 82328, 40165773, '2009-08-24', NULL, 38000175, NULL, NULL, 30.0, 30, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '68788092909', 44871708, NULL, NULL);
INSERT INTO drug_exposure (drug_exposure_id, person_id, drug_concept_id, drug_exposure_start_date, drug_exposure_end_date, drug_type_concept_id, stop_reason, refills, quantity, days_supply, sig, route_concept_id, effective_drug_dose, dose_unit_concept_id, lot_number, provider_id, visit_occurrence_id, drug_source_value, drug_source_concept_id, route_source_value, dose_unit_source_value) VALUES (4442356, 82328, 1347386, '2010-04-02', NULL, 38000175, NULL, NULL, 30.0, 30, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '63629337303', 45159452, NULL, NULL);
INSERT INTO drug_exposure (drug_exposure_id, person_id, drug_concept_id, drug_exposure_start_date, drug_exposure_end_date, drug_type_concept_id, stop_reason, refills, quantity, days_supply, sig, route_concept_id, effective_drug_dose, dose_unit_concept_id, lot_number, provider_id, visit_occurrence_id, drug_source_value, drug_source_concept_id, route_source_value, dose_unit_source_value) VALUES (5157574, 95538, 19078106, '2010-01-20', NULL, 38000175, NULL, NULL, 90.0, 30, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '00814372014', 45336217, NULL, NULL);
INSERT INTO drug_exposure (drug_exposure_id, person_id, drug_concept_id, drug_exposure_start_date, drug_exposure_end_date, drug_type_concept_id, stop_reason, refills, quantity, days_supply, sig, route_concept_id, effective_drug_dose, dose_unit_concept_id, lot_number, provider_id, visit_occurrence_id, drug_source_value, drug_source_concept_id, route_source_value, dose_unit_source_value) VALUES (5826395, 107680, 907020, '2009-07-06', NULL, 38000175, NULL, NULL, 10.0, 30, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '58016030821', 45243001, NULL, NULL);
INSERT INTO drug_exposure (drug_exposure_id, person_id, drug_concept_id, drug_exposure_start_date, drug_exposure_end_date, drug_type_concept_id, stop_reason, refills, quantity, days_supply, sig, route_concept_id, effective_drug_dose, dose_unit_concept_id, lot_number, provider_id, visit_occurrence_id, drug_source_value, drug_source_concept_id, route_source_value, dose_unit_source_value) VALUES (6000730, 110862, 40165773, '2010-04-05', NULL, 38000175, NULL, NULL, 30.0, 30, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '51672404003', 44967315, NULL, NULL);









INSERT INTO location (location_id, address_1, address_2, city, state, zip, county, location_source_value) VALUES (9, NULL, NULL, NULL, 'MI', NULL, '23810', '23-810');
INSERT INTO location (location_id, address_1, address_2, city, state, zip, county, location_source_value) VALUES (116, NULL, NULL, NULL, 'WA', NULL, '50260', '50-260');
INSERT INTO location (location_id, address_1, address_2, city, state, zip, county, location_source_value) VALUES (229, NULL, NULL, NULL, 'FL', NULL, '10350', '10-350');
INSERT INTO location (location_id, address_1, address_2, city, state, zip, county, location_source_value) VALUES (276, NULL, NULL, NULL, 'MD', NULL, '21020', '21-020');
INSERT INTO location (location_id, address_1, address_2, city, state, zip, county, location_source_value) VALUES (352, NULL, NULL, NULL, 'NY', NULL, '33240', '33-240');
INSERT INTO location (location_id, address_1, address_2, city, state, zip, county, location_source_value) VALUES (373, NULL, NULL, NULL, 'MS', NULL, '25370', '25-370');
INSERT INTO location (location_id, address_1, address_2, city, state, zip, county, location_source_value) VALUES (436, NULL, NULL, NULL, 'CO', NULL, '06060', '06-060');
INSERT INTO location (location_id, address_1, address_2, city, state, zip, county, location_source_value) VALUES (1037, NULL, NULL, NULL, 'GA', NULL, '11970', '11-970');
INSERT INTO location (location_id, address_1, address_2, city, state, zip, county, location_source_value) VALUES (2135, NULL, NULL, NULL, 'MA', NULL, '22030', '22-030');
INSERT INTO location (location_id, address_1, address_2, city, state, zip, county, location_source_value) VALUES (2136, NULL, NULL, NULL, 'IL', NULL, '14110', '14-110');












INSERT INTO observation_period (observation_period_id, person_id, observation_period_start_date, observation_period_end_date, period_type_concept_id) VALUES (1600, 1780, '2008-02-23', '2009-08-01', 44814722);
INSERT INTO observation_period (observation_period_id, person_id, observation_period_start_date, observation_period_end_date, period_type_concept_id) VALUES (27210, 30091, '2008-02-09', '2010-07-20', 44814722);
INSERT INTO observation_period (observation_period_id, person_id, observation_period_start_date, observation_period_end_date, period_type_concept_id) VALUES (33857, 37455, '2008-01-15', '2010-09-30', 44814722);
INSERT INTO observation_period (observation_period_id, person_id, observation_period_start_date, observation_period_end_date, period_type_concept_id) VALUES (38299, 42383, '2008-01-04', '2010-08-28', 44814722);
INSERT INTO observation_period (observation_period_id, person_id, observation_period_start_date, observation_period_end_date, period_type_concept_id) VALUES (63210, 69985, '2008-02-07', '2010-11-14', 44814722);
INSERT INTO observation_period (observation_period_id, person_id, observation_period_start_date, observation_period_end_date, period_type_concept_id) VALUES (65124, 72120, '2008-02-12', '2010-01-28', 44814722);
INSERT INTO observation_period (observation_period_id, person_id, observation_period_start_date, observation_period_end_date, period_type_concept_id) VALUES (74310, 82328, '2008-05-01', '2010-06-19', 44814722);
INSERT INTO observation_period (observation_period_id, person_id, observation_period_start_date, observation_period_end_date, period_type_concept_id) VALUES (86141, 95538, '2008-02-22', '2010-05-19', 44814722);
INSERT INTO observation_period (observation_period_id, person_id, observation_period_start_date, observation_period_end_date, period_type_concept_id) VALUES (97071, 107680, '2008-02-09', '2010-12-30', 44814722);
INSERT INTO observation_period (observation_period_id, person_id, observation_period_start_date, observation_period_end_date, period_type_concept_id) VALUES (99931, 110862, '2008-01-04', '2010-09-13', 44814722);






INSERT INTO person (person_id, gender_concept_id, year_of_birth, month_of_birth, day_of_birth, time_of_birth, race_concept_id, ethnicity_concept_id, location_id, provider_id, care_site_id, person_source_value, gender_source_value, gender_source_concept_id, race_source_value, race_source_concept_id, ethnicity_source_value, ethnicity_source_concept_id) VALUES (1780, 8532, 1940, 2, 1, NULL, 8516, 38003564, 229, NULL, NULL, '03C244F1A64B223A', '2', NULL, '2', NULL, '2', NULL);
INSERT INTO person (person_id, gender_concept_id, year_of_birth, month_of_birth, day_of_birth, time_of_birth, race_concept_id, ethnicity_concept_id, location_id, provider_id, care_site_id, person_source_value, gender_source_value, gender_source_concept_id, race_source_value, race_source_concept_id, ethnicity_source_value, ethnicity_source_concept_id) VALUES (30091, 8532, 1932, 8, 1, NULL, 8527, 38003564, 2135, NULL, NULL, '41C0357AA0641AEC', '2', NULL, '1', NULL, '1', NULL);
INSERT INTO person (person_id, gender_concept_id, year_of_birth, month_of_birth, day_of_birth, time_of_birth, race_concept_id, ethnicity_concept_id, location_id, provider_id, care_site_id, person_source_value, gender_source_value, gender_source_concept_id, race_source_value, race_source_concept_id, ethnicity_source_value, ethnicity_source_concept_id) VALUES (37455, 8532, 1913, 7, 1, NULL, 8527, 38003564, 1037, NULL, NULL, '51CDC3B3A4C75AA0', '2', NULL, '1', NULL, '1', NULL);
INSERT INTO person (person_id, gender_concept_id, year_of_birth, month_of_birth, day_of_birth, time_of_birth, race_concept_id, ethnicity_concept_id, location_id, provider_id, care_site_id, person_source_value, gender_source_value, gender_source_concept_id, race_source_value, race_source_concept_id, ethnicity_source_value, ethnicity_source_concept_id) VALUES (42383, 8507, 1922, 2, 1, NULL, 8527, 38003564, 276, NULL, NULL, '5CC1C6A408FF3B9C', '1', NULL, '1', NULL, '1', NULL);
INSERT INTO person (person_id, gender_concept_id, year_of_birth, month_of_birth, day_of_birth, time_of_birth, race_concept_id, ethnicity_concept_id, location_id, provider_id, care_site_id, person_source_value, gender_source_value, gender_source_concept_id, race_source_value, race_source_concept_id, ethnicity_source_value, ethnicity_source_concept_id) VALUES (69985, 8532, 1956, 7, 1, NULL, 8527, 38003564, 373, NULL, NULL, '99DA34DB27BBCA8D', '2', NULL, '1', NULL, '1', NULL);
INSERT INTO person (person_id, gender_concept_id, year_of_birth, month_of_birth, day_of_birth, time_of_birth, race_concept_id, ethnicity_concept_id, location_id, provider_id, care_site_id, person_source_value, gender_source_value, gender_source_concept_id, race_source_value, race_source_concept_id, ethnicity_source_value, ethnicity_source_concept_id) VALUES (72120, 8507, 1937, 10, 1, NULL, 0, 38003564, 2136, NULL, NULL, '9E93F86A4CDC0BE0', '1', NULL, '3', NULL, '3', NULL);
INSERT INTO person (person_id, gender_concept_id, year_of_birth, month_of_birth, day_of_birth, time_of_birth, race_concept_id, ethnicity_concept_id, location_id, provider_id, care_site_id, person_source_value, gender_source_value, gender_source_concept_id, race_source_value, race_source_concept_id, ethnicity_source_value, ethnicity_source_concept_id) VALUES (82328, 8532, 1957, 9, 1, NULL, 8527, 38003564, 352, NULL, NULL, 'B5628C42A6EA53E9', '2', NULL, '1', NULL, '1', NULL);
INSERT INTO person (person_id, gender_concept_id, year_of_birth, month_of_birth, day_of_birth, time_of_birth, race_concept_id, ethnicity_concept_id, location_id, provider_id, care_site_id, person_source_value, gender_source_value, gender_source_concept_id, race_source_value, race_source_concept_id, ethnicity_source_value, ethnicity_source_concept_id) VALUES (95538, 8507, 1923, 11, 1, NULL, 8527, 38003564, 9, NULL, NULL, 'D1EBF9FE96F83376', '1', NULL, '1', NULL, '1', NULL);
INSERT INTO person (person_id, gender_concept_id, year_of_birth, month_of_birth, day_of_birth, time_of_birth, race_concept_id, ethnicity_concept_id, location_id, provider_id, care_site_id, person_source_value, gender_source_value, gender_source_concept_id, race_source_value, race_source_concept_id, ethnicity_source_value, ethnicity_source_concept_id) VALUES (107680, 8532, 1963, 12, 1, NULL, 8527, 38003564, 116, NULL, NULL, 'ECFDFA95D3C9A010', '2', NULL, '1', NULL, '1', NULL);
INSERT INTO person (person_id, gender_concept_id, year_of_birth, month_of_birth, day_of_birth, time_of_birth, race_concept_id, ethnicity_concept_id, location_id, provider_id, care_site_id, person_source_value, gender_source_value, gender_source_concept_id, race_source_value, race_source_concept_id, ethnicity_source_value, ethnicity_source_concept_id) VALUES (110862, 8507, 1911, 4, 1, NULL, 8527, 38003564, 436, NULL, NULL, 'F3EFC3CB3F2C9D5E', '1', NULL, '1', NULL, '1', NULL);









INSERT INTO provider (provider_id, provider_name, npi, dea, specialty_concept_id, care_site_id, year_of_birth, gender_concept_id, provider_source_value, specialty_source_value, specialty_source_concept_id, gender_source_value, gender_source_concept_id) VALUES (16, NULL, '8207899456', NULL, NULL, 13, NULL, NULL, '8207899456', NULL, NULL, NULL, NULL);
INSERT INTO provider (provider_id, provider_name, npi, dea, specialty_concept_id, care_site_id, year_of_birth, gender_concept_id, provider_source_value, specialty_source_value, specialty_source_concept_id, gender_source_value, gender_source_concept_id) VALUES (689, NULL, '9979265126', NULL, NULL, 40, NULL, NULL, '9979265126', NULL, NULL, NULL, NULL);
INSERT INTO provider (provider_id, provider_name, npi, dea, specialty_concept_id, care_site_id, year_of_birth, gender_concept_id, provider_source_value, specialty_source_value, specialty_source_concept_id, gender_source_value, gender_source_concept_id) VALUES (1883, NULL, '4332659805', NULL, NULL, 1224, NULL, NULL, '4332659805', NULL, NULL, NULL, NULL);
INSERT INTO provider (provider_id, provider_name, npi, dea, specialty_concept_id, care_site_id, year_of_birth, gender_concept_id, provider_source_value, specialty_source_value, specialty_source_concept_id, gender_source_value, gender_source_concept_id) VALUES (2185, NULL, '3202183602', NULL, NULL, 1422, NULL, NULL, '3202183602', NULL, NULL, NULL, NULL);
INSERT INTO provider (provider_id, provider_name, npi, dea, specialty_concept_id, care_site_id, year_of_birth, gender_concept_id, provider_source_value, specialty_source_value, specialty_source_concept_id, gender_source_value, gender_source_concept_id) VALUES (5159, NULL, '5115680245', NULL, NULL, 3547, NULL, NULL, '5115680245', NULL, NULL, NULL, NULL);
INSERT INTO provider (provider_id, provider_name, npi, dea, specialty_concept_id, care_site_id, year_of_birth, gender_concept_id, provider_source_value, specialty_source_value, specialty_source_concept_id, gender_source_value, gender_source_concept_id) VALUES (5247, NULL, '9656623009', NULL, NULL, 3617, NULL, NULL, '9656623009', NULL, NULL, NULL, NULL);
INSERT INTO provider (provider_id, provider_name, npi, dea, specialty_concept_id, care_site_id, year_of_birth, gender_concept_id, provider_source_value, specialty_source_value, specialty_source_concept_id, gender_source_value, gender_source_concept_id) VALUES (5516, NULL, '2181317304', NULL, NULL, 3783, NULL, NULL, '2181317304', NULL, NULL, NULL, NULL);
INSERT INTO provider (provider_id, provider_name, npi, dea, specialty_concept_id, care_site_id, year_of_birth, gender_concept_id, provider_source_value, specialty_source_value, specialty_source_concept_id, gender_source_value, gender_source_concept_id) VALUES (5705, NULL, '0567465136', NULL, NULL, 3903, NULL, NULL, '0567465136', NULL, NULL, NULL, NULL);
INSERT INTO provider (provider_id, provider_name, npi, dea, specialty_concept_id, care_site_id, year_of_birth, gender_concept_id, provider_source_value, specialty_source_value, specialty_source_concept_id, gender_source_value, gender_source_concept_id) VALUES (12674, NULL, '1585545429', NULL, NULL, 8192, NULL, NULL, '1585545429', NULL, NULL, NULL, NULL);
INSERT INTO provider (provider_id, provider_name, npi, dea, specialty_concept_id, care_site_id, year_of_birth, gender_concept_id, provider_source_value, specialty_source_value, specialty_source_concept_id, gender_source_value, gender_source_concept_id) VALUES (21645, NULL, '1675753794', NULL, NULL, 13448, NULL, NULL, '1675753794', NULL, NULL, NULL, NULL);
INSERT INTO provider (provider_id, provider_name, npi, dea, specialty_concept_id, care_site_id, year_of_birth, gender_concept_id, provider_source_value, specialty_source_value, specialty_source_concept_id, gender_source_value, gender_source_concept_id) VALUES (21673, NULL, '3029653459', NULL, NULL, 13456, NULL, NULL, '3029653459', NULL, NULL, NULL, NULL);
INSERT INTO provider (provider_id, provider_name, npi, dea, specialty_concept_id, care_site_id, year_of_birth, gender_concept_id, provider_source_value, specialty_source_value, specialty_source_concept_id, gender_source_value, gender_source_concept_id) VALUES (31857, NULL, '1297294125', NULL, NULL, 13897, NULL, NULL, '5558383891', NULL, NULL, NULL, NULL);
INSERT INTO provider (provider_id, provider_name, npi, dea, specialty_concept_id, care_site_id, year_of_birth, gender_concept_id, provider_source_value, specialty_source_value, specialty_source_concept_id, gender_source_value, gender_source_concept_id) VALUES (31906, NULL, '5627631235', NULL, NULL, 18956, NULL, NULL, '5627631235', NULL, NULL, NULL, NULL);
INSERT INTO provider (provider_id, provider_name, npi, dea, specialty_concept_id, care_site_id, year_of_birth, gender_concept_id, provider_source_value, specialty_source_value, specialty_source_concept_id, gender_source_value, gender_source_concept_id) VALUES (36303, NULL, '8709543285', NULL, NULL, 21318, NULL, NULL, '8709543285', NULL, NULL, NULL, NULL);
INSERT INTO provider (provider_id, provider_name, npi, dea, specialty_concept_id, care_site_id, year_of_birth, gender_concept_id, provider_source_value, specialty_source_value, specialty_source_concept_id, gender_source_value, gender_source_concept_id) VALUES (60753, NULL, '7493033584', NULL, NULL, 3875, NULL, NULL, '7493033584', NULL, NULL, NULL, NULL);
INSERT INTO provider (provider_id, provider_name, npi, dea, specialty_concept_id, care_site_id, year_of_birth, gender_concept_id, provider_source_value, specialty_source_value, specialty_source_concept_id, gender_source_value, gender_source_concept_id) VALUES (61112, NULL, '6185713175', NULL, NULL, 33580, NULL, NULL, '6185713175', NULL, NULL, NULL, NULL);
INSERT INTO provider (provider_id, provider_name, npi, dea, specialty_concept_id, care_site_id, year_of_birth, gender_concept_id, provider_source_value, specialty_source_value, specialty_source_concept_id, gender_source_value, gender_source_concept_id) VALUES (61118, NULL, '4704222145', NULL, NULL, 33583, NULL, NULL, '4704222145', NULL, NULL, NULL, NULL);
INSERT INTO provider (provider_id, provider_name, npi, dea, specialty_concept_id, care_site_id, year_of_birth, gender_concept_id, provider_source_value, specialty_source_value, specialty_source_concept_id, gender_source_value, gender_source_concept_id) VALUES (83104, NULL, '5760836510', NULL, NULL, 43378, NULL, NULL, '5760836510', NULL, NULL, NULL, NULL);
INSERT INTO provider (provider_id, provider_name, npi, dea, specialty_concept_id, care_site_id, year_of_birth, gender_concept_id, provider_source_value, specialty_source_value, specialty_source_concept_id, gender_source_value, gender_source_concept_id) VALUES (95836, NULL, '7555637958', NULL, NULL, 16990, NULL, NULL, '7555637958', NULL, NULL, NULL, NULL);
INSERT INTO provider (provider_id, provider_name, npi, dea, specialty_concept_id, care_site_id, year_of_birth, gender_concept_id, provider_source_value, specialty_source_value, specialty_source_concept_id, gender_source_value, gender_source_concept_id) VALUES (99551, NULL, '2745793733', NULL, NULL, 50533, NULL, NULL, '2745793733', NULL, NULL, NULL, NULL);
INSERT INTO provider (provider_id, provider_name, npi, dea, specialty_concept_id, care_site_id, year_of_birth, gender_concept_id, provider_source_value, specialty_source_value, specialty_source_concept_id, gender_source_value, gender_source_concept_id) VALUES (192777, NULL, '4068240371', NULL, NULL, 9812, NULL, NULL, '4068240371', NULL, NULL, NULL, NULL);
INSERT INTO provider (provider_id, provider_name, npi, dea, specialty_concept_id, care_site_id, year_of_birth, gender_concept_id, provider_source_value, specialty_source_value, specialty_source_concept_id, gender_source_value, gender_source_concept_id) VALUES (197101, NULL, '3898895883', NULL, NULL, 15128, NULL, NULL, '3898895883', NULL, NULL, NULL, NULL);
INSERT INTO provider (provider_id, provider_name, npi, dea, specialty_concept_id, care_site_id, year_of_birth, gender_concept_id, provider_source_value, specialty_source_value, specialty_source_concept_id, gender_source_value, gender_source_concept_id) VALUES (272592, NULL, '3278019001', NULL, NULL, 117750, NULL, NULL, '3278019001', NULL, NULL, NULL, NULL);
INSERT INTO provider (provider_id, provider_name, npi, dea, specialty_concept_id, care_site_id, year_of_birth, gender_concept_id, provider_source_value, specialty_source_value, specialty_source_concept_id, gender_source_value, gender_source_concept_id) VALUES (279614, NULL, '0251941872', NULL, NULL, 8292, NULL, NULL, '0251941872', NULL, NULL, NULL, NULL);
INSERT INTO provider (provider_id, provider_name, npi, dea, specialty_concept_id, care_site_id, year_of_birth, gender_concept_id, provider_source_value, specialty_source_value, specialty_source_concept_id, gender_source_value, gender_source_concept_id) VALUES (329631, NULL, '0918290257', NULL, NULL, 137825, NULL, NULL, '0918290257', NULL, NULL, NULL, NULL);
INSERT INTO provider (provider_id, provider_name, npi, dea, specialty_concept_id, care_site_id, year_of_birth, gender_concept_id, provider_source_value, specialty_source_value, specialty_source_concept_id, gender_source_value, gender_source_concept_id) VALUES (339214, NULL, '8377925524', NULL, NULL, 33787, NULL, NULL, '8377925524', NULL, NULL, NULL, NULL);
INSERT INTO provider (provider_id, provider_name, npi, dea, specialty_concept_id, care_site_id, year_of_birth, gender_concept_id, provider_source_value, specialty_source_value, specialty_source_concept_id, gender_source_value, gender_source_concept_id) VALUES (435002, NULL, '6715807722', NULL, NULL, 1640, NULL, NULL, '6715807722', NULL, NULL, NULL, NULL);



INSERT INTO relationship (relationship_id, relationship_name, is_hierarchical, defines_ancestry, reverse_relationship_id, relationship_concept_id) VALUES ('Is a', 'Is a', '1', '0', 'Subsumes', 44818821);
INSERT INTO relationship (relationship_id, relationship_name, is_hierarchical, defines_ancestry, reverse_relationship_id, relationship_concept_id) VALUES ('Subsumes', 'Subsumes', '1', '1', 'Is a', 44818723);












INSERT INTO visit_occurrence (visit_occurrence_id, person_id, visit_concept_id, visit_start_date, visit_start_time, visit_end_date, visit_end_time, visit_type_concept_id, provider_id, care_site_id, visit_source_value, visit_source_concept_id) VALUES (88179, 1780, 9201, '2008-04-09', NULL, '2008-04-13', NULL, 44818517, 5247, 3617, '196291177015950', NULL);
INSERT INTO visit_occurrence (visit_occurrence_id, person_id, visit_concept_id, visit_start_date, visit_start_time, visit_end_date, visit_end_time, visit_type_concept_id, provider_id, care_site_id, visit_source_value, visit_source_concept_id) VALUES (88214, 1780, 0, '2008-11-22', NULL, '2008-11-22', NULL, 44818517, 12674, 8192, '887173388289786', NULL);
INSERT INTO visit_occurrence (visit_occurrence_id, person_id, visit_concept_id, visit_start_date, visit_start_time, visit_end_date, visit_end_time, visit_type_concept_id, provider_id, care_site_id, visit_source_value, visit_source_concept_id) VALUES (88246, 1780, 0, '2008-04-10', NULL, '2008-04-10', NULL, 44818517, 61112, 33580, '887603388972081', NULL);
INSERT INTO visit_occurrence (visit_occurrence_id, person_id, visit_concept_id, visit_start_date, visit_start_time, visit_end_date, visit_end_time, visit_type_concept_id, provider_id, care_site_id, visit_source_value, visit_source_concept_id) VALUES (88263, 1780, 0, '2009-05-22', NULL, '2009-05-22', NULL, 44818517, 61118, 33583, '887783385045412', NULL);
INSERT INTO visit_occurrence (visit_occurrence_id, person_id, visit_concept_id, visit_start_date, visit_start_time, visit_end_date, visit_end_time, visit_type_concept_id, provider_id, care_site_id, visit_source_value, visit_source_concept_id) VALUES (1454883, 30091, 9201, '2009-07-30', NULL, '2009-08-07', NULL, 44818517, 5705, 3903, '196281176996667', NULL);
INSERT INTO visit_occurrence (visit_occurrence_id, person_id, visit_concept_id, visit_start_date, visit_start_time, visit_end_date, visit_end_time, visit_type_concept_id, provider_id, care_site_id, visit_source_value, visit_source_concept_id) VALUES (1454884, 30091, 9202, '2009-08-02', NULL, '2009-08-03', NULL, 44818517, 2185, 1422, '542382281564140', NULL);
INSERT INTO visit_occurrence (visit_occurrence_id, person_id, visit_concept_id, visit_start_date, visit_start_time, visit_end_date, visit_end_time, visit_type_concept_id, provider_id, care_site_id, visit_source_value, visit_source_concept_id) VALUES (1454922, 30091, 0, '2008-11-12', NULL, '2008-11-12', NULL, 44818517, 36303, 34511, '887653385597344', NULL);
INSERT INTO visit_occurrence (visit_occurrence_id, person_id, visit_concept_id, visit_start_date, visit_start_time, visit_end_date, visit_end_time, visit_type_concept_id, provider_id, care_site_id, visit_source_value, visit_source_concept_id) VALUES (1813776, 37455, 0, '2008-10-30', NULL, '2008-10-30', NULL, 44818517, 16, 13, '887303387403537', NULL);
INSERT INTO visit_occurrence (visit_occurrence_id, person_id, visit_concept_id, visit_start_date, visit_start_time, visit_end_date, visit_end_time, visit_type_concept_id, provider_id, care_site_id, visit_source_value, visit_source_concept_id) VALUES (1813788, 37455, 0, '2010-08-12', NULL, '2010-08-12', NULL, 44818517, 272592, 117750, '887403387342227', NULL);
INSERT INTO visit_occurrence (visit_occurrence_id, person_id, visit_concept_id, visit_start_date, visit_start_time, visit_end_date, visit_end_time, visit_type_concept_id, provider_id, care_site_id, visit_source_value, visit_source_concept_id) VALUES (1813856, 37455, 0, '2008-03-18', NULL, '2008-03-18', NULL, 44818517, 279614, 8292, '887973386143218', NULL);
INSERT INTO visit_occurrence (visit_occurrence_id, person_id, visit_concept_id, visit_start_date, visit_start_time, visit_end_date, visit_end_time, visit_type_concept_id, provider_id, care_site_id, visit_source_value, visit_source_concept_id) VALUES (2046364, 42383, 0, '2010-04-15', NULL, '2010-04-15', NULL, 44818517, 1883, 1224, '887513385863530', NULL);
INSERT INTO visit_occurrence (visit_occurrence_id, person_id, visit_concept_id, visit_start_date, visit_start_time, visit_end_date, visit_end_time, visit_type_concept_id, provider_id, care_site_id, visit_source_value, visit_source_concept_id) VALUES (2046380, 42383, 0, '2009-06-29', NULL, '2009-06-29', NULL, 44818517, 689, 40, '887663385765962', NULL);
INSERT INTO visit_occurrence (visit_occurrence_id, person_id, visit_concept_id, visit_start_date, visit_start_time, visit_end_date, visit_end_time, visit_type_concept_id, provider_id, care_site_id, visit_source_value, visit_source_concept_id) VALUES (3359790, 69985, 9201, '2010-07-22', NULL, '2010-07-30', NULL, 44818517, 83104, 43378, '196721177014598', NULL);
INSERT INTO visit_occurrence (visit_occurrence_id, person_id, visit_concept_id, visit_start_date, visit_start_time, visit_end_date, visit_end_time, visit_type_concept_id, provider_id, care_site_id, visit_source_value, visit_source_concept_id) VALUES (3359810, 69985, 9202, '2010-05-06', NULL, '2010-05-07', NULL, 44818517, 329631, 137825, '542432281351241', NULL);
INSERT INTO visit_occurrence (visit_occurrence_id, person_id, visit_concept_id, visit_start_date, visit_start_time, visit_end_date, visit_end_time, visit_type_concept_id, provider_id, care_site_id, visit_source_value, visit_source_concept_id) VALUES (3359817, 69985, 9202, '2009-01-09', NULL, '2009-01-09', NULL, 44818517, 21645, 13448, '542632281596186', NULL);
INSERT INTO visit_occurrence (visit_occurrence_id, person_id, visit_concept_id, visit_start_date, visit_start_time, visit_end_date, visit_end_time, visit_type_concept_id, provider_id, care_site_id, visit_source_value, visit_source_concept_id) VALUES (3359838, 69985, 0, '2010-04-17', NULL, '2010-04-17', NULL, 44818517, 21673, 13456, '887083389211562', NULL);
INSERT INTO visit_occurrence (visit_occurrence_id, person_id, visit_concept_id, visit_start_date, visit_start_time, visit_end_date, visit_end_time, visit_type_concept_id, provider_id, care_site_id, visit_source_value, visit_source_concept_id) VALUES (3461442, 72120, 0, '2008-12-15', NULL, '2008-12-15', NULL, 44818517, 339214, 33787, '887973385532219', NULL);
INSERT INTO visit_occurrence (visit_occurrence_id, person_id, visit_concept_id, visit_start_date, visit_start_time, visit_end_date, visit_end_time, visit_type_concept_id, provider_id, care_site_id, visit_source_value, visit_source_concept_id) VALUES (3952172, 82328, 0, '2009-01-25', NULL, '2009-01-25', NULL, 44818517, 5516, 3783, '887263388757452', NULL);
INSERT INTO visit_occurrence (visit_occurrence_id, person_id, visit_concept_id, visit_start_date, visit_start_time, visit_end_date, visit_end_time, visit_type_concept_id, provider_id, care_site_id, visit_source_value, visit_source_concept_id) VALUES (3952218, 82328, 0, '2008-10-20', NULL, '2008-10-20', NULL, 44818517, 197101, 103488, '887853385750027', NULL);
INSERT INTO visit_occurrence (visit_occurrence_id, person_id, visit_concept_id, visit_start_date, visit_start_time, visit_end_date, visit_end_time, visit_type_concept_id, provider_id, care_site_id, visit_source_value, visit_source_concept_id) VALUES (4586628, 95538, 9201, '2009-03-30', NULL, '2009-04-03', NULL, 44818517, 95836, 23997, '196421176984336', NULL);
INSERT INTO visit_occurrence (visit_occurrence_id, person_id, visit_concept_id, visit_start_date, visit_start_time, visit_end_date, visit_end_time, visit_type_concept_id, provider_id, care_site_id, visit_source_value, visit_source_concept_id) VALUES (4586653, 95538, 0, '2009-09-02', NULL, '2009-09-02', NULL, 44818517, 435002, 1640, '887503389372256', NULL);
INSERT INTO visit_occurrence (visit_occurrence_id, person_id, visit_concept_id, visit_start_date, visit_start_time, visit_end_date, visit_end_time, visit_type_concept_id, provider_id, care_site_id, visit_source_value, visit_source_concept_id) VALUES (5162803, 107680, 9201, '2009-07-20', NULL, '2009-07-30', NULL, 44818517, 60753, 3852, '196821177024627', NULL);
INSERT INTO visit_occurrence (visit_occurrence_id, person_id, visit_concept_id, visit_start_date, visit_start_time, visit_end_date, visit_end_time, visit_type_concept_id, provider_id, care_site_id, visit_source_value, visit_source_concept_id) VALUES (5162964, 107680, 0, '2009-06-07', NULL, '2009-06-07', NULL, 44818517, 99551, 50533, '887853389454425', NULL);
INSERT INTO visit_occurrence (visit_occurrence_id, person_id, visit_concept_id, visit_start_date, visit_start_time, visit_end_date, visit_end_time, visit_type_concept_id, provider_id, care_site_id, visit_source_value, visit_source_concept_id) VALUES (5314664, 110862, 9201, '2009-09-30', NULL, '2009-10-01', NULL, 44818517, 31857, 13897, '196711177008260', NULL);
INSERT INTO visit_occurrence (visit_occurrence_id, person_id, visit_concept_id, visit_start_date, visit_start_time, visit_end_date, visit_end_time, visit_type_concept_id, provider_id, care_site_id, visit_source_value, visit_source_concept_id) VALUES (5314671, 110862, 9202, '2008-09-07', NULL, '2008-09-16', NULL, 44818517, 5159, 3547, '542542280986566', NULL);
INSERT INTO visit_occurrence (visit_occurrence_id, person_id, visit_concept_id, visit_start_date, visit_start_time, visit_end_date, visit_end_time, visit_type_concept_id, provider_id, care_site_id, visit_source_value, visit_source_concept_id) VALUES (5314690, 110862, 0, '2009-06-30', NULL, '2009-06-30', NULL, 44818517, 31906, 18956, '887353385562503', NULL);
INSERT INTO visit_occurrence (visit_occurrence_id, person_id, visit_concept_id, visit_start_date, visit_start_time, visit_end_date, visit_end_time, visit_type_concept_id, provider_id, care_site_id, visit_source_value, visit_source_concept_id) VALUES (5314696, 110862, 0, '2010-06-07', NULL, '2010-06-07', NULL, 44818517, 192777, 9812, '887423388391758', NULL);



INSERT INTO vocabulary (vocabulary_id, vocabulary_name, vocabulary_reference, vocabulary_version, vocabulary_concept_id) VALUES ('CMS Place of Service', 'Place of Service Codes for Professional Claims (CMS)', 'http://www.cms.gov/Medicare/Medicare-Fee-for-Service-Payment/PhysicianFeeSched/downloads//Website_POS_database.pdf', '2009-01-11', 44819110);
INSERT INTO vocabulary (vocabulary_id, vocabulary_name, vocabulary_reference, vocabulary_version, vocabulary_concept_id) VALUES ('Cohort', 'Legacy OMOP HOI or DOI cohort', 'OMOP generated', NULL, 44819123);
INSERT INTO vocabulary (vocabulary_id, vocabulary_name, vocabulary_reference, vocabulary_version, vocabulary_concept_id) VALUES ('Concept Class', 'OMOP Concept Class', 'OMOP generated', NULL, 44819233);
INSERT INTO vocabulary (vocabulary_id, vocabulary_name, vocabulary_reference, vocabulary_version, vocabulary_concept_id) VALUES ('Condition Type', 'OMOP Condition Occurrence Type', 'OMOP generated', NULL, 44819127);
INSERT INTO vocabulary (vocabulary_id, vocabulary_name, vocabulary_reference, vocabulary_version, vocabulary_concept_id) VALUES ('Domain', 'OMOP Domain', 'OMOP generated', NULL, 44819147);
INSERT INTO vocabulary (vocabulary_id, vocabulary_name, vocabulary_reference, vocabulary_version, vocabulary_concept_id) VALUES ('Drug Type', 'OMOP Drug Exposure Type', 'OMOP generated', NULL, 44819126);
INSERT INTO vocabulary (vocabulary_id, vocabulary_name, vocabulary_reference, vocabulary_version, vocabulary_concept_id) VALUES ('Ethnicity', 'OMOP Ethnicity', 'OMOP generated', NULL, 44819134);
INSERT INTO vocabulary (vocabulary_id, vocabulary_name, vocabulary_reference, vocabulary_version, vocabulary_concept_id) VALUES ('Gender', 'OMOP Gender', 'OMOP generated', NULL, 44819108);
INSERT INTO vocabulary (vocabulary_id, vocabulary_name, vocabulary_reference, vocabulary_version, vocabulary_concept_id) VALUES ('ICD9CM', 'International Classification of Diseases, Ninth Revision, Clinical Modification, Volume 1 and 2 (NCHS)', 'http://www.cms.gov/Medicare/Coding/ICD9ProviderDiagnosticCodes/codes.html', 'ICD9CM v32 master descriptions', 5046);
INSERT INTO vocabulary (vocabulary_id, vocabulary_name, vocabulary_reference, vocabulary_version, vocabulary_concept_id) VALUES ('NDC', 'National Drug Code (FDA and manufacturers)', 'http://www.nlm.nih.gov/research/umls/rxnorm/docs/rxnormfiles.html, http://www.fda.gov/downloads/Drugs/DevelopmentApprovalProcess/UCM070838.zip', 'NDC 20190519', 44819105);
INSERT INTO vocabulary (vocabulary_id, vocabulary_name, vocabulary_reference, vocabulary_version, vocabulary_concept_id) VALUES ('None', 'OMOP Standardized Vocabularies', 'OMOP generated', 'v5.0 21-MAY-19', 44819096);
INSERT INTO vocabulary (vocabulary_id, vocabulary_name, vocabulary_reference, vocabulary_version, vocabulary_concept_id) VALUES ('Obs Period Type', 'OMOP Observation Period Type', 'OMOP generated', NULL, 44819149);
INSERT INTO vocabulary (vocabulary_id, vocabulary_name, vocabulary_reference, vocabulary_version, vocabulary_concept_id) VALUES ('Race', 'Race and Ethnicity Code Set (USBC)', 'http://www.cdc.gov/nchs/data/dvs/Race_Ethnicity_CodeSet.pdf', 'Version 1.0', 44819109);
INSERT INTO vocabulary (vocabulary_id, vocabulary_name, vocabulary_reference, vocabulary_version, vocabulary_concept_id) VALUES ('Relationship', 'OMOP Relationship', 'OMOP generated', NULL, 44819235);
INSERT INTO vocabulary (vocabulary_id, vocabulary_name, vocabulary_reference, vocabulary_version, vocabulary_concept_id) VALUES ('RxNorm', 'RxNorm (NLM)', 'http://www.nlm.nih.gov/research/umls/rxnorm/docs/rxnormfiles.html', 'RxNorm 20190506', 44819104);
INSERT INTO vocabulary (vocabulary_id, vocabulary_name, vocabulary_reference, vocabulary_version, vocabulary_concept_id) VALUES ('SNOMED', 'Systematic Nomenclature of Medicine - Clinical Terms (IHTSDO)', 'http://www.nlm.nih.gov/research/umls/licensedcontent/umlsknowledgesources.html', 'Snomed Release 20190131', 44819097);
INSERT INTO vocabulary (vocabulary_id, vocabulary_name, vocabulary_reference, vocabulary_version, vocabulary_concept_id) VALUES ('Visit', 'OMOP Visit', 'OMOP generated', NULL, 44819119);
INSERT INTO vocabulary (vocabulary_id, vocabulary_name, vocabulary_reference, vocabulary_version, vocabulary_concept_id) VALUES ('Visit Type', 'OMOP Visit Type', 'OMOP generated', NULL, 44819150);
INSERT INTO vocabulary (vocabulary_id, vocabulary_name, vocabulary_reference, vocabulary_version, vocabulary_concept_id) VALUES ('Vocabulary', 'OMOP Vocabulary', 'OMOP generated', NULL, 44819232);



SELECT pg_catalog.setval('condition_era_sequence', 1, false);



SELECT pg_catalog.setval('drug_era_sequence', 1, false);



ALTER TABLE ONLY attribute_definition
    ADD CONSTRAINT xpk_attribute_definition PRIMARY KEY (attribute_definition_id);



ALTER TABLE ONLY care_site
    ADD CONSTRAINT xpk_care_site PRIMARY KEY (care_site_id);



ALTER TABLE ONLY cohort
    ADD CONSTRAINT xpk_cohort PRIMARY KEY (cohort_definition_id, subject_id, cohort_start_date, cohort_end_date);



ALTER TABLE ONLY cohort_attribute
    ADD CONSTRAINT xpk_cohort_attribute PRIMARY KEY (cohort_definition_id, subject_id, cohort_start_date, cohort_end_date, attribute_definition_id);



ALTER TABLE ONLY cohort_definition
    ADD CONSTRAINT xpk_cohort_definition PRIMARY KEY (cohort_definition_id);



ALTER TABLE ONLY concept
    ADD CONSTRAINT xpk_concept PRIMARY KEY (concept_id);



ALTER TABLE ONLY concept_ancestor
    ADD CONSTRAINT xpk_concept_ancestor PRIMARY KEY (ancestor_concept_id, descendant_concept_id);



ALTER TABLE ONLY concept_class
    ADD CONSTRAINT xpk_concept_class PRIMARY KEY (concept_class_id);



ALTER TABLE ONLY concept_relationship
    ADD CONSTRAINT xpk_concept_relationship PRIMARY KEY (concept_id_1, concept_id_2, relationship_id);



ALTER TABLE ONLY condition_era
    ADD CONSTRAINT xpk_condition_era PRIMARY KEY (condition_era_id);



ALTER TABLE ONLY condition_occurrence
    ADD CONSTRAINT xpk_condition_occurrence PRIMARY KEY (condition_occurrence_id);



ALTER TABLE ONLY death
    ADD CONSTRAINT xpk_death PRIMARY KEY (person_id);



ALTER TABLE ONLY device_cost
    ADD CONSTRAINT xpk_device_cost PRIMARY KEY (device_cost_id);



ALTER TABLE ONLY device_exposure
    ADD CONSTRAINT xpk_device_exposure PRIMARY KEY (device_exposure_id);



ALTER TABLE ONLY domain
    ADD CONSTRAINT xpk_domain PRIMARY KEY (domain_id);



ALTER TABLE ONLY dose_era
    ADD CONSTRAINT xpk_dose_era PRIMARY KEY (dose_era_id);



ALTER TABLE ONLY drug_cost
    ADD CONSTRAINT xpk_drug_cost PRIMARY KEY (drug_cost_id);



ALTER TABLE ONLY drug_era
    ADD CONSTRAINT xpk_drug_era PRIMARY KEY (drug_era_id);



ALTER TABLE ONLY drug_exposure
    ADD CONSTRAINT xpk_drug_exposure PRIMARY KEY (drug_exposure_id);



ALTER TABLE ONLY drug_strength
    ADD CONSTRAINT xpk_drug_strength PRIMARY KEY (drug_concept_id, ingredient_concept_id);



ALTER TABLE ONLY location
    ADD CONSTRAINT xpk_location PRIMARY KEY (location_id);



ALTER TABLE ONLY measurement
    ADD CONSTRAINT xpk_measurement PRIMARY KEY (measurement_id);



ALTER TABLE ONLY note
    ADD CONSTRAINT xpk_note PRIMARY KEY (note_id);



ALTER TABLE ONLY observation
    ADD CONSTRAINT xpk_observation PRIMARY KEY (observation_id);



ALTER TABLE ONLY observation_period
    ADD CONSTRAINT xpk_observation_period PRIMARY KEY (observation_period_id);



ALTER TABLE ONLY payer_plan_period
    ADD CONSTRAINT xpk_payer_plan_period PRIMARY KEY (payer_plan_period_id);



ALTER TABLE ONLY person
    ADD CONSTRAINT xpk_person PRIMARY KEY (person_id);



ALTER TABLE ONLY procedure_cost
    ADD CONSTRAINT xpk_procedure_cost PRIMARY KEY (procedure_cost_id);



ALTER TABLE ONLY procedure_occurrence
    ADD CONSTRAINT xpk_procedure_occurrence PRIMARY KEY (procedure_occurrence_id);



ALTER TABLE ONLY provider
    ADD CONSTRAINT xpk_provider PRIMARY KEY (provider_id);



ALTER TABLE ONLY relationship
    ADD CONSTRAINT xpk_relationship PRIMARY KEY (relationship_id);



ALTER TABLE ONLY source_to_concept_map
    ADD CONSTRAINT xpk_source_to_concept_map PRIMARY KEY (source_vocabulary_id, target_concept_id, source_code, valid_end_date);



ALTER TABLE ONLY specimen
    ADD CONSTRAINT xpk_specimen PRIMARY KEY (specimen_id);



ALTER TABLE ONLY visit_cost
    ADD CONSTRAINT xpk_visit_cost PRIMARY KEY (visit_cost_id);



ALTER TABLE ONLY visit_occurrence
    ADD CONSTRAINT xpk_visit_occurrence PRIMARY KEY (visit_occurrence_id);



ALTER TABLE ONLY vocabulary
    ADD CONSTRAINT xpk_vocabulary PRIMARY KEY (vocabulary_id);



CREATE INDEX idx_attribute_definition_id ON attribute_definition USING btree (attribute_definition_id);

ALTER TABLE attribute_definition CLUSTER ON idx_attribute_definition_id;



CREATE INDEX idx_ca_definition_id ON cohort_attribute USING btree (cohort_definition_id);



CREATE INDEX idx_ca_subject_id ON cohort_attribute USING btree (subject_id);



CREATE INDEX idx_cohort_c_definition_id ON cohort USING btree (cohort_definition_id);



CREATE INDEX idx_cohort_definition_id ON cohort_definition USING btree (cohort_definition_id);

ALTER TABLE cohort_definition CLUSTER ON idx_cohort_definition_id;



CREATE INDEX idx_cohort_subject_id ON cohort USING btree (subject_id);



CREATE INDEX idx_concept_ancestor_id_1 ON concept_ancestor USING btree (ancestor_concept_id);

ALTER TABLE concept_ancestor CLUSTER ON idx_concept_ancestor_id_1;



CREATE INDEX idx_concept_ancestor_id_2 ON concept_ancestor USING btree (descendant_concept_id);



CREATE UNIQUE INDEX idx_concept_class_class_id ON concept_class USING btree (concept_class_id);

ALTER TABLE concept_class CLUSTER ON idx_concept_class_class_id;



CREATE INDEX idx_concept_class_id ON concept USING btree (concept_class_id);



CREATE INDEX idx_concept_code ON concept USING btree (concept_code);



CREATE UNIQUE INDEX idx_concept_concept_id ON concept USING btree (concept_id);

ALTER TABLE concept CLUSTER ON idx_concept_concept_id;



CREATE INDEX idx_concept_domain_id ON concept USING btree (domain_id);



CREATE INDEX idx_concept_relationship_id_1 ON concept_relationship USING btree (concept_id_1);



CREATE INDEX idx_concept_relationship_id_2 ON concept_relationship USING btree (concept_id_2);



CREATE INDEX idx_concept_relationship_id_3 ON concept_relationship USING btree (relationship_id);



CREATE INDEX idx_concept_synonym_id ON concept_synonym USING btree (concept_id);

ALTER TABLE concept_synonym CLUSTER ON idx_concept_synonym_id;



CREATE INDEX idx_concept_vocabluary_id ON concept USING btree (vocabulary_id);



CREATE INDEX idx_condition_concept_id ON condition_occurrence USING btree (condition_concept_id);



CREATE INDEX idx_condition_era_concept_id ON condition_era USING btree (condition_concept_id);



CREATE INDEX idx_condition_era_person_id ON condition_era USING btree (person_id);

ALTER TABLE condition_era CLUSTER ON idx_condition_era_person_id;



CREATE INDEX idx_condition_person_id ON condition_occurrence USING btree (person_id);

ALTER TABLE condition_occurrence CLUSTER ON idx_condition_person_id;



CREATE INDEX idx_condition_visit_id ON condition_occurrence USING btree (visit_occurrence_id);



CREATE INDEX idx_death_person_id ON death USING btree (person_id);

ALTER TABLE death CLUSTER ON idx_death_person_id;



CREATE INDEX idx_device_concept_id ON device_exposure USING btree (device_concept_id);



CREATE INDEX idx_device_person_id ON device_exposure USING btree (person_id);

ALTER TABLE device_exposure CLUSTER ON idx_device_person_id;



CREATE INDEX idx_device_visit_id ON device_exposure USING btree (visit_occurrence_id);



CREATE UNIQUE INDEX idx_domain_domain_id ON domain USING btree (domain_id);

ALTER TABLE domain CLUSTER ON idx_domain_domain_id;



CREATE INDEX idx_dose_era_concept_id ON dose_era USING btree (drug_concept_id);



CREATE INDEX idx_dose_era_person_id ON dose_era USING btree (person_id);

ALTER TABLE dose_era CLUSTER ON idx_dose_era_person_id;



CREATE INDEX idx_drug_concept_id ON drug_exposure USING btree (drug_concept_id);



CREATE INDEX idx_drug_era_concept_id ON drug_era USING btree (drug_concept_id);



CREATE INDEX idx_drug_era_person_id ON drug_era USING btree (person_id);

ALTER TABLE drug_era CLUSTER ON idx_drug_era_person_id;



CREATE INDEX idx_drug_person_id ON drug_exposure USING btree (person_id);

ALTER TABLE drug_exposure CLUSTER ON idx_drug_person_id;



CREATE INDEX idx_drug_strength_id_1 ON drug_strength USING btree (drug_concept_id);

ALTER TABLE drug_strength CLUSTER ON idx_drug_strength_id_1;



CREATE INDEX idx_drug_strength_id_2 ON drug_strength USING btree (ingredient_concept_id);



CREATE INDEX idx_drug_visit_id ON drug_exposure USING btree (visit_occurrence_id);



CREATE INDEX idx_fact_relationship_id_1 ON fact_relationship USING btree (domain_concept_id_1);



CREATE INDEX idx_fact_relationship_id_2 ON fact_relationship USING btree (domain_concept_id_2);



CREATE INDEX idx_fact_relationship_id_3 ON fact_relationship USING btree (relationship_concept_id);



CREATE INDEX idx_measurement_concept_id ON measurement USING btree (measurement_concept_id);



CREATE INDEX idx_measurement_person_id ON measurement USING btree (person_id);

ALTER TABLE measurement CLUSTER ON idx_measurement_person_id;



CREATE INDEX idx_measurement_visit_id ON measurement USING btree (visit_occurrence_id);



CREATE INDEX idx_note_concept_id ON note USING btree (note_type_concept_id);



CREATE INDEX idx_note_person_id ON note USING btree (person_id);

ALTER TABLE note CLUSTER ON idx_note_person_id;



CREATE INDEX idx_note_visit_id ON note USING btree (visit_occurrence_id);



CREATE INDEX idx_observation_concept_id ON observation USING btree (observation_concept_id);



CREATE INDEX idx_observation_period_id ON observation_period USING btree (person_id);

ALTER TABLE observation_period CLUSTER ON idx_observation_period_id;



CREATE INDEX idx_observation_person_id ON observation USING btree (person_id);

ALTER TABLE observation CLUSTER ON idx_observation_person_id;



CREATE INDEX idx_observation_visit_id ON observation USING btree (visit_occurrence_id);



CREATE INDEX idx_period_person_id ON payer_plan_period USING btree (person_id);

ALTER TABLE payer_plan_period CLUSTER ON idx_period_person_id;



CREATE UNIQUE INDEX idx_person_id ON person USING btree (person_id);

ALTER TABLE person CLUSTER ON idx_person_id;



CREATE INDEX idx_procedure_concept_id ON procedure_occurrence USING btree (procedure_concept_id);



CREATE INDEX idx_procedure_person_id ON procedure_occurrence USING btree (person_id);

ALTER TABLE procedure_occurrence CLUSTER ON idx_procedure_person_id;



CREATE INDEX idx_procedure_visit_id ON procedure_occurrence USING btree (visit_occurrence_id);



CREATE UNIQUE INDEX idx_relationship_rel_id ON relationship USING btree (relationship_id);

ALTER TABLE relationship CLUSTER ON idx_relationship_rel_id;



CREATE INDEX idx_source_to_concept_map_code ON source_to_concept_map USING btree (source_code);



CREATE INDEX idx_source_to_concept_map_id_1 ON source_to_concept_map USING btree (source_vocabulary_id);



CREATE INDEX idx_source_to_concept_map_id_2 ON source_to_concept_map USING btree (target_vocabulary_id);



CREATE INDEX idx_source_to_concept_map_id_3 ON source_to_concept_map USING btree (target_concept_id);

ALTER TABLE source_to_concept_map CLUSTER ON idx_source_to_concept_map_id_3;



CREATE INDEX idx_specimen_concept_id ON specimen USING btree (specimen_concept_id);



CREATE INDEX idx_specimen_person_id ON specimen USING btree (person_id);

ALTER TABLE specimen CLUSTER ON idx_specimen_person_id;



CREATE INDEX idx_visit_concept_id ON visit_occurrence USING btree (visit_concept_id);



CREATE INDEX idx_visit_person_id ON visit_occurrence USING btree (person_id);

ALTER TABLE visit_occurrence CLUSTER ON idx_visit_person_id;



CREATE UNIQUE INDEX idx_vocabulary_vocabulary_id ON vocabulary USING btree (vocabulary_id);

ALTER TABLE vocabulary CLUSTER ON idx_vocabulary_vocabulary_id;



ALTER TABLE ONLY cohort_attribute
    ADD CONSTRAINT fpk_ca_attribute_definition FOREIGN KEY (attribute_definition_id) REFERENCES attribute_definition(attribute_definition_id);



ALTER TABLE ONLY cohort_attribute
    ADD CONSTRAINT fpk_ca_cohort_definition FOREIGN KEY (cohort_definition_id) REFERENCES cohort_definition(cohort_definition_id);



ALTER TABLE ONLY cohort_attribute
    ADD CONSTRAINT fpk_ca_value FOREIGN KEY (value_as_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY care_site
    ADD CONSTRAINT fpk_care_site_location FOREIGN KEY (location_id) REFERENCES location(location_id);



ALTER TABLE ONLY care_site
    ADD CONSTRAINT fpk_care_site_place FOREIGN KEY (place_of_service_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY cohort
    ADD CONSTRAINT fpk_cohort_definition FOREIGN KEY (cohort_definition_id) REFERENCES cohort_definition(cohort_definition_id);



ALTER TABLE ONLY cohort_definition
    ADD CONSTRAINT fpk_cohort_definition_concept FOREIGN KEY (definition_type_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY concept_ancestor
    ADD CONSTRAINT fpk_concept_ancestor_concept_1 FOREIGN KEY (ancestor_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY concept_ancestor
    ADD CONSTRAINT fpk_concept_ancestor_concept_2 FOREIGN KEY (descendant_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY concept
    ADD CONSTRAINT fpk_concept_class FOREIGN KEY (concept_class_id) REFERENCES concept_class(concept_class_id);



ALTER TABLE ONLY concept_class
    ADD CONSTRAINT fpk_concept_class_concept FOREIGN KEY (concept_class_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY concept
    ADD CONSTRAINT fpk_concept_domain FOREIGN KEY (domain_id) REFERENCES domain(domain_id);



ALTER TABLE ONLY concept_relationship
    ADD CONSTRAINT fpk_concept_relationship_c_1 FOREIGN KEY (concept_id_1) REFERENCES concept(concept_id);



ALTER TABLE ONLY concept_relationship
    ADD CONSTRAINT fpk_concept_relationship_c_2 FOREIGN KEY (concept_id_2) REFERENCES concept(concept_id);



ALTER TABLE ONLY concept_relationship
    ADD CONSTRAINT fpk_concept_relationship_id FOREIGN KEY (relationship_id) REFERENCES relationship(relationship_id);



ALTER TABLE ONLY concept_synonym
    ADD CONSTRAINT fpk_concept_synonym_concept FOREIGN KEY (concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY concept
    ADD CONSTRAINT fpk_concept_vocabulary FOREIGN KEY (vocabulary_id) REFERENCES vocabulary(vocabulary_id);



ALTER TABLE ONLY condition_occurrence
    ADD CONSTRAINT fpk_condition_concept FOREIGN KEY (condition_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY condition_occurrence
    ADD CONSTRAINT fpk_condition_concept_s FOREIGN KEY (condition_source_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY condition_era
    ADD CONSTRAINT fpk_condition_era_concept FOREIGN KEY (condition_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY condition_era
    ADD CONSTRAINT fpk_condition_era_person FOREIGN KEY (person_id) REFERENCES person(person_id);



ALTER TABLE ONLY condition_occurrence
    ADD CONSTRAINT fpk_condition_person FOREIGN KEY (person_id) REFERENCES person(person_id);



ALTER TABLE ONLY condition_occurrence
    ADD CONSTRAINT fpk_condition_provider FOREIGN KEY (provider_id) REFERENCES provider(provider_id);



ALTER TABLE ONLY condition_occurrence
    ADD CONSTRAINT fpk_condition_type_concept FOREIGN KEY (condition_type_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY condition_occurrence
    ADD CONSTRAINT fpk_condition_visit FOREIGN KEY (visit_occurrence_id) REFERENCES visit_occurrence(visit_occurrence_id);



ALTER TABLE ONLY death
    ADD CONSTRAINT fpk_death_cause_concept FOREIGN KEY (cause_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY death
    ADD CONSTRAINT fpk_death_cause_concept_s FOREIGN KEY (cause_source_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY death
    ADD CONSTRAINT fpk_death_person FOREIGN KEY (person_id) REFERENCES person(person_id);



ALTER TABLE ONLY death
    ADD CONSTRAINT fpk_death_type_concept FOREIGN KEY (death_type_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY device_exposure
    ADD CONSTRAINT fpk_device_concept FOREIGN KEY (device_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY device_exposure
    ADD CONSTRAINT fpk_device_concept_s FOREIGN KEY (device_source_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY device_cost
    ADD CONSTRAINT fpk_device_cost_currency FOREIGN KEY (currency_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY device_cost
    ADD CONSTRAINT fpk_device_cost_id FOREIGN KEY (device_exposure_id) REFERENCES device_exposure(device_exposure_id);



ALTER TABLE ONLY device_cost
    ADD CONSTRAINT fpk_device_cost_period FOREIGN KEY (payer_plan_period_id) REFERENCES payer_plan_period(payer_plan_period_id);



ALTER TABLE ONLY device_exposure
    ADD CONSTRAINT fpk_device_person FOREIGN KEY (person_id) REFERENCES person(person_id);



ALTER TABLE ONLY device_exposure
    ADD CONSTRAINT fpk_device_provider FOREIGN KEY (provider_id) REFERENCES provider(provider_id);



ALTER TABLE ONLY device_exposure
    ADD CONSTRAINT fpk_device_type_concept FOREIGN KEY (device_type_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY device_exposure
    ADD CONSTRAINT fpk_device_visit FOREIGN KEY (visit_occurrence_id) REFERENCES visit_occurrence(visit_occurrence_id);



ALTER TABLE ONLY domain
    ADD CONSTRAINT fpk_domain_concept FOREIGN KEY (domain_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY dose_era
    ADD CONSTRAINT fpk_dose_era_concept FOREIGN KEY (drug_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY dose_era
    ADD CONSTRAINT fpk_dose_era_person FOREIGN KEY (person_id) REFERENCES person(person_id);



ALTER TABLE ONLY dose_era
    ADD CONSTRAINT fpk_dose_era_unit_concept FOREIGN KEY (unit_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY drug_exposure
    ADD CONSTRAINT fpk_drug_concept FOREIGN KEY (drug_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY drug_exposure
    ADD CONSTRAINT fpk_drug_concept_s FOREIGN KEY (drug_source_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY drug_cost
    ADD CONSTRAINT fpk_drug_cost_currency FOREIGN KEY (currency_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY drug_cost
    ADD CONSTRAINT fpk_drug_cost_id FOREIGN KEY (drug_exposure_id) REFERENCES drug_exposure(drug_exposure_id);



ALTER TABLE ONLY drug_cost
    ADD CONSTRAINT fpk_drug_cost_period FOREIGN KEY (payer_plan_period_id) REFERENCES payer_plan_period(payer_plan_period_id);



ALTER TABLE ONLY drug_exposure
    ADD CONSTRAINT fpk_drug_dose_unit_concept FOREIGN KEY (dose_unit_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY drug_era
    ADD CONSTRAINT fpk_drug_era_concept FOREIGN KEY (drug_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY drug_era
    ADD CONSTRAINT fpk_drug_era_person FOREIGN KEY (person_id) REFERENCES person(person_id);



ALTER TABLE ONLY drug_exposure
    ADD CONSTRAINT fpk_drug_person FOREIGN KEY (person_id) REFERENCES person(person_id);



ALTER TABLE ONLY drug_exposure
    ADD CONSTRAINT fpk_drug_provider FOREIGN KEY (provider_id) REFERENCES provider(provider_id);



ALTER TABLE ONLY drug_exposure
    ADD CONSTRAINT fpk_drug_route_concept FOREIGN KEY (route_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY drug_strength
    ADD CONSTRAINT fpk_drug_strength_concept_1 FOREIGN KEY (drug_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY drug_strength
    ADD CONSTRAINT fpk_drug_strength_concept_2 FOREIGN KEY (ingredient_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY drug_strength
    ADD CONSTRAINT fpk_drug_strength_unit_1 FOREIGN KEY (amount_unit_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY drug_strength
    ADD CONSTRAINT fpk_drug_strength_unit_2 FOREIGN KEY (numerator_unit_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY drug_strength
    ADD CONSTRAINT fpk_drug_strength_unit_3 FOREIGN KEY (denominator_unit_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY drug_exposure
    ADD CONSTRAINT fpk_drug_type_concept FOREIGN KEY (drug_type_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY drug_exposure
    ADD CONSTRAINT fpk_drug_visit FOREIGN KEY (visit_occurrence_id) REFERENCES visit_occurrence(visit_occurrence_id);



ALTER TABLE ONLY fact_relationship
    ADD CONSTRAINT fpk_fact_domain_1 FOREIGN KEY (domain_concept_id_1) REFERENCES concept(concept_id);



ALTER TABLE ONLY fact_relationship
    ADD CONSTRAINT fpk_fact_domain_2 FOREIGN KEY (domain_concept_id_2) REFERENCES concept(concept_id);



ALTER TABLE ONLY fact_relationship
    ADD CONSTRAINT fpk_fact_relationship FOREIGN KEY (relationship_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY measurement
    ADD CONSTRAINT fpk_measurement_concept FOREIGN KEY (measurement_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY measurement
    ADD CONSTRAINT fpk_measurement_concept_s FOREIGN KEY (measurement_source_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY measurement
    ADD CONSTRAINT fpk_measurement_operator FOREIGN KEY (operator_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY measurement
    ADD CONSTRAINT fpk_measurement_person FOREIGN KEY (person_id) REFERENCES person(person_id);



ALTER TABLE ONLY measurement
    ADD CONSTRAINT fpk_measurement_provider FOREIGN KEY (provider_id) REFERENCES provider(provider_id);



ALTER TABLE ONLY measurement
    ADD CONSTRAINT fpk_measurement_type_concept FOREIGN KEY (measurement_type_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY measurement
    ADD CONSTRAINT fpk_measurement_unit FOREIGN KEY (unit_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY measurement
    ADD CONSTRAINT fpk_measurement_value FOREIGN KEY (value_as_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY measurement
    ADD CONSTRAINT fpk_measurement_visit FOREIGN KEY (visit_occurrence_id) REFERENCES visit_occurrence(visit_occurrence_id);



ALTER TABLE ONLY note
    ADD CONSTRAINT fpk_note_person FOREIGN KEY (person_id) REFERENCES person(person_id);



ALTER TABLE ONLY note
    ADD CONSTRAINT fpk_note_provider FOREIGN KEY (provider_id) REFERENCES provider(provider_id);



ALTER TABLE ONLY note
    ADD CONSTRAINT fpk_note_type_concept FOREIGN KEY (note_type_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY note
    ADD CONSTRAINT fpk_note_visit FOREIGN KEY (visit_occurrence_id) REFERENCES visit_occurrence(visit_occurrence_id);



ALTER TABLE ONLY observation
    ADD CONSTRAINT fpk_observation_concept FOREIGN KEY (observation_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY observation
    ADD CONSTRAINT fpk_observation_concept_s FOREIGN KEY (observation_source_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY observation_period
    ADD CONSTRAINT fpk_observation_period_concept FOREIGN KEY (period_type_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY observation_period
    ADD CONSTRAINT fpk_observation_period_person FOREIGN KEY (person_id) REFERENCES person(person_id);



ALTER TABLE ONLY observation
    ADD CONSTRAINT fpk_observation_person FOREIGN KEY (person_id) REFERENCES person(person_id);



ALTER TABLE ONLY observation
    ADD CONSTRAINT fpk_observation_provider FOREIGN KEY (provider_id) REFERENCES provider(provider_id);



ALTER TABLE ONLY observation
    ADD CONSTRAINT fpk_observation_qualifier FOREIGN KEY (qualifier_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY observation
    ADD CONSTRAINT fpk_observation_type_concept FOREIGN KEY (observation_type_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY observation
    ADD CONSTRAINT fpk_observation_unit FOREIGN KEY (unit_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY observation
    ADD CONSTRAINT fpk_observation_value FOREIGN KEY (value_as_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY observation
    ADD CONSTRAINT fpk_observation_visit FOREIGN KEY (visit_occurrence_id) REFERENCES visit_occurrence(visit_occurrence_id);



ALTER TABLE ONLY payer_plan_period
    ADD CONSTRAINT fpk_payer_plan_period FOREIGN KEY (person_id) REFERENCES person(person_id);



ALTER TABLE ONLY person
    ADD CONSTRAINT fpk_person_care_site FOREIGN KEY (care_site_id) REFERENCES care_site(care_site_id);



ALTER TABLE ONLY person
    ADD CONSTRAINT fpk_person_ethnicity_concept FOREIGN KEY (ethnicity_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY person
    ADD CONSTRAINT fpk_person_ethnicity_concept_s FOREIGN KEY (ethnicity_source_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY person
    ADD CONSTRAINT fpk_person_gender_concept FOREIGN KEY (gender_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY person
    ADD CONSTRAINT fpk_person_gender_concept_s FOREIGN KEY (gender_source_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY person
    ADD CONSTRAINT fpk_person_location FOREIGN KEY (location_id) REFERENCES location(location_id);



ALTER TABLE ONLY person
    ADD CONSTRAINT fpk_person_provider FOREIGN KEY (provider_id) REFERENCES provider(provider_id);



ALTER TABLE ONLY person
    ADD CONSTRAINT fpk_person_race_concept FOREIGN KEY (race_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY person
    ADD CONSTRAINT fpk_person_race_concept_s FOREIGN KEY (race_source_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY procedure_occurrence
    ADD CONSTRAINT fpk_procedure_concept FOREIGN KEY (procedure_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY procedure_occurrence
    ADD CONSTRAINT fpk_procedure_concept_s FOREIGN KEY (procedure_source_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY procedure_cost
    ADD CONSTRAINT fpk_procedure_cost_currency FOREIGN KEY (currency_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY procedure_cost
    ADD CONSTRAINT fpk_procedure_cost_id FOREIGN KEY (procedure_occurrence_id) REFERENCES procedure_occurrence(procedure_occurrence_id);



ALTER TABLE ONLY procedure_cost
    ADD CONSTRAINT fpk_procedure_cost_period FOREIGN KEY (payer_plan_period_id) REFERENCES payer_plan_period(payer_plan_period_id);



ALTER TABLE ONLY procedure_cost
    ADD CONSTRAINT fpk_procedure_cost_revenue FOREIGN KEY (revenue_code_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY procedure_occurrence
    ADD CONSTRAINT fpk_procedure_modifier FOREIGN KEY (modifier_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY procedure_occurrence
    ADD CONSTRAINT fpk_procedure_person FOREIGN KEY (person_id) REFERENCES person(person_id);



ALTER TABLE ONLY procedure_occurrence
    ADD CONSTRAINT fpk_procedure_provider FOREIGN KEY (provider_id) REFERENCES provider(provider_id);



ALTER TABLE ONLY procedure_occurrence
    ADD CONSTRAINT fpk_procedure_type_concept FOREIGN KEY (procedure_type_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY procedure_occurrence
    ADD CONSTRAINT fpk_procedure_visit FOREIGN KEY (visit_occurrence_id) REFERENCES visit_occurrence(visit_occurrence_id);



ALTER TABLE ONLY provider
    ADD CONSTRAINT fpk_provider_care_site FOREIGN KEY (care_site_id) REFERENCES care_site(care_site_id);



ALTER TABLE ONLY provider
    ADD CONSTRAINT fpk_provider_gender FOREIGN KEY (gender_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY provider
    ADD CONSTRAINT fpk_provider_gender_s FOREIGN KEY (gender_source_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY provider
    ADD CONSTRAINT fpk_provider_specialty FOREIGN KEY (specialty_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY provider
    ADD CONSTRAINT fpk_provider_specialty_s FOREIGN KEY (specialty_source_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY relationship
    ADD CONSTRAINT fpk_relationship_concept FOREIGN KEY (relationship_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY relationship
    ADD CONSTRAINT fpk_relationship_reverse FOREIGN KEY (reverse_relationship_id) REFERENCES relationship(relationship_id);



ALTER TABLE ONLY source_to_concept_map
    ADD CONSTRAINT fpk_source_to_concept_map_c_1 FOREIGN KEY (target_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY source_to_concept_map
    ADD CONSTRAINT fpk_source_to_concept_map_v_1 FOREIGN KEY (source_vocabulary_id) REFERENCES vocabulary(vocabulary_id);



ALTER TABLE ONLY source_to_concept_map
    ADD CONSTRAINT fpk_source_to_concept_map_v_2 FOREIGN KEY (target_vocabulary_id) REFERENCES vocabulary(vocabulary_id);



ALTER TABLE ONLY specimen
    ADD CONSTRAINT fpk_specimen_concept FOREIGN KEY (specimen_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY specimen
    ADD CONSTRAINT fpk_specimen_person FOREIGN KEY (person_id) REFERENCES person(person_id);



ALTER TABLE ONLY specimen
    ADD CONSTRAINT fpk_specimen_site_concept FOREIGN KEY (anatomic_site_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY specimen
    ADD CONSTRAINT fpk_specimen_status_concept FOREIGN KEY (disease_status_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY specimen
    ADD CONSTRAINT fpk_specimen_type_concept FOREIGN KEY (specimen_type_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY specimen
    ADD CONSTRAINT fpk_specimen_unit_concept FOREIGN KEY (unit_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY visit_occurrence
    ADD CONSTRAINT fpk_visit_care_site FOREIGN KEY (care_site_id) REFERENCES care_site(care_site_id);



ALTER TABLE ONLY visit_occurrence
    ADD CONSTRAINT fpk_visit_concept FOREIGN KEY (visit_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY visit_occurrence
    ADD CONSTRAINT fpk_visit_concept_s FOREIGN KEY (visit_source_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY visit_cost
    ADD CONSTRAINT fpk_visit_cost_currency FOREIGN KEY (currency_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY visit_cost
    ADD CONSTRAINT fpk_visit_cost_id FOREIGN KEY (visit_occurrence_id) REFERENCES visit_occurrence(visit_occurrence_id);



ALTER TABLE ONLY visit_cost
    ADD CONSTRAINT fpk_visit_cost_period FOREIGN KEY (payer_plan_period_id) REFERENCES payer_plan_period(payer_plan_period_id);



ALTER TABLE ONLY visit_occurrence
    ADD CONSTRAINT fpk_visit_person FOREIGN KEY (person_id) REFERENCES person(person_id);



ALTER TABLE ONLY visit_occurrence
    ADD CONSTRAINT fpk_visit_provider FOREIGN KEY (provider_id) REFERENCES provider(provider_id);



ALTER TABLE ONLY visit_occurrence
    ADD CONSTRAINT fpk_visit_type_concept FOREIGN KEY (visit_type_concept_id) REFERENCES concept(concept_id);



ALTER TABLE ONLY vocabulary
    ADD CONSTRAINT fpk_vocabulary_concept FOREIGN KEY (vocabulary_concept_id) REFERENCES concept(concept_id);



