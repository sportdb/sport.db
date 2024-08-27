## minitest setup
require 'minitest/autorun'


$LOAD_PATH.unshift( '../sportdb-structs/lib' )
$LOAD_PATH.unshift( '../parser/lib' )
$LOAD_PATH.unshift( './lib' )

## our own code
require  'sportdb/quick'


