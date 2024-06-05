### note: make sure to load latest sportdb/structs !!!  (allow key with numbers!)
$LOAD_PATH.unshift( File.expand_path( '../sportdb-structs/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-catalogs/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-formats/lib' ))
$LOAD_PATH.unshift( File.expand_path( './lib' ))



require 'sportdb/indexers'


## do NOT use world.db records/references for city
##        use "vanilla" strings!!!
CatalogDb.config.city = false   
pp CatalogDb.config.city?


## set catalog db (required for world search api)
SportDb::Import.config.catalog_path = './catalog.db'


COUNTRIES = SportDb::Import.world.countries

pp COUNTRIES.find_by_code( 'a' )
pp COUNTRIES.find_by_code( 'at' )



CatalogDb::ClubDb.open( './clubs.db' )

#  note: grounds before clubs (clubs may reference grounds!!)
CatalogDb::GroundIndexer.read( '../../../openfootball/clubs' )


CatalogDb::ClubIndexer.read( '../../../openfootball/clubs' )



puts "bye"

