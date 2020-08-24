## note: use the local version of sportdb gems
$LOAD_PATH.unshift( File.expand_path( '../date-formats/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../score-formats/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-langs/lib' ))


## minitest setup
require 'minitest/autorun'


## our own code
require 'sportdb/structs'

