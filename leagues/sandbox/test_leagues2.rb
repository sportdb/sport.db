###
##  to run use:
##    $ ruby sandbox/test_leagues2.rb

$LOAD_PATH.unshift( './lib' )
require 'leagues'


### check for seasons

## champions league starting in 1992/93
league = find_league_info( 'uefa.cl' )
pp league

puts "- by season:"
pp league.find_by_season( Season( '1991/92') )
pp league.find_by_season( Season( '1992/93') )
pp league.find_by_season( Season( '2024/25') )


## check different spelling
puts "---"
league = find_league_info( 'uefa cl' )
pp league

league = find_league_info( 'UEFA CL' )
pp league

## check alt codes
puts "---"
league = find_league_info( 'euro.champs' )
pp league

league = find_league_info( 'EURO CHAMPS' )
pp league



puts
puts "==> eng.1"
league = find_league_info( 'eng.1' )
pp league

puts
puts "==> at.2"
league = find_league_info( 'at.2' )
pp league


puts "bye"