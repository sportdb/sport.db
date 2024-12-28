###
##  to run use:
##    $ ruby sandbox/test_leagues.rb

$LOAD_PATH.unshift( '../../../sportdb/sport.db/parser/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-structs/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/quick/lib' )
$LOAD_PATH.unshift( './lib' )
require 'sportdb/writers'


### check for seasons

## champions league starting in 1992/93
league = Writer::LEAGUES[ 'uefa.cl' ]
pp league

pp league.find_by_season( Season( '1991/92') )
pp league.find_by_season( Season( '1992/93') )
pp league.find_by_season( Season( '2024/25') )

league = Writer::LEAGUES[ 'euro.champs' ]
puts
pp league
pp league.find_by_season( Season( '1991/92') )
pp league.find_by_season( Season( '2024/25') )

league = Writer::LEAGUES[ 'uefa.cup' ]
puts
pp league


league = Writer::LEAGUES[ 'uefa.el' ]
puts
pp league
pp league.find_by_season( Season( '1992/93') )
pp league.find_by_season( Season( '2008/09') )
pp league.find_by_season( Season( '2009/10') )
pp league.find_by_season( Season( '2024/25') )


league = Writer::LEAGUES[ 'eng.1' ]
puts
pp league
pp league.find_by_season( Season( '1888/89') )
pp league.find_by_season( Season( '1990/91') )
pp league.find_by_season( Season( '1991/92') )
pp league.find_by_season( Season( '1992/93') )
pp league.find_by_season( Season( '2024/25') )

league = Writer::LEAGUES[ 'eng.2' ]
puts
pp league
pp league.find_by_season( Season( '1990/91') )
pp league.find_by_season( Season( '1992/93') )
pp league.find_by_season( Season( '2024/25') )



puts "bye"