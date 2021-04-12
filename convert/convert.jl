# trivial conversion from PostgreSQL->SQLite

using LibPQ
using SQLite
using PostgresCatalog

#conn = LibPQ.Connection("postgresql:///synpuf-5pct?host=/var/run/postgresql")
conn = LibPQ.Connection("postgresql:///synpuf-10p?host=/var/run/postgresql")
db = SQLite.DB("synpuf-10p.sq3")

cat = PostgresCatalog.introspect(conn)

function visit(tbl)
    columns = String[]
    for col in tbl.columns
       if col.type.name in ("int4", "varchar", "int8", 
               "numeric", "text")
           push!(columns, col.name)
       elseif col.type.name in ("date",)
           push!(columns, "$(col.name)::TEXT")
       else
           throw("unknown type $(col.type.name)")
       end 
    end
    columns = join(columns, ",")
    res = execute(conn, "SELECT $columns FROM $(tbl.name)")
    SQLite.load!(res, db, tbl.name; analyze=false)
    SQLite.execute(db, "ANALYZE $(tbl.name);")
end

for tbl in cat["public"]
    println("tbl ", tbl.name)
    visit(tbl)
end
