# Build Catalog (Built-In) DBs - Leagues, Clubs, & More


##  catalog.db  (built-in "all-in-one" default)

in `/catalog` type/run:

   $ ruby ./build.rb

resulting in

   $ ./catalog.db 

note: requires
- `openfootball/leagues`
- `openfootball/clubs`


### bonus: how to package-up catalog.db for footballdb-data gem

change to `/football.db.data`

copy `catalog.db` to `/football.db.data/data`

check if file exits via

     $ ruby sandbox/query.rb

update gem version and publish e.g.

     $ rake check_manifest
     $ rake release VERSION=2025.1.3









