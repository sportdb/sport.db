## note: use the local version of sportdb gems

# todo/fix: use SPORTDB_DIR or such (for reuse) in boot!!!!!!!!

$LOAD_PATH.unshift( '../sportdb-structs/lib' )
$LOAD_PATH.unshift( './lib' )

## minitest setup
require 'minitest/autorun'


## our own code
require 'sportdb/writers'

