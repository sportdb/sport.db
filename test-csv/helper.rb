## note: use the local version of gems
$LOAD_PATH.unshift( File.expand_path( '../date-formats/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-langs/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-formats/lib' ))


## minitest setup
require 'minitest/autorun'


## our own code
require 'sportdb/formats'

