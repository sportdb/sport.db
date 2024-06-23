## note: use the local version of sportdb gems
$LOAD_PATH.unshift( File.expand_path( '../sportdb-structs/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-formats/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-catalogs/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-models/lib' ))
$LOAD_PATH.unshift( './lib' )


## minitest setup
require 'minitest/autorun'


## our own code
require 'sportdb/sync'


## use (switch to) "external" dbs - why? why not?
# SportDb::Import.config.catalog_path = "../catalog/catalog.db"


COUNTRIES = SportDb::Import.world.countries
LEAGUES   = SportDb::Import.catalog.leagues
CLUBS     = SportDb::Import.catalog.clubs


SportDb.open_mem
## turn on logging to console
## ActiveRecord::Base.logger = Logger.new(STDOUT)



