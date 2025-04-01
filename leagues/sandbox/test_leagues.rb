###
##  to run use:
##    $ ruby sandbox/test_leagues.rb

$LOAD_PATH.unshift( './lib' )
require 'leagues'


### check for seasons

## champions league starting in 1992/93
pp LeagueCodes.valid?( 'uefa.cl' )

pp LeagueCodes.find_by( code: 'uefa.cl', season: '1991/92' )
pp LeagueCodes.find_by( code: 'uefa.cl', season: '1992/93' )
pp LeagueCodes.find_by( code: 'uefa.cl', season: '2024/25' )

pp LeagueCodes.valid?( 'euro.champs' )
puts
pp LeagueCodes.find_by( code: 'euro.champs', season: '1991/92' )
pp LeagueCodes.find_by( code: 'euro.champs', season: '2024/25' )

pp LeagueCodes.valid?( 'uefa.cup' )
puts


pp LeagueCodes.valid?( 'uefa.el' )
puts
pp LeagueCodes.find_by( code: 'uefa.el', season: '1992/93' )
pp LeagueCodes.find_by( code: 'uefa.el', season: '2008/09' )
pp LeagueCodes.find_by( code: 'uefa.el', season: '2009/10' )
pp LeagueCodes.find_by( code: 'uefa.el', season: '2024/25' )


pp LeagueCodes.valid?( 'eng.1' )
puts
pp LeagueCodes.find_by( code: 'eng.1', season: '1888/89' )
pp LeagueCodes.find_by( code: 'eng.1', season: '1990/91' )
pp LeagueCodes.find_by( code: 'eng.1', season: '1991/92' )
pp LeagueCodes.find_by( code: 'eng.1', season: '1992/93' )
pp LeagueCodes.find_by( code: 'eng.1', season: '2024/25' )

pp LeagueCodes.valid?( 'eng.2' )
puts
pp LeagueCodes.find_by( code: 'eng.2', season: '1990/91' )
pp LeagueCodes.find_by( code: 'eng.2', season: '1992/93' )
pp LeagueCodes.find_by( code: 'eng.2', season: '2024/25' )



puts "bye"