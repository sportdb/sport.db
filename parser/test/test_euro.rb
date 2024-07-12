###
#  to run use
#     ruby test/test_euro.rb


require_relative 'helper'

class TestEuro < Minitest::Test

def test_tokenize

euro =<<TXT
Group A  |  Germany   Scotland     Hungary   Switzerland
Group B  |  Spain     Croatia      Italy     Albania
Group C  |  Slovenia  Denmark      Serbia    England
Group D  |  Poland    Netherlands  Austria   France
Group E  |  Belgium   Slovakia     Romania   Ukraine 
Group F  |  Turkey    Georgia      Portugal  Czech Republic



## list venues (define "shortcuts") - why? why not?
##   for city or club ?
München       |  @ München Fußball Arena
Stuttgart     |  @ Stuttgart Arena
Frankfurt     |  @ Waldstadion
Köln          |  @ Köln Stadion
Düsseldorf    |  @ Düsseldorf Arena
Dortmund      |  @ BVB Stadion Dortmund 
Gelsenkirchen |  @ Arena Auf Schalke
Leipzig       |  @ Leipzig Stadion
Hamburg       |  @ Volksparkstadion
Berlin        |  @ Olympiastadion 


##  use/drop  @  - why? why not?
München  @ München Fußball Arena


Matchday 1 | Fri Jun/14 - Tue Jun/18   
Matchday 2 | Wed Jun/19 - Sat Jun/22   
Matchday 3 | Sun Jun/23 - Wed Jun/26



Group A

Fri Jun/14
 (1)  21:00   Germany   5-1 (3-0)  Scotland     @ München
                Wirtz 10' Musiala 19' Havertz 45+1' (pen.)  Füllkrug 68' Can 90+3';  
                Rüdiger 87' (o.g.)
Sat Jun/15
 (2)  15:00    Hungary   1-3 (0-2)   Switzerland  @ Köln
                 Varga 66'; 
                 Duah 12' Aebischer 45' Embolo 90+3'

Wed Jun/19                 
(14)  18:00    Germany   2-0 (1-0)   Hungary      @ Stuttgart 
                 Musiala 22' Gündoğan 67'
(13)  21:00    Scotland  1-1 (1-1)   Switzerland  @ Köln
                  McTominay 13'; Shaqiri 26'

Sun Jun/23
(25)  21:00    Switzerland 1-1 (1-0) Germany       @ Frankfurt
                  Ndoye 29'; Füllkrug 90+2'
(26)  21:00    Scotland     0-1 (0-0) Hungary       @ Stuttgart
                   -; Csoboth 90+10'


Group B

Sat Jun/15
 (3)  18:00   Spain   3-0 (3-0)    Croatia    @ Berlin
                Morata 29' Fabián 32' Carvajal 45+2'
 (4)  21:00   Italy   2-1 (2-1)   Albania    @ Dortmund
                Bastoni 11' Barella 16'; Bajrami 1'

Wed Jun/19                
(15)  15:00   Croatia   2-2 (0-1)   Albania    @ Hamburg
                Kramarić 74' Gjasula 76' (o.g.); 
                Laçi 11' Gjasula 90+5'
Thu Jun/20
(16)  21:00    Spain   1-0 (0-0)   Italy      @ Gelsenkirchen
                 Calafiori 55' (o.g.)

Mon Jun/24                 
(27)  21:00     Albania   0-1 (0-1)   Spain      @ Düsseldorf
                  -; Torres 13'
(28)            Croatia   1-1 (0-0)   Italy      @ Leipzig
                   Modrić 55'; Zaccagni 90+8'


Group C

Sun Jun/16        
(6) 18:00   Slovenia   1-1 (0-1)   Denmark    @ Stuttgart   
               Janža 77'; Eriksen 17'
(5) 21:00   Serbia   0-1 (0-1)   England      @ Gelsenkirchen
               -; Bellingham 13'

Thu Jun/20               
(18)  15:00   Slovenia   1-1 (0-0)   Serbia     @ München
                Karničnik 69'; Jović 90+5'
(17)  18:00    Denmark   1-1 (1-1)   England    @ Frankfurt
                 Hjulmand 34'; Kane 18'

Tue Jun/25                 
(29)  21:00        England   0-0   Slovenia    @ Köln
(30)               Denmark   0-0   Serbia      @ München


## ...


Quarter-finals
Fri Jul/5
(45)  18:00   Spain        2-1 (0-0) Germany        @ Stuttgart
                Olmo 51' Merino 119'; Wirtz 89'
(46)  21:00   Portugal    3-5 pen. 0-0 a.e.t. (0-0)  France    @ Hamburg

Sat Jul/6
(48)  18:00   England      5-3 pen. 1-1 a.e.t. (1-1, 0-0)  Switzerland    @ Düsseldorf
                Saka 80'; Embolo 75'
(47)  21:00   Netherlands  2-1 (0-1)  Turkey         @ Berlin
                Vrij 70' Müldür 76' (o.g.); Akaydin 35'


Semi-finals
Tue Jul/9
(49)  21:00    Spain  2-1 (2-1)  France           @ München 
                 Yamal 21' Olmo 25'; Kolo Muani 8'
Wed Jul/10
(50)  21:00    Netherlands  1-2 (1-1)   England    @ Dortmund
                  Simons 7'; Kane 18' (pen.) Watkins 90+1'

Final
Sun Jul/14
(51)   21:00   Spain  -  England         @ Berlin   

TXT

lines = euro.split( "\n" )
pp lines

tokens = []
lines.each_with_index do |line,i|
  puts
  puts "line #{i+1}/#{lines.size}  >#{line}<"
  ## skip blank or comment lines
  next if line.strip.empty? || line.strip.start_with?( '#' )
  t = tokenize( line )
  pp t
  tokens << t
end

pp tokens

exp =  [
  [[:text, "Group A"], [:|], [:text, "Germany"], [:text, "Scotland"], [:text, "Hungary"], [:text, "Switzerland"]],
  [[:text, "Group B"], [:|], [:text, "Spain"], [:text, "Croatia"], [:text, "Italy"], [:text, "Albania"]],
  [[:text, "Group C"], [:|], [:text, "Slovenia"], [:text, "Denmark"], [:text, "Serbia"], [:text, "England"]],
  [[:text, "Group D"], [:|], [:text, "Poland"], [:text, "Netherlands"], [:text, "Austria"], [:text, "France"]],
  [[:text, "Group E"], [:|], [:text, "Belgium"], [:text, "Slovakia"], [:text, "Romania"], [:text, "Ukraine"]],
  [[:text, "Group F"], [:|], [:text, "Turkey"], [:text, "Georgia"], [:text, "Portugal"], [:text, "Czech Republic"]],

  [[:text, "München"], [:|], [:"@"], [:text, "München Fußball Arena"]],
  [[:text, "Stuttgart"], [:|], [:"@"], [:text, "Stuttgart Arena"]],
  [[:text, "Frankfurt"], [:|], [:"@"], [:text, "Waldstadion"]],
  [[:text, "Köln"], [:|], [:"@"], [:text, "Köln Stadion"]],
  [[:text, "Düsseldorf"], [:|], [:"@"], [:text, "Düsseldorf Arena"]],
  [[:text, "Dortmund"], [:|], [:"@"], [:text, "BVB Stadion Dortmund"]],
  [[:text, "Gelsenkirchen"], [:|], [:"@"], [:text, "Arena Auf Schalke"]],
  [[:text, "Leipzig"], [:|], [:"@"], [:text, "Leipzig Stadion"]],
  [[:text, "Hamburg"], [:|], [:"@"], [:text, "Volksparkstadion"]],
  [[:text, "Berlin"], [:|], [:"@"], [:text, "Olympiastadion"]],
  [[:text, "München"], [:"@"], [:text, "München Fußball Arena"]],

  [[:text, "Matchday 1"], [:|], [:duration, "Fri Jun/14 - Tue Jun/18"]],
  [[:text, "Matchday 2"], [:|], [:duration, "Wed Jun/19 - Sat Jun/22"]],
  [[:text, "Matchday 3"], [:|], [:duration, "Sun Jun/23 - Wed Jun/26"]],

  [[:text, "Group A"]],
  [[:date, "Fri Jun/14"]],
  [[:num, "(1)"],[:time, "21:00"],
   [:text, "Germany"],[:score, "5-1 (3-0)"],[:text, "Scotland"],
   [:"@"],[:text, "München"]],
  [[:text, "Wirtz"],[:minute, "10'"],
   [:text, "Musiala"],[:minute, "19'"],
   [:text, "Havertz"],[:minute, "45+1'"],[:pen, "(pen.)"],
   [:text, "Füllkrug"],[:minute, "68'"],
   [:text, "Can"],[:minute, "90+3'"],
   [:";"]],
  [[:text, "Rüdiger"], [:minute, "87'"], [:og, "(o.g.)"]],
  [[:date, "Sat Jun/15"]],
  [[:num, "(2)"],[:time, "15:00"],
   [:text, "Hungary"],[:score, "1-3 (0-2)"],[:text, "Switzerland"],
   [:"@"],[:text, "Köln"]],
  [[:text, "Varga"], [:minute, "66'"], [:";"]],
  [[:text, "Duah"], [:minute, "12'"], 
  [:text, "Aebischer"], [:minute, "45'"], 
  [:text, "Embolo"], [:minute, "90+3'"]],
  [[:date, "Wed Jun/19"]],
  [[:num, "(14)"],[:time, "18:00"],
   [:text, "Germany"],[:score, "2-0 (1-0)"],[:text, "Hungary"],
   [:"@"],[:text, "Stuttgart"]],
  [[:text, "Musiala"], [:minute, "22'"], 
  [:text, "Gündoğan"], [:minute, "67'"]],
  [[:num, "(13)"],[:time, "21:00"],
   [:text, "Scotland"],[:score, "1-1 (1-1)"],[:text, "Switzerland"],
   [:"@"],[:text, "Köln"]],
  [[:text, "McTominay"], [:minute, "13'"], [:";"], [:text, "Shaqiri"], [:minute, "26'"]],
  [[:date, "Sun Jun/23"]],
  [[:num, "(25)"],
   [:time, "21:00"],
   [:text, "Switzerland"],
   [:score, "1-1 (1-0)"],
   [:text, "Germany"],
   [:"@"],
   [:text, "Frankfurt"]],
  [[:text, "Ndoye"], [:minute, "29'"], [:";"], 
   [:text, "Füllkrug"], [:minute, "90+2'"]],
  [[:num, "(26)"],
   [:time, "21:00"],
   [:text, "Scotland"],
   [:score, "0-1 (0-0)"],
   [:text, "Hungary"],
   [:"@"],
   [:text, "Stuttgart"]],
  [[:none, "-"], [:";"], [:text, "Csoboth"], [:minute, "90+10'"]],
 
  [[:text, "Group B"]],
  [[:date, "Sat Jun/15"]],
  [[:num, "(3)"],
   [:time, "18:00"],
   [:text, "Spain"],
   [:score, "3-0 (3-0)"],
   [:text, "Croatia"],
   [:"@"],
   [:text, "Berlin"]],
  [[:text, "Morata"], [:minute, "29'"], [:text, "Fabián"], [:minute, "32'"], [:text, "Carvajal"], [:minute, "45+2'"]],
  [[:num, "(4)"],
   [:time, "21:00"],
   [:text, "Italy"],
   [:score, "2-1 (2-1)"],
   [:text, "Albania"],
   [:"@"],
   [:text, "Dortmund"]],
  [[:text, "Bastoni"],[:minute, "11'"],
   [:text, "Barella"],[:minute, "16'"],
   [:";"],
   [:text, "Bajrami"],[:minute, "1'"]],
  [[:date, "Wed Jun/19"]],
  [[:num, "(15)"],
   [:time, "15:00"],
   [:text, "Croatia"],
   [:score, "2-2 (0-1)"],
   [:text, "Albania"],
   [:"@"],
   [:text, "Hamburg"]],
  [[:text, "Kramarić"], [:minute, "74'"], [:text, "Gjasula"], [:minute, "76'"], [:og, "(o.g.)"], [:";"]],
  [[:text, "Laçi"], [:minute, "11'"], [:text, "Gjasula"], [:minute, "90+5'"]],
  [[:date, "Thu Jun/20"]],
  [[:num, "(16)"],
   [:time, "21:00"],
   [:text, "Spain"],
   [:score, "1-0 (0-0)"],
   [:text, "Italy"],
   [:"@"],
   [:text, "Gelsenkirchen"]],
  [[:text, "Calafiori"], [:minute, "55'"], [:og, "(o.g.)"]],
  [[:date, "Mon Jun/24"]],
  [[:num, "(27)"],
   [:time, "21:00"],
   [:text, "Albania"],
   [:score, "0-1 (0-1)"],
   [:text, "Spain"],
   [:"@"],
   [:text, "Düsseldorf"]],
  [[:none, "-"], [:";"], [:text, "Torres"], [:minute, "13'"]],
  [[:num, "(28)"], [:text, "Croatia"], [:score, "1-1 (0-0)"], [:text, "Italy"], [:"@"], [:text, "Leipzig"]],
  [[:text, "Modrić"], [:minute, "55'"], [:";"], [:text, "Zaccagni"], [:minute, "90+8'"]],
 
  [[:text, "Group C"]],
  [[:date, "Sun Jun/16"]],
  [[:num, "(6)"],
   [:time, "18:00"],
   [:text, "Slovenia"],
   [:score, "1-1 (0-1)"],
   [:text, "Denmark"],
   [:"@"],
   [:text, "Stuttgart"]],
  [[:text, "Janža"], [:minute, "77'"], [:";"], [:text, "Eriksen"], [:minute, "17'"]],
  [[:num, "(5)"],
   [:time, "21:00"],
   [:text, "Serbia"],
   [:score, "0-1 (0-1)"],
   [:text, "England"],
   [:"@"],
   [:text, "Gelsenkirchen"]],
  [[:none, "-"], [:";"], [:text, "Bellingham"], [:minute, "13'"]],
  [[:date, "Thu Jun/20"]],
  [[:num, "(18)"],
   [:time, "15:00"],
   [:text, "Slovenia"],
   [:score, "1-1 (0-0)"],
   [:text, "Serbia"],
   [:"@"],
   [:text, "München"]],
  [[:text, "Karničnik"], [:minute, "69'"], [:";"], [:text, "Jović"], [:minute, "90+5'"]],
  [[:num, "(17)"],
   [:time, "18:00"],
   [:text, "Denmark"],
   [:score, "1-1 (1-1)"],
   [:text, "England"],
   [:"@"],
   [:text, "Frankfurt"]],
  [[:text, "Hjulmand"], [:minute, "34'"], [:";"], [:text, "Kane"], [:minute, "18'"]],
  [[:date, "Tue Jun/25"]],
  [[:num, "(29)"], [:time, "21:00"], 
    [:text, "England"], [:score, "0-0"], [:text, "Slovenia"], 
    [:"@"], [:text, "Köln"]],
  [[:num, "(30)"], 
   [:text, "Denmark"], [:score, "0-0"], [:text, "Serbia"], 
   [:"@"], [:text, "München"]],

  [[:text, "Quarter-finals"]],
  [[:date, "Fri Jul/5"]],
  [[:num, "(45)"],[:time, "18:00"],
   [:text, "Spain"],[:score, "2-1 (0-0)"],[:text, "Germany"],
   [:"@"],[:text, "Stuttgart"]],
  [[:text, "Olmo"], [:minute, "51'"], 
   [:text, "Merino"], [:minute, "119'"], 
   [:";"], 
   [:text, "Wirtz"], [:minute, "89'"]],
  [[:num, "(46)"],
   [:time, "21:00"],
   [:text, "Portugal"],
   [:score, "3-5 pen. 0-0 a.e.t. (0-0)"],
   [:text, "France"],
   [:"@"],
   [:text, "Hamburg"]],
  [[:date, "Sat Jul/6"]],
  [[:num, "(48)"],
   [:time, "18:00"],
   [:text, "England"],
   [:score, "5-3 pen. 1-1 a.e.t. (1-1, 0-0)"],
   [:text, "Switzerland"],
   [:"@"],
   [:text, "Düsseldorf"]],
  [[:text, "Saka"], [:minute, "80'"], 
    [:";"], 
    [:text, "Embolo"], [:minute, "75'"]],
  [[:num, "(47)"],
   [:time, "21:00"],
   [:text, "Netherlands"],
   [:score, "2-1 (0-1)"],
   [:text, "Turkey"],
   [:"@"],
   [:text, "Berlin"]],
  [[:text, "Vrij"],
   [:minute, "70'"],
   [:text, "Müldür"],
   [:minute, "76'"],
   [:og, "(o.g.)"],
   [:";"],
   [:text, "Akaydin"],
   [:minute, "35'"]],

  [[:text, "Semi-finals"]],
  [[:date, "Tue Jul/9"]],
  [[:num, "(49)"],
   [:time, "21:00"],
   [:text, "Spain"],
   [:score, "2-1 (2-1)"],
   [:text, "France"],
   [:"@"],
   [:text, "München"]],
  [[:text, "Yamal"],
   [:minute, "21'"],
   [:text, "Olmo"],
   [:minute, "25'"],
   [:";"],
   [:text, "Kolo Muani"],
   [:minute, "8'"]],
  [[:date, "Wed Jul/10"]],
  [[:num, "(50)"],
   [:time, "21:00"],
   [:text, "Netherlands"],
   [:score, "1-2 (1-1)"],
   [:text, "England"],
   [:"@"],
   [:text, "Dortmund"]],
  [[:text, "Simons"],[:minute, "7'"],
   [:";"],
   [:text, "Kane"],[:minute, "18'"],[:pen, "(pen.)"],
   [:text, "Watkins"],[:minute, "90+1'"]],

  [[:text, "Final"]],
  [[:date, "Sun Jul/14"]],
  [[:num, "(51)"], [:time, "21:00"], 
    [:text, "Spain"], [:vs, "-"], [:text, "England"], 
    [:"@"], [:text, "Berlin"]]
]

  assert_equal exp, tokens
end
end # class TestEuro