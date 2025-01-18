####
#  to run use:
#    $ ruby sandbox/test_lang.rb


$LOAD_PATH.unshift( './lib' )
require 'sportdb/parser'


parser = SportDb::Parser.new

puts "group:"
pp parser.is_group?( 'Group' )      #=> false!!!!!!!!!!!!!!
pp parser.is_group?( 'Group A' )
pp parser.is_group?( 'Group HEX' )
pp parser.is_group?( 'Group 1' )

puts
puts "round:"
pp parser.is_round?( 'Round' )     #=>  false!!!!!!!!!!!
pp parser.is_round?( 'Round 11' )
pp parser.is_round?( 'Matchday 1' )
pp parser.is_round?( 'Week 1' )

pp parser.is_round?( 'Play-offs for quarter-finals' )
pp parser.is_round?( 'Playoffs for quarterfinals' )

pp parser.is_round?( 'Round of 16' )
pp parser.is_round?( 'Finals' )
pp parser.is_round?( 'Final' )

pp parser.is_round?( 'Match for 5th place' )
pp parser.is_round?( '5th place final' )
pp parser.is_round?( '3rd place match' )
pp parser.is_round?( '3rd place final' )
pp parser.is_round?( 'Third place play-off' )

pp parser.is_round?( 'Last 32' )
pp parser.is_round?( 'Last 16' )
pp parser.is_round?( 'Last 8' )
pp parser.is_round?( 'Last 4' )
pp parser.is_round?( 'Quarters' )
pp parser.is_round?( 'Quarter-finals' )
pp parser.is_round?( 'Quarterfinal' )

puts "---"

names = [
  'Play-off Round',
  'Playoff Round',
  '1. Round',
  '2. Round',
  '3. Round',

 'Preliminary Semifinals',
 'Preliminary Semi-finals',
 'Preliminary Final',
 'Qual. Round 1',
 'Qual. Round 2',
 'Qual. Round 3',

 'Final Replay',

 ###
 # more
 'First semifinal',
 'Second semifinal',
 'Conference Semifinals',
 'Conference Finals',
 'Wildcard',


#####
### try more languages
  'Entscheidung Zone B',
  '1. Aufstieg',
  '1. Aufstieg Zone A',
  '1. Aufstieg Zone B',
  '2. Aufstieg Zone A',
  '2. Aufstieg Zone B',
  '2. Aufstieg 1. Phase',
  '2. Aufstieg 2. Phase',
  '2. Aufstieg 3. Phase',
  'Direkter Aufstieg',
  'Direkter Abstieg',
  'Zwischenrunde Gr. B',   ## move to group  why? why not?
  '5. Platz',


].each do |name|
    pp parser.is_round?( name )
end






puts
puts "legs:"
pp parser.is_leg?( '1st leg' )
pp parser.is_leg?( '2nd leg' )
pp parser.is_leg?( 'Second leg' )




puts "bye"