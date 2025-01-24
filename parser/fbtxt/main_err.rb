####
#  to run use:
#    $ ruby ./main_err.rb  (in /fbtxt)


## try error handling


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


Sevilla 2-1 Bilbao,  Madrid v Barcelona    
Sevilla v Bilbao 2-1,  Madrid v Barcelona
Sevilla - Bilbao 2-1,  Madrid - Barcelona 1-5 (0-2), Elche - Getafe   



###
#  try geo with timezone

## add errors here
   : : :  some text here     ## gets handled by tokenizer!!!
11-12
13-14

## another line here
   ! ! !  more text here   ## gets handled by tokenizer!!!
15-17

 Denmark  0-0  France   @ Arena Amazônia, Manaus  
 Denmark  1-1  France   @ Arena Amazônia, Manaus (UTC-4)
 
## more here
   $$$     ## gets handled by tokenizer!!!
20-21
 

 Denmark  2-2  France   @ Arena Amazônia (UTC-4)
 Denmark  3-3  France   @ Manaus (UTC-4)

## try more errors
 @  Bamberg, Oberfranken, Bayern

 Denmark v France   @ Manaus (UTC-4)

TXT



  parser = RaccMatchParser.new( txt )
  tree, errors = parser.parse_with_errors
  puts "-- tree:"
  pp tree
  puts "-- errors:"
  pp errors


if parser.errors?
  puts "-- #{parser.errors.size} parse error(s)"
  pp parser.errors
else
  puts "--  OK - no parse errors found"
end

puts "bye"

