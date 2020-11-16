$LOAD_PATH.unshift( "./lib" )
require 'sportdb/setup'


SportDb::Boot.setup


puts
puts "SportDb::Boot.root: #{SportDb::Boot.root}"
puts "SPORTDB_DIR:        #{SportDb::Boot.root}/sportdb"
puts "OPENFOOTBALL_DIR:   #{SportDb::Boot.root}/openfootball"




