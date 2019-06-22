\copy vocabulary FROM 'vocabulary.csv' WITH CSV HEADER;
\copy relationship FROM 'relationship.csv' WITH CSV HEADER;
\copy domain FROM 'domain.csv' WITH CSV HEADER;
\copy concept_class FROM 'concept_class.csv' WITH CSV HEADER;
\copy concept_ancestor FROM 'concept_ancestor.csv' WITH CSV HEADER;
\copy concept_relationship FROM 'concept_relationship.csv' WITH CSV HEADER;
\copy concept FROM 'concept.csv' WITH CSV HEADER;
\include cohort_definition.sql
