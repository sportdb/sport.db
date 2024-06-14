### note: make sure to load latest sportdb/structs !!!  (allow key with numbers!)
$LOAD_PATH.unshift( File.expand_path( '../sportdb-structs/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-catalogs/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-formats/lib' ))
$LOAD_PATH.unshift( File.expand_path( './lib' ))

require 'sportdb/indexers'


## set catalog db (required for world search api)
SportDb::Import.config.catalog_path = './catalog.db'


path = "../../../openfootball/players/europe/players.up.txt"
recs  =  SportDb::Import::PlayerUpdateReader.read( path )

pp recs


puts "bye"

