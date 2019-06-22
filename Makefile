test:
	dropdb --if-exists observational
	createdb observational
	psql -q -f ohdsi-cdm/create-database.sql observational
	psql -q -f ohdsi-cdm/create-results-tables.sql observational
	cd import && psql -f import.sql observational
	psql -q -f ohdsi-cdm/create-indexes.sql observational 
	psql -q -f ohdsi-cdm/create-constraints.sql observational
	psql -q -f ohdsi-cdm/create-results-indexes.sql observational


concepts:
	cd import && psql -f concepts.sql synpuf5
export:
	cd import && psql -f export.sql synpuf5
