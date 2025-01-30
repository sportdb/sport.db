####
#  to run use:
#    $ ruby ./main4.rb  (in /fbtxt)



$LOAD_PATH.unshift( '../lib' )
require 'sportdb/parser'




txt = <<-TXT

###
#  try alternate iso-date format

2011-08-25  Los Angeles Galaxy  2-0  Alajuelense
2011-08-25  Monarcas Morelia    4-0  Motagua

###
#  try standalone weekday names

Matchday 17
Fr Rapid v Austria
Sa Sturm v LASK

Matchday 18
Fri 18:00  Rapid v Austria
Sat 15:00  Sturm v LASK

Fr 18h00  Rapid v Austria
Sa 15h00  Sturm v LASK


###
#  try date with geo

Semi-finals
Tue Jul/9 21:00  @ München Fußball Arena, München  
    Spain  v  France   2-1 (2-1)    

Wed Jul/10 21:00  @ BVB Stadion Dortmund, Dortmund 
    Netherlands  v  England   1-2 (1-1)      


Final
Sun Jul/14 21:00   @ Olympiastadion, Berlin
    Spain  v   England    2-1 (0-0)        

    
Jul 9  @ München
    Spain  v  France   2-1 (2-1)    

Jul 10  @ Dortmund 
    Netherlands  v  England   1-2 (1-1)      

Final
Sun Jul 14   @ Olympiastadion
    Spain  v   England    2-1 (0-0)        



###
#  try matchday/round with group combo

Matchday 1 / Group A    #  August 16-18, 2011

Matchday 2 / Group A    #  August 23-25, 2011

Matchday 3 / Group A    #  September 13-15, 2011

# -- check with comma-separated

Matchday 1, Group A    #  August 16-18, 2011

Matchday 2, Group A    #  August 23-25, 2011

Matchday 3, Group A    #  September 13-15, 2011


## check with more than one round name
Semifinal - 1st Leg,  Group A    
Semifinal - 2nd Leg,  Group A


TXT



  parser = RaccMatchParser.new( txt, debug: true )
  tree, errors = parser.parse_with_errors
  pp tree

  if errors.size > 0
     puts "!! #{errors.size} parse error(s):"
     pp errors
  end


puts "bye"

