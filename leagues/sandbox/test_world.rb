###
##  to run use:
##    $ ruby sandbox/test_world.rb


$LOAD_PATH.unshift( './lib' )
require 'leagues'


world2022tz = find_zone!( league: 'world', season: '2022' )
world2018tz = find_zone!( league: 'world', season: '2018' )

pp world2022tz
pp world2018tz
pp world2022tz == world2018tz


world2018 = LeagueCodes.find_by( code: 'world', season: '2018' )
world2022 = LeagueCodes.find_by( code: 'world', season: '2022' )

pp world2022
pp world2018
pp world2022['tz'] != world2018['tz']


puts "bye"

