### note: make sure to load latest sportdb/structs !!!  (allow key with numbers!)
$LOAD_PATH.unshift( File.expand_path( '../sportdb-structs/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-catalogs/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-formats/lib' ))
$LOAD_PATH.unshift( File.expand_path( './lib' ))  ## sportdb-indexers


require 'sportdb/indexers'


## set catalog db (required for world search api)
SportDb::Import.config.catalog_path = './catalog.db'
SportDb::Import.config.players_path = './players.db'


## note: avoid conflict with "generic"/top-level PersonDb for now
CatalogDb::PersonDb.open( './players.db' )

path = "../../../openfootball/players/europe/players.up.txt"
recs  =  SportDb::Import::PlayerUpdateReader.read( path )

pp recs

CatalogDb::PlayerUpdateIndexer.add( recs )


puts "bye"
