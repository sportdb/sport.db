## note: use the local version of sportdb gems
$LOAD_PATH.unshift( File.expand_path( '../parser/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-structs/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-formats/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-catalogs/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-models/lib' ))
$LOAD_PATH.unshift( './lib' )



## minitest setup
require 'minitest/autorun'


## our own code
require 'sportdb/readers'

## use (switch to) "external" datasets
SportDb::Import.config.catalog_path = "../catalog/catalog.db"

## print/dump stats
CatalogDb::Metal.tables



COUNTRIES = SportDb::Import.world.countries
LEAGUES   = SportDb::Import.catalog.leagues
CLUBS     = SportDb::Import.catalog.clubs
