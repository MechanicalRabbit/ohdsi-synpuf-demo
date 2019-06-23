build:
	dropdb --if-exists synpuf-10p
	createdb synpuf-10p
	psql -q -f ohdsi-cdm/create-database.sql synpuf-10p
	cd import && psql -f import.sql synpuf-10p
	psql -q -f ohdsi-cdm/create-indexes.sql synpuf-10p 
	psql -q -f ohdsi-cdm/create-constraints.sql synpuf-10p


# these are unnecessary unless updating import files
concepts:
	cd export && psql -f concepts.sql synpuf5
exports:
	cd export && psql -f export.sql synpuf5
