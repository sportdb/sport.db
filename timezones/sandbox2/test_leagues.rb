###
##  to run use:
##    $ ruby sandbox2/test_leagues.rb

$LOAD_PATH.unshift( './lib' )
require 'football/timezones'


### check for seasons

## champions league starting in 1992/93
league = find_league_info( 'uefa.cl' )
pp league

pp league.find_by_season( Season( '1991/92') )
pp league.find_by_season( Season( '1992/93') )
pp league.find_by_season( Season( '2024/25') )

league = find_league_info( 'euro.champs' )
puts
pp league
pp league.find_by_season( Season( '1991/92') )
pp league.find_by_season( Season( '2024/25') )

league = find_league_info( 'uefa.cup' )
puts
pp league


league = find_league_info( 'uefa.el' )
puts
pp league
pp league.find_by_season( Season( '1992/93') )
pp league.find_by_season( Season( '2008/09') )
pp league.find_by_season( Season( '2009/10') )
pp league.find_by_season( Season( '2024/25') )


league = find_league_info( 'eng.1' )
puts
pp league
pp league.find_by_season( Season( '1888/89') )
pp league.find_by_season( Season( '1990/91') )
pp league.find_by_season( Season( '1991/92') )
pp league.find_by_season( Season( '1992/93') )
pp league.find_by_season( Season( '2024/25') )

league = find_league_info( 'eng.2' )
puts
pp league
pp league.find_by_season( Season( '1990/91') )
pp league.find_by_season( Season( '1992/93') )
pp league.find_by_season( Season( '2024/25') )



puts "bye"