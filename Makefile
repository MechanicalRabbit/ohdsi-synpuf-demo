# This file is used to build the database snapshot, synpuf-10p.sql,
# assuming there is a "synpuf" database. It also is used to run
# DataKnots queries to replicate chorts in the Book Of OHDSI.

test:
	PGHOST=/var/run/postgresql PGDATABASE=synpuf-10p \
		   julia -e "using NarrativeTest; runtests()"

shell:
	cd cohorts && PGHOST=/var/run/postgresql PGDATABASE=synpuf-10p \
		julia -L copybook.jl

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
