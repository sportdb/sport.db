$LOAD_PATH.unshift( './lib' )
require 'sportdb/search'


EventInfo = Sports::EventInfo


pp EventInfo.find_by( league: 'AT 1', season: '2011/12' )
pp EventInfo.find_by( league: 'AT 1', season: '2028/29' )

pp EventInfo.find_by( league: 'ES 1', season: '2012/13' )

# pp EventInfo.seasons( 'AT 1' )
# pp EventInfo.seasons( 'ES 1' )


puts "bye"