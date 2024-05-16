$LOAD_PATH.unshift( File.expand_path( '../sportdb-models/lib' ))
require 'sportdb/models'



SportDb.open( './euro2024.db' )

puts "table stats:"
SportDb.tables



Match = SportDb::Model::Match


Match.order('date, time, pos').each_with_index do |m,i|
    puts "==> #{i}   #{m.team1.name} - #{m.team2.name}"
    pp m
end


puts "bye"

