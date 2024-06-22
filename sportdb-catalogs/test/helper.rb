## minitest setup
require 'minitest/autorun'

## our own code
$LOAD_PATH.unshift( File.expand_path( '../sportdb-structs/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-formats/lib' ))
$LOAD_PATH.unshift( File.expand_path( './lib' ))

require 'sportdb/catalogs'



## SportDb::Import.config.catalog_path = '../catalog/catalog.db'


