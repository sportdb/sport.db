### note: make sure to load latest sportdb/structs !!!  (allow key with numbers!)
$LOAD_PATH.unshift( File.expand_path( '../sportdb-structs/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-catalogs/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-formats/lib' ))
$LOAD_PATH.unshift( File.expand_path( './lib' ))



require 'sportdb/indexers'


## set catalog db (required for world search api)
SportDb::Import.config.catalog_path = './catalog.db'

## dump table stats and test country lookup
CatalogDb::Metal.tables

Country = Sports::Country

pp Country.find_by( code: 'a' )
pp Country.find_by( code: 'at' )



if File.exist?( './leagues.db' )
    File.delete( './leagues.db' )
    sleep( 2 )  ## wait 2 secs before reopen file
end


CatalogDb::LeagueDb.open( './leagues.db' )
CatalogDb::LeagueIndexer.read( '../../../openfootball/leagues' )


## change EventIndexer to LeagueSeason(s)Indexer  - why? why not?
# CatalogDb::EventIndexer.read( '../../../openfootball/leagues' )


puts "bye"

