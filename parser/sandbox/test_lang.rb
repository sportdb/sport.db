####
#  to run use:
#    $ ruby sandbox/test_lang.rb


$LOAD_PATH.unshift( './lib' )
require 'sportdb/parser'


puts "group:"
pp Names.is_group?( 'Group' )
pp Names.is_group?( 'Group A' )
pp Names.is_group?( 'Group HEX' )
pp Names.is_group?( 'Group 1' )

puts
puts "round:"
pp Names.is_round?( 'Round' )
pp Names.is_round?( 'Round 11' )
pp Names.is_round?( 'Matchday 1' )
pp Names.is_round?( 'Week 1' )

pp Names.is_round?( 'Play-offs for quarter-finals' )
pp Names.is_round?( 'Playoffs for quarterfinals' )

pp Names.is_round?( 'Round of 16' )
pp Names.is_round?( 'Finals' )
pp Names.is_round?( 'Final' )

pp Names.is_round?( 'Match for 5th place' )
pp Names.is_round?( '5th place final' )
pp Names.is_round?( '3rd place match' )
pp Names.is_round?( '3rd place final' )
pp Names.is_round?( 'Third place play-off' )

pp Names.is_round?( 'Last 32' )
pp Names.is_round?( 'Last 16' )
pp Names.is_round?( 'Last 8' )
pp Names.is_round?( 'Last 4' )
pp Names.is_round?( 'Quarters' )
pp Names.is_round?( 'Quarter-finals' )
pp Names.is_round?( 'Quarterfinal' )

puts
puts "legs:"
pp Names.is_leg?( '1st leg' )
pp Names.is_leg?( '2nd leg' )
pp Names.is_leg?( 'Second leg' )




puts "bye"