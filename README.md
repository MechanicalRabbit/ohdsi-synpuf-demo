## SynPUF-HCFU

This is a PostgreSQL database dump of OHDSI Common Data Model
version 5.0 that is loaded with the bare minimum data to get
three cohort queries described in the BookOfOHDSI to work:

* 1770674: Acute myocardial infarction events
* 1770675: New users of ACE inhibitors as first-line monotherapy for hypertension
* 1770676: New users of Thiazide-like diuretics as first-line monotherapy for hypertension

It is based upon SynPUF data, including 10 patients which are
in the above cohorts according to the SQL file exported from 
the Atlas System. This dataset is far from complete, it only
includes what's necessary to get cohort hits. Since there are
only 10 patients, individual inserts are used in this file,
in this way hacking for other databases should be possible.

This file contains limited SNOMED and RxNorm codes, among
others. For SNOMED, it only includes codes for relevent 
conditions needed for the cohort definition, and the exact
descendent occuring in the SymPUF data. Since this is a very
tiny smattering of codes and since having a test database
for OHDSI is in the public interest, this seems "fair use".

## Releases

* 20190623 Minimal Release of 10 patients that match some
  cohort definitions found in The Book of OHDSI.

