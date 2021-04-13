using LazyArtifacts
using DataFrames
using SQLite

db = SQLite.DB(joinpath(artifact"synpuf-10p", "synpuf-10p.sqlite"));
res = DBInterface.execute(db, "SELECT * FROM person");
println(DataFrame(res))
