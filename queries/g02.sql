SELECT
  c.concept_id,
  c.concept_name,
  c.concept_code,
  c.concept_class_id,
  c.vocabulary_id
FROM concept AS c
WHERE 
  c.concept_code = '38341003' AND
  c.vocabulary_id = 'SNOMED' AND
  c.invalid_reason IS NULL
;
