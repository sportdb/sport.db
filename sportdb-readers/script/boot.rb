## note: use the local version of sportdb gems
$LOAD_PATH.unshift( File.expand_path( '../sportdb-structs/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-catalogs/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-search/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-formats/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-models/lib' ))

$LOAD_PATH.unshift( File.expand_path( '../parser/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../quick/lib' ))


## our own code
$LOAD_PATH.unshift( './lib' )
require 'sportdb/readers'


## use (switch to) "external" datasets
SportDb::Import.config.catalog_path = "../catalog/catalog.db"

## print/dump stats
CatalogDb::Metal.tables


OPENFOOTBALL_PATH = '../../../openfootball'

