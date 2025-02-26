####
#  to run use:
#    $ ruby ./main.rb  (in /fbtxt)



$LOAD_PATH.unshift( '../lib' )
require 'sportdb/parser'



txt = <<-TXT

Oct 7 
Austria  1-2  Rapid 


Oct 7   Austria  1-2  Rapid 

Oct 11
Sturm   0-0  LASK  
Mauerbach v Spittelau

[Oct 22]
PSV - Ajax


Oct 22 12:00   PSV - Ajax

(8)  Oct 22 12:00   PSV - Ajax



##########################
#### more part i

Group A  |    Germany   Scotland     Hungary   Switzerland
Group B  |  Spain     Croatia      Italy     Albania
Group C  |  Slovenia  Denmark      Serbia    England
Group D  |  Poland    Netherlands  Austria   France
Group E  |  Belgium   Slovakia     Romania   Ukraine 
Group F  |  Turkey    Georgia      Portugal  Czech Republic


Matchday 1  |  Fri Jun/14 - Tue Jun/18   
Matchday 2  |   Wed Jun/19 - Sat Jun/22   
Matchday 3  |  Sun Jun/23 - Wed Jun/26



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



##########################
#### more part ii


[Tue Feb/13]
  20.45  Juventus             2-2  Tottenham Hotspur    @ Juventus Stadium, Turin
           [Higuaín 2', 9' (pen.); Kane 35' Eriksen 71']
  20.45  Basel                0-4  Manchester City      @ St. Jakob-Park, Basel
           [-; Gündoğan 14', 53' B. Silva 18' Agüero 23']

Wed Feb/14
  20.45  Porto                0-5  Liverpool            @ Estádio do Dragão, Porto
           -; Mané 25', 53', 85' Salah 29' Firmino 69'
  20.45  Real Madrid          3-1  Paris Saint-Germain  @ Santiago Bernabéu, Madrid
           Ronaldo 45' (pen.), 83' Marcelo 86'; Rabiot 33'

[Tue Feb/20]
  20.45  Bayern München       5-0  Beşiktaş             @ Allianz Arena, München
           [Müller 43', 66' Coman 53' Lewandowski 79', 88']
  20.45  Chelsea              1-1  Barcelona            @ Stamford Bridge, London
           [Willian 62'; Messi 75']

[Wed Feb/21]
  20.45  Shakhtar Donetsk     2-1  Roma                 @ Metalist Stadium, Kharkiv
           [Ferreyra 52' Fred 71'; Ünder 41']
  20.45  Sevilla              0-0  Manchester United    @ Ramón Sánchez Pizjuán, Seville


Round of 16 - 2nd Leg

[Tue Mar/6]
  20.45  Liverpool            0-0  Porto                @ Anfield, Liverpool
  20.45  Paris Saint-Germain  1-2  Real Madrid          @ Parc des Princes, Paris
           [Cavani 71'; Ronaldo 51' Casemiro 80']

[Wed Mar/7]
  20.45  Manchester City      1-2  Basel                @ City of Manchester Stadium, Manchester
           [Gabriel Jesus 8'; Elyounoussi 17' Lang 71']
  20.45  Tottenham Hotspur    1-2  Juventus             @ Wembley Stadium, London
           [Son Heung-min 39'; Higuaín 64' Dybala 67']

[Tue Mar/13]
  20.45  Roma                 1-0  Shakhtar Donetsk     @ Stadio Olimpico, Rome
           [Džeko 52']
  20.45  Manchester United    1-2  Sevilla              @ Old Trafford, Manchester
           [Lukaku 84'; Ben Yedder 74', 78']

[Wed Mar/14]
  20.45  Barcelona            3-0  Chelsea              @ Camp Nou, Barcelona
           [Messi 3', 63' Dembélé 20']
  18.00  Beşiktaş             1-3  Bayern München       @ Vodafone Park, Istanbul
           [Vágner Love 59'; 
            Thiago 18' Gönül 46' (o.g.) Wagner 84']


Quarter-finals - 1st Leg

[Tue Apr/3]
  20.45  Juventus             0-3  Real Madrid          @ Juventus Stadium, Turin
           [-; Ronaldo 3', 64' Marcelo 72']
  20.45  Sevilla              1-2  Bayern München       @ Ramón Sánchez Pizjuán, Seville
           [Sarabia 31'; Navas 37' (o.g.) Thiago 68']

[Wed Apr/4]
  20.45  Barcelona            4-1  Roma                 @ Camp Nou, Barcelona
           [De Rossi 38' (o.g.) Manolas 55' (o.g.) Piqué 59' L. Suárez 87'; Džeko 80']
  20.45  Liverpool            3-0  Manchester City      @ Anfield, Liverpool
           [Salah 12' Oxlade-Chamberlain 21' Mané 31']


Quarter-finals - 2nd Leg

[Tue Apr/10]
  20.45  Roma                 3-0  Barcelona            @ Stadio Olimpico, Rome
           [Džeko 6' De Rossi 58' (pen.) Manolas 82']
  20.45  Manchester City      1-2  Liverpool            @ City of Manchester Stadium, Manchester
           [Gabriel Jesus 2'; Salah 56' Firmino 77']

[Wed Apr/11]
  20.45  Real Madrid          1-3  Juventus             @ Santiago Bernabéu, Madrid
           [Ronaldo 90+8' (pen.); 
             Mandžukić 2', 37' Matuidi 61']
  20.45  Bayern München       0-0  Sevilla              @ Allianz Arena, München



Semi-finals, 1st Leg
Semi-finals - 1st Leg

[Tue Apr/24]
  20.45  Liverpool            5-2  Roma                 @ Anfield, Liverpool
           [Salah 36', 45+1' Mané 56' Firmino 61', 69'; 
             Džeko 81' Perotti 85' (pen.)]

[Wed Apr/25]
  20.45  Bayern München       1-2  Real Madrid          @ Allianz Arena, München
           [Kimmich 28';  Marcelo 44' Asensio 57']


Semi-finals - 2nd Leg
Semi-finals, 2nd Leg


[Tue May/1]
  20.45  Real Madrid          2-2  Bayern München       @ Santiago Bernabéu, Madrid
           [Benzema 11', 46'; Kimmich 3' Rodríguez 63']

[Wed May/2]
  20.45  Roma                 4-2  Liverpool            @ Stadio Olimpico, Rome
           [Milner 15' (o.g.) Džeko 52' Nainggolan 86', 90+4' (pen.); Mané 9' Wijnaldum 25']

Final

[Sat May/26]
  20.45  Real Madrid          3-1  Liverpool            @ NSC Olimpiyskiy Stadium, Kiev
           [Benzema 51' Bale 64', 83'; Mané 55']


(29) Sat Jun/23 15:00          Belgium   5-2 (3-1)   Tunisia    @ Spartak Stadium, Moscow (UTC+3)
  [Batshuayi 90']
  [R. Lukaku 16' Batshuayi 90']          
  [R. Lukaku 45+3' Batshuayi 90']          
  [R. Lukaku 16', 45+3' Batshuayi 90']          
  [R. Lukaku 16' 45+3' Batshuayi 90']          
  [E. Hazard 6' (pen.), 51' R. Lukaku 16', 45+3' Batshuayi 90'; Bronn 18' Khazri 90+3']
  [E. Hazard 6' (pen.) 51' R. Lukaku 16' 45+3' Batshuayi 90'; Bronn 18' Khazri 90+3']

  ### todo/fix
  ##    add/allow optional commas between players - why? why not? 
#  [R. Lukaku 16', Batshuayi 90']          
#  [R. Lukaku 16', 45+3', Batshuayi 90']  
#  [E. Hazard 6' (pen.), 51', R. Lukaku 16', 45+3', Batshuayi 90'; 
#    Bronn 18', Khazri 90+3']
        

TXT


  parser = RaccMatchParser.new( txt, debug: true )
  tree = parser.parse
  pp tree

  if parser.errors?
    puts "-- #{parser.errors.size} parse error(s):"
    pp parser.errors
  else
    puts "--  OK - no parse errors found"
  end
  


puts "bye"