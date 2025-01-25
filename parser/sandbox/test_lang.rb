####
#  to run use:
#    $ ruby sandbox/test_lang.rb


$LOAD_PATH.unshift( './lib' )
require 'sportdb/parser'


lexer = SportDb::Lexer.new( '' )

puts "group:"
pp lexer.is_group?( 'Group' )      #=> false!!!!!!!!!!!!!!
pp lexer.is_group?( 'Group A' )
pp lexer.is_group?( 'Group HEX' )
pp lexer.is_group?( 'Group 1' )

puts
puts "round:"
pp lexer.is_round?( 'Round' )     #=>  false!!!!!!!!!!!
pp lexer.is_round?( 'Round 11' )
pp lexer.is_round?( 'Matchday 1' )
pp lexer.is_round?( 'Week 1' )

pp lexer.is_round?( 'Play-offs for quarter-finals' )
pp lexer.is_round?( 'Playoffs for quarterfinals' )

pp lexer.is_round?( 'Round of 16' )
pp lexer.is_round?( 'Finals' )
pp lexer.is_round?( 'Final' )

pp lexer.is_round?( 'Match for 5th place' )
pp lexer.is_round?( '5th place final' )
pp lexer.is_round?( '3rd place match' )
pp lexer.is_round?( '3rd place final' )
pp lexer.is_round?( 'Third place play-off' )

pp lexer.is_round?( 'Last 32' )
pp lexer.is_round?( 'Last 16' )
pp lexer.is_round?( 'Last 8' )
pp lexer.is_round?( 'Last 4' )
pp lexer.is_round?( 'Quarters' )
pp lexer.is_round?( 'Quarter-finals' )
pp lexer.is_round?( 'Quarterfinal' )

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
    pp lexer.is_round?( name )
end






puts
puts "legs:"
pp lexer.is_leg?( '1st leg' )
pp lexer.is_leg?( '2nd leg' )
pp lexer.is_leg?( 'Second leg' )




puts "bye"