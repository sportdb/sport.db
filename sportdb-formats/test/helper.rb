## note: use the local version of gems
$LOAD_PATH.unshift( File.expand_path( '../date-formats/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../score-formats/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-langs/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-structs/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-catalogs/lib' ))



## minitest setup
require 'minitest/autorun'


## our own code
require 'sportdb/formats'

###########
## add sport catalogs  -  todo - rework dependencies/dependency graph
##                        update for sportdb/catalog update 
##                              sportdb/catalogs NO longer requires sportdb/formats for now

require 'sportdb/catalogs'

SportDb::Import.config.catalog_path = '../catalog/testcatalog.db'




