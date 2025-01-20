####
#  to run use:
#    $ ruby sandbox/test_tokenize.rb


$LOAD_PATH.unshift( './lib' )
require 'sportdb/parser'



txt = <<TXT

Group A  |    Germany   Scotland     Hungary   Switzerland
Group B  |  Spain     Croatia      Italy     Albania
Group C  |  Slovenia  Denmark      Serbia    England
Group D  |  Poland    Netherlands  Austria   France
Group E  |  Belgium   Slovakia     Romania   Ukraine 
Group F  |  Turkey    Georgia      Portugal  Czech Republic



Matchday 1  |  Fri Jun/14 - Tue Jun/18   
Matchday 2  |   Wed Jun/19 - Sat Jun/22   
Matchday 3  |  Sun Jun/23 - Wed Jun/26

##
## add (inline) stage definitions 
##  why? why not?
##
## Quali         |
## Group Phase   |
## Finals        | 
##
## or (one line?)
##  Stage(s)  |  Quali    Group Phase     Finals


## add (inline)
## shortcuts
##  e.g.
##  Frankfurt  =>   Waldstadion, Frankfurt

##  or (inline)
##   venue defintion ???
##   e.g.
##  @ Frankfurt  |   @ Waldstadion 
##
##   Rapid Wien (AUT)  |   @ Hanappi Stadion, Wien
##
##   Kansas City, Kentucky  |  @ Rock Cafe Arena    44 400   (UTC-4)  ## num for capacity
##                                or use 44 000 cap. or such ? 
##   Kansas City, Kentucky (UTC-4)   |  @ Rock Cafe Arena  (44_400)     ## num for capacity
##   Kansas City, Kentucky (UTC-4)   |  @ Rock Cafe Arena,  (44_400)     ## num for capacity


Group A
Fri Jun/14
 (1)  21:00   Germany   5-1 (3-0)  Scotland     @ München
                Wirtz 10' Musiala 19' Havertz 45+1' (pen.)  Füllkrug 68' Can 90+3';  
                Rüdiger 87' (o.g.)
Sat Jun/15
 (2)  15.00    Hungary   1-3 (0-2)   Switzerland  @ Köln
                 Varga 66'; 
                 Duah 12' Aebischer 45' Embolo 90+3'


Semi-finals
Tu July/9 2024

(50)  21h00    Netherlands  1-2 (1-1)   England    @ Dortmund
                  Simons 7'; Kane 18' (pen.) Watkins 90+1'

Final
Sunday Jul 14 2024
(51)   21.00   Spain  -  England         @ Berlin   

TXT

puts txt
puts


parser = SportDb::Parser.new

tokens = parser.tokenize( txt )
pp tokens

puts "bye"