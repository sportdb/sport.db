## minitest setup
require 'minitest/autorun'


## our own code
##  note: use the local version of fifa gem
$LOAD_PATH.unshift( File.expand_path( '../sport.db/sportdb-structs/lib'))
$LOAD_PATH.unshift( File.expand_path( './lib'))
require 'fifa'
