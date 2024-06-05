### note: make sure to load latest sportdb/structs !!!  (allow key with numbers!)
$LOAD_PATH.unshift( File.expand_path( '../sportdb-structs/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-catalogs/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-formats/lib' ))
$LOAD_PATH.unshift( File.expand_path( './lib' ))



require 'sportdb/indexers'


## set catalog db (required for world search api)
SportDb::Import.config.catalog_path = './catalog.db'


COUNTRIES = SportDb::Import.world.countries

pp COUNTRIES.find_by_code( 'a' )
pp COUNTRIES.find_by_code( 'at' )




CatalogDb::LeagueDb.open( './leagues.db' )
CatalogDb::LeagueIndexer.read( '../../../openfootball/leagues' )


## change EventIndexer to LeagueSeason(s)Indexer  - why? why not?
# CatalogDb::EventIndexer.read( '../../../openfootball/leagues' )


puts "bye"

