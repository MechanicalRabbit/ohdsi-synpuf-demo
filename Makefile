build:
	dropdb --if-exists observational
	createdb observational
	psql -q -f ohdsi-cdm/create-database.sql observational
	cd import && psql -f import.sql observational
	psql -q -f ohdsi-cdm/create-indexes.sql observational 
	psql -q -f ohdsi-cdm/create-constraints.sql observational


# these are unnecessary unless updating import files
concepts:
	cd export && psql -f concepts.sql synpuf5
exports:
	cd export && psql -f export.sql synpuf5
