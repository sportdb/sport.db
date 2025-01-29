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


Sevilla 2-1 Bilbao,  Madrid v Barcelona    
Sevilla v Bilbao 2-1,  Madrid v Barcelona
Sevilla - Bilbao 2-1,  Madrid - Barcelona 1-5 (0-2), Elche - Getafe   



###
#  try geo with timezone

 Denmark  0-0  France   @ Arena Amazônia, Manaus  
 Denmark  0-0  France   @ Arena Amazônia, Manaus (UTC-4)
 Denmark  0-0  France   @ Arena Amazônia (UTC-4)
 Denmark  0-0  France   @ Manaus (UTC-4)
 Denmark v France   @ Manaus (UTC-4)
 

###
#   check big free-standing V in text e.g.

Rivière du Rempart  2-3  Petite Rivière Noire    @  New George V Stadium, Curepipe
 
Final
[Sun Jul/19]
  Petite Rivière Noire  2-0  Pamplemousses    @ New George V Stadium, Curepipe

  Petite Rivière Noire v Pamplemousses    @ New George V Stadium, Curepipe
  Petite Rivière Noire vs Pamplemousses    @ New George V Stadium, Curepipe

###
#  more round names from australia
Elimination finals
[Fri May/3]
  Melbourne Victory         3-1  Wellington Phoenix
[Sun May/5]
  Adelaide United           1-0 a.e.t.  Melbourne City FC

Semi-finals
[Fri May/10]
  Perth Glory              5-4 pen. 3-3 a.e.t.  Adelaide United
[Sun May/12]
  Sydney FC                 6-1  Melbourne Victory

Grand Final
[Sun May/19]
  Perth Glory              1-4 pen. 0-0 a.e.t.  Sydney FC

TXT



  parser = RaccMatchParser.new( txt )
  tree, errors = parser.parse_with_errors
  pp tree

  if errors.size > 0
     puts "!! #{errors.size} parse error(s):"
     pp errors
  end


puts "bye"

