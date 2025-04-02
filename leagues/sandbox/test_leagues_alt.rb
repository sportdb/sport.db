###
##  to run use:
##    $ ruby sandbox/test_leagues_alt.rb

$LOAD_PATH.unshift( './lib' )
require 'leagues'


puts
puts "==> at.1"
pp LeagueCodes.valid?( 'AUT BL' )
pp LeagueCodes.valid?( 'AT 1' )
pp LeagueCodes.valid?( 'Ö 1' )
pp LeagueCodes.find_by( code: 'AUT BL', season: '2024/25' ) 
pp LeagueCodes.find_by( code: 'AT 1', season: '2024/25' ) 
pp LeagueCodes.find_by( code: 'Ö 1', season: '2024/25' ) 

puts
puts "==> ch.1"
pp LeagueCodes.valid?( 'SUI SL' )
pp LeagueCodes.find_by( code: 'SUI SL', season: '2024/25' ) 


###
## check mls (us.1) - season format is 2024, 2025, etc.
puts
puts "==> mls"
pp LeagueCodes.valid?( 'MLS' )
pp LeagueCodes.valid?( 'US 1' )
pp LeagueCodes.find_by( code: 'MLS', season: '2024' ) 

puts "bye"