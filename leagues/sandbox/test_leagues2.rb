###
##  to run use:
##    $ ruby sandbox/test_leagues2.rb

$LOAD_PATH.unshift( './lib' )
require 'leagues'


### check for seasons

## champions league starting in 1992/93
pp LeagueCodes.valid?( 'uefa.cl' )   # return true|false
puts "- by season:"
pp LeagueCodes.find_by( code: 'uefa.cl', season: '1991/92' )
pp LeagueCodes.find_by( code: 'uefa.cl', season: '1992/93' ) 
pp LeagueCodes.find_by( code: 'uefa.cl', season: '2024/25' ) 


## check different spelling
puts "---"
pp LeagueCodes.valid?( 'uefa cl' )
pp LeagueCodes.valid?( 'UEFA CL' )


## check alt codes
puts "---"
pp LeagueCodes.valid?( 'euro.champs' )
pp LeagueCodes.valid?( 'EURO CHAMPS' )


puts
puts "==> eng.1"
pp LeagueCodes.valid?( 'eng.1' )
pp LeagueCodes.find_by( code: 'eng.1', season: '2024/25' ) 
pp LeagueCodes.find_by( code: 'eng.1', season: '1990/91' ) 

puts
puts "==> at.2"
pp LeagueCodes.valid?( 'at.2' )
pp LeagueCodes.find_by( code: 'at.2', season: '2010/11' ) 
pp LeagueCodes.find_by( code: 'at.2', season: '2024/25' ) 

puts
puts "==> at.1"
pp LeagueCodes.valid?( 'AUT BL' )
pp LeagueCodes.find_by( code: 'AUT BL', season: '2024/25' ) 


puts "bye"