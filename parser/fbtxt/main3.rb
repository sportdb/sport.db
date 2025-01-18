####
#  to run use:
#    $ ruby ./main3.rb  (in /fbtxt)



$LOAD_PATH.unshift( '../lib' )
require 'sportdb/parser'




txt = <<-TXT
################
#### more       
Rapid Wien   0-1  Austria Wien
Rapid Wien   0-2  Austria Wien    [awarded]

Rapid Wien v Austria Wien
Rapid Wien v Austria Wien 0-3   [awarded]
Rapid Wien v Austria Wien 0-4     @ Gerhard-Hanappi-Stadion, Wien
Rapid Wien v Austria Wien   [cancelled]   @ Gerhard-Hanappi-Stadion, Wien
Rapid Wien - Austria Wien    
Rapid Wien - Austria Wien 1-5   [awarded]
Rapid Wien - Austria Wien 1-6     @ Gerhard-Hanappi-Stadion, Wien
Rapid Wien - Austria Wien   [cancelled]   @ Gerhard-Hanappi-Stadion, Wien



### try "compact" match fixtures separated by comma 
Matchday 3
Rapid Wien v Austria Wien, Rapid Wien v Austria Wien


Matchday 4
Fr Sept/24
Rapid v Austria, GAK v Sturm, Wolfsbrug v Innsbruck
Fr Sept/24 Rapid v Austria, GAK v Sturm, Wolfsbrug v Innsbruck


Matchday 5
Fr Sept/24 18:00  Rapid - Austria,  GAK v Sturm,   Wolfsbrug v Innsbruck


## note -  continuation only works for fixtures (no match results!!!)
##              maybe allow results too (but no geo) - why? why not?
##  Sevilla 2-1 Bilbao,  Madrid v Barcelona    


###
#  try geo with timezone

 Denmark  0-0  France   @ Arena Amazônia, Manaus  
 Denmark  0-0  France   @ Arena Amazônia, Manaus (UTC-4)
 Denmark  0-0  France   @ Arena Amazônia (UTC-4)
 Denmark  0-0  France   @ Manaus (UTC-4)
 Denmark v France   @ Manaus (UTC-4)
 
TXT


###
# test tokenize
tok = SportDb::Tokenizer.new( txt )
pp tok.next_token
pp tok.next_token
pp tok.next_token
pp tok.next_token
pp tok.next_token
pp tok.next_token

puts "---"



  parser = RaccMatchParser.new( txt )
  tree = parser.parse
  pp tree



puts "bye"

