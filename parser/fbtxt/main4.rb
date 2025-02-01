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

2011-8-3   Los Angeles Galaxy  2-0  Alajuelense
2011-8-25   Monarcas Morelia    4-0  Motagua


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

Matchday 1, Group A    
Matchday 2, Group A    
Matchday 3, Group A    



## check with more than one round name
Semifinal - 1st Leg,  Group A    
Semifinal - 2nd Leg,  Group A



#####
#  try date durations
Matchday 1  |  August 16-18, 2011       
Matchday 2  |  September 13-15, 2011
Matchday 3  |  October 18-20, 2011
Matchday 4  |  March/6-8, 2012
Matchday 5  |  March 6-8 2012
Matchday 6  |  March 6-8 

Matchday 7   |  July 31-August 2, 2012
Matchday 8   |  July 31-August 2 2012
Matchday 9   |  July 31-August 2
Matchday 10  |  Sun Jun 23 - Wed Jun 26, 2020
Matchday 11  |  Dec 11, 2024 - Jan 10, 2025
Matchday 12  |  Dec/11 2024-Jan/10 2025



##
#  try team listing

##
##  for (list/div/sec) level marker use?  -/--/--- or >/>>/>>> or ~/~~/~~~
##               or        */**/*** or ???
##               or     |/||/|||
##   or  1)2)3)/a)b)c)/ etc.

Teams 
- North America         # 9 teams
-- Mexico (MEX)            #   4 teams
     tigres
     santos
     chivas
     monterrey
-- United States (USA)   #  4 teams
     galaxy
     seattle
     houston
     saltlake
-- Canada (CAN)          # 1
     toronto
- Central America    # 12 teams
-- El Salvador       #    3 teams
     metapan
     aguila
     fas
-- Costa Rica        # 2 teams
     alajuelense
     herediano
-- Honduras          # 2 teams
     olimpia
     marathon
-- Guatemala     # 2 teams
     municipal
     xelaju
-- Panama    # 2 teams
     chorrillo
     tauro
-- Nicaragua   # 1 team
     esteli
- Caribbean    # 2 teams
-- Trinidad and Tobago   # 2 team
     caledonia
     wconnection
-- Puerto Rico    # 1 team
      puertorico




######
#  try alternate goal format
  Austria - Rapid  3-1
   1-0 Player 4'  2-0 Player 45+1' (pen.)  2-1 Player 50'  3-1 Player 55' (o.g.) 


TXT



  parser = RaccMatchParser.new( txt, debug: true )
  tree, errors = parser.parse_with_errors
  pp tree

  if errors.size > 0
     puts "!! #{errors.size} parse error(s):"
     pp errors
  end


puts "bye"

