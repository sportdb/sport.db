### note: make sure to load latest sportdb/structs !!!  (allow key with numbers!)
$LOAD_PATH.unshift( File.expand_path( '../sportdb-structs/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-catalogs/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-formats/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../catalog/lib' ))  ## sportdb-indexers
$LOAD_PATH.unshift( File.expand_path( './lib' ))



require 'players'


## set catalog db (required for world search api)
SportDb::Import.config.catalog_path = '../catalog/catalog.db'


## note: avoid conflict with "generic"/top-level PersonDb for now
CatalogDb::PersonDb.open( './players.db' )

CatalogDb::PlayerIndexer.read( '../../../openfootball/players' )


puts "bye"
