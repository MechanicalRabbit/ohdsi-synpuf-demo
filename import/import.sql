\copy vocabulary FROM 'vocabulary.csv' WITH CSV HEADER
\copy relationship FROM 'relationship.csv' WITH CSV HEADER
\copy domain FROM 'domain.csv' WITH CSV HEADER
\copy concept_class FROM 'concept_class.csv' WITH CSV HEADER
\copy concept_ancestor FROM 'concept_ancestor.csv' WITH CSV HEADER
\copy concept_relationship FROM 'concept_relationship.csv' WITH CSV HEADER
\copy concept FROM 'concept.csv' WITH CSV HEADER
\copy location FROM 'location.csv' WITH CSV HEADER
\copy person FROM 'person.csv' WITH CSV HEADER
\copy observation_period FROM 'observation_period.csv' WITH CSV HEADER
\copy care_site FROM 'care_site.csv' WITH CSV HEADER
-- \copy visit_occurrence FROM 'visit_occurrence.csv' WITH CSV HEADER
\include cohort_definition.sql
