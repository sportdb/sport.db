$LOAD_PATH.unshift( './lib' )
require 'sportdb/search'


League    = Sports::League
Team      = Sports::Team
EventInfo = Sports::EventInfo


pp m = League.match_by( code: 'at.1' )
at1 = m[0]
pp m = League.match_by( code: 'eng.1' )
eng1 = m[0]


pp Team.find_by!( name: 'Rapid Wien', league: at1 )
pp Team.find_by!( name: 'Austria Wien II', league: at1 )

pp Team.find_by!( name: 'Arsenal', league: eng1 )


pp EventInfo.find_by( league: 'AT 1', season: '2011/12' )
pp EventInfo.find_by( league: 'AT 1', season: '2028/29' )

pp EventInfo.find_by( league: 'ES 1', season: '2012/13' )


puts "bye"