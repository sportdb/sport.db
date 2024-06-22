$LOAD_PATH.unshift( File.expand_path( './lib' ))
require "footballdb-data"


puts FootballDb::Data.root
puts FootballDb::Data.data_dir

path = "#{FootballDb::Data.data_dir}/catalog.db"
pp File.exist?( path )

puts "bye"