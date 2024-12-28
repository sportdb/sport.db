#################
#  to run use:
#    $ ruby sandbox/leagueinfos.rb


$LOAD_PATH.unshift( './lib' )
require 'football/timezones'


league_info = find_league_info( 'eng.1' )
pp league_info


pp league_name  = league_info[ :name ]    # note - returns proc if depending on season!!!
pp league_name.call( Season( '2024/25') )  
pp league_name.call( Season( '1889/90') )  
pp league_name.call( Season( '1972/73') )  


#######
league_info = find_league_info( 'at.2' )
pp league_info


pp league_name  = league_info[ :name ]   
pp league_name.call( Season( '2024/25') )    
pp league_name.call( Season( '1972/73') )  



pp find_league_info( 'xxx' )




puts "bye"
