###
#  to run use
#     ruby test/test_misc.rb


require_relative 'helper'


class TestMisc < Minitest::Test

  def test_misc
 txt =<<TXT
        Athletic Club (Bilbao)
        USC Paloma (Hamburg)
        1/8 Finals
        1/16 Finals

[aet, 9-8 pen]
[aet, 5-3 pen]
[aet, 6-5 pen]
[aet]


Wiener Neustadt abd Grödig           [abandoned at 1-0 in 20' due to fog]
Wiener Neustadt 2-4 Grödig           [replay]


[Matheus Ferraz 45'+1', Lins 46', João Vítor 82'; Diones 72']
[Rafael Sóbis 15'p, Samuel 53'; Manoel 28']
[Diego Souza 5', Bruno Rodrigo 30', Nílton 40',79', Borges 42']
[Deivid 53', Arthur 90'+1'; Diego Tardelli 51']
[Fernandes 75', Caio 90'+4'; Araújo 79'p]
[Jô 48']
[Araújo 16', Lúcio 32', Derley 82'; Márcio Azevedo 48', Cesinha 59'og]
[Márcio 38'p, Felipe 58', Joílson 82'; Caio 23'p,62'p]
[Fred 48'p,74'p, Thiago Neves 65', Wallace 87']

[Matheus Ferraz 45+1, Lins 46, João Vítor 82; Diones 72]
[Rafael Sóbis 15p, Samuel 53; Manoel 28]
[Diego Souza 5, Bruno Rodrigo 30, Nílton 40,79, Borges 42]
[Deivid 53, Arthur 90+1; Diego Tardelli 51]
[Fernandes 75, Caio 90+4; Araújo 79p]
[Jô 48]
[Araújo 16, Lúcio 32, Derley 82; Márcio Azevedo 48, Cesinha 59og]
[Márcio 38p, Felipe 58, Joílson 82; Caio 23p,62p]
[Fred 48p,74p, Thiago Neves 65, Wallace 87]

[Matheus Ferraz 45+1 Lins 46 João Vítor 82; Diones 72]
[Rafael Sóbis 15p Samuel 53; Manoel 28]
[Diego Souza 5 Bruno Rodrigo 30 Nílton 40,79 Borges 42]
[Deivid 53 Arthur 90+1; Diego Tardelli 51]
[Fernandes 75 Caio 90+4; Araújo 79p]
[Jô 48]
[Araújo 16 Lúcio 32 Derley 82; Márcio Azevedo 48 Cesinha 59og]
[Márcio 38p Felipe 58 Joílson 82; Caio 23p,62p]
[Fred 48p,74p Thiago Neves 65 Wallace 87]

# possible  90+  | 90+og | 90+pen  
[Jaime Gavilán 4, 90+, Adrián Colunga 10, Angel Arizmendi 90+og;
   Rafa Jordá 13]

[Cristiano Ronaldo 30, 62, 90+pen]

## special player names  - e.g. with - or ' or ???
[Quincy Owusu-abeyie 35
 Sergio González N'Sue 37]



Cruzeiro         -  Internacional   
Grêmio           -  Criciúma        
Atlético/MG      -  Grêmio          
Internacional    -  Juventude  
Kashima Antlers         -  Sagan Tosu 
Tokyo Verdy             -  Sanfrecce Hiroshima 
Kawasaki Frontale       -  Vissel Kobe 
Shonan Bellmare         -  Avispa Fukuoka 
Albirex Niigata         -  Júbilo Iwata 
Kyoto Sanga             -  Nagoya Grampus 
Gamba Osaka             -  FC Tokyo  


Bournemouth   4-3 Luton         [replay]

Luton         1-1 Coventry      [aet, 6-5 pen]
Sheffield W   5-1 Peterborough  [aet, 5-3 pen]
Stockport     2-1 Salford       [aet, 3-1 pen]
Stockport     1-1 Carlisle      [aet, 4-5 pen]
Notts County  2-2 Chesterfield  [aet, 4-3 pen]


### check if more walk over (w/o) matches anywhere?
Altrincham     w/o    Gateshead 


Morelia            2-2 Tijuana            [2-4pen]
Toluca             1-1 Atlante            [3-5pen]
Monterrey          2-2 Leones Negros      [4-3pen]
Guadalajara        1-1 Atlante            [3-5pen]

FC Juárez            2-1 Alebrijes            [aet; 2-4pen]
Düsseldorf           0-3 Bochum          [aet, 5-6 pen]
Hannover II        3-2  Würzburg        [aet, 5-4 pen]

SV Bad Schallerbach    2-3 WSG Tirol                           [aet]
ASK Voitsberg          1-2 First Vienna FC 1894                [aet]
Deutschlandsberger SC  1-1 Kapfenberger SV 1919                [aet, 5-6 pen]
FC Marchfeld Donauauen 1-1 SC Weiz                             [aet, 4-2 pen]
Austria XIII Wien      4-4 USV Weindorf Sankt Anna/Aigen       [aet, 3-4 pen]
SV Leobendorf          3-2 SV Horn                             [aet]

Mattersburger SV 2020  1-1 ASV Siegendorf                [3-5 pen]
ASV Siegendorf         1-1 ASV Draßburg                  [4-2 pen]


Italy     1-1 Spain              [aet, 4-2 pen]
England   2-1 Denmark            [aet]
England   1-1 Italy              [aet, 2-3 pen]
Uruguay   0-0 Colombia           [2-4 pen]
Argentina 1-1 Colombia           [3-2 pen]


[De Paul 40, Lautaro Martinez 84, Messi 90+3]
[Yotun 45, Lapadula 82; Cuadrado 49, Diaz 66, 90+4]

[Tapia 23og, Ayrton Preciado 45+3; Lapadula 49, Carrillo 54]
[Firmino 78, Casemiro 90+10; Diaz 10]

TXT

lines = txt.split( "\n" )
pp lines


parser = Rsssf::Parser.new

tree = []
lines.each do |line|
 
    ## skip blank and comment lines
    next if line.strip.empty? || line.strip.start_with?('#')

    ## strip inline (end-of-line) comments
    line = line.sub( /#.+$/, '' )

   puts
   puts "line #{line.inspect}"   # note - use inspect (will show \t etc.)
   # t = parser.tokenize( line )
   t = parser.parse( line )
   pp t
   tree << t
end

puts
puts "tree:"
pp tree

exp = [[[:text, "Athletic Club (Bilbao)"]],
[[:text, "USC Paloma (Hamburg)"]],
[[:round, "1/8 Finals"]],
[[:round, "1/16 Finals"]],
[[:score_ext, "aet, 9-8 pen"]],
[[:score_ext, "aet, 5-3 pen"]],
[[:score_ext, "aet, 6-5 pen"]],
[[:score_ext, "aet"]],
[[:team, "Wiener Neustadt"], [:score_abd, "abd"], [:team, "Grödig"], [:note, "abandoned at 1-0 in 20' due to fog"]],
[[:team, "Wiener Neustadt"], [:score, "2-4"], [:team, "Grödig"], [:note, "replay"]],
[[:player, "Matheus Ferraz"],
 [:minute, "45'+1'"],
 [:","],
 [:player, "Lins"],
 [:minute, "46'"],
 [:","],
 [:player, "João Vítor"],
 [:minute, "82'"],
 [:";"],
 [:player, "Diones"],
 [:minute, "72'"]],
[[:player, "Rafael Sóbis"],
 [:minute, "15'"],
 [:pen, "p"],
 [:","],
 [:player, "Samuel"],
 [:minute, "53'"],
 [:";"],
 [:player, "Manoel"],
 [:minute, "28'"]],
[[:player, "Diego Souza"],
 [:minute, "5'"],
 [:","],
 [:player, "Bruno Rodrigo"],
 [:minute, "30'"],
 [:","],
 [:player, "Nílton"],
 [:minute, "40'"],
 [:","],
 [:minute, "79'"],
 [:","],
 [:player, "Borges"],
 [:minute, "42'"]],
[[:player, "Deivid"],
 [:minute, "53'"],
 [:","],
 [:player, "Arthur"],
 [:minute, "90'+1'"],
 [:";"],
 [:player, "Diego Tardelli"],
 [:minute, "51'"]],
[[:player, "Fernandes"],
 [:minute, "75'"],
 [:","],
 [:player, "Caio"],
 [:minute, "90'+4'"],
 [:";"],
 [:player, "Araújo"],
 [:minute, "79'"],
 [:pen, "p"]],
[[:player, "Jô"], [:minute, "48'"]],
[[:player, "Araújo"],
 [:minute, "16'"],
 [:","],
 [:player, "Lúcio"],
 [:minute, "32'"],
 [:","],
 [:player, "Derley"],
 [:minute, "82'"],
 [:";"],
 [:player, "Márcio Azevedo"],
 [:minute, "48'"],
 [:","],
 [:player, "Cesinha"],
 [:minute, "59'"],
 [:og, "og"]],
[[:player, "Márcio"],
 [:minute, "38'"],
 [:pen, "p"],
 [:","],
 [:player, "Felipe"],
 [:minute, "58'"],
 [:","],
 [:player, "Joílson"],
 [:minute, "82'"],
 [:";"],
 [:player, "Caio"],
 [:minute, "23'"],
 [:pen, "p"],
 [:","],
 [:minute, "62'"],
 [:pen, "p"]],
[[:player, "Fred"],
 [:minute, "48'"],
 [:pen, "p"],
 [:","],
 [:minute, "74'"],
 [:pen, "p"],
 [:","],
 [:player, "Thiago Neves"],
 [:minute, "65'"],
 [:","],
 [:player, "Wallace"],
 [:minute, "87'"]],
[[:player, "Matheus Ferraz"],
 [:minute, "45+1"],
 [:","],
 [:player, "Lins"],
 [:minute, "46"],
 [:","],
 [:player, "João Vítor"],
 [:minute, "82"],
 [:";"],
 [:player, "Diones"],
 [:minute, "72"]],
[[:player, "Rafael Sóbis"],
 [:minute, "15"],
 [:pen, "p"],
 [:","],
 [:player, "Samuel"],
 [:minute, "53"],
 [:";"],
 [:player, "Manoel"],
 [:minute, "28"]],
[[:player, "Diego Souza"],
 [:minute, "5"],
 [:","],
 [:player, "Bruno Rodrigo"],
 [:minute, "30"],
 [:","],
 [:player, "Nílton"],
 [:minute, "40"],
 [:","],
 [:minute, "79"],
 [:","],
 [:player, "Borges"],
 [:minute, "42"]],
[[:player, "Deivid"],
 [:minute, "53"],
 [:","],
 [:player, "Arthur"],
 [:minute, "90+1"],
 [:";"],
 [:player, "Diego Tardelli"],
 [:minute, "51"]],
[[:player, "Fernandes"],
 [:minute, "75"],
 [:","],
 [:player, "Caio"],
 [:minute, "90+4"],
 [:";"],
 [:player, "Araújo"],
 [:minute, "79"],
 [:pen, "p"]],
[[:player, "Jô"], [:minute, "48"]],
[[:player, "Araújo"],
 [:minute, "16"],
 [:","],
 [:player, "Lúcio"],
 [:minute, "32"],
 [:","],
 [:player, "Derley"],
 [:minute, "82"],
 [:";"],
 [:player, "Márcio Azevedo"],
 [:minute, "48"],
 [:","],
 [:player, "Cesinha"],
 [:minute, "59"],
 [:og, "og"]],
[[:player, "Márcio"],
 [:minute, "38"],
 [:pen, "p"],
 [:","],
 [:player, "Felipe"],
 [:minute, "58"],
 [:","],
 [:player, "Joílson"],
 [:minute, "82"],
 [:";"],
 [:player, "Caio"],
 [:minute, "23"],
 [:pen, "p"],
 [:","],
 [:minute, "62"],
 [:pen, "p"]],
[[:player, "Fred"],
 [:minute, "48"],
 [:pen, "p"],
 [:","],
 [:minute, "74"],
 [:pen, "p"],
 [:","],
 [:player, "Thiago Neves"],
 [:minute, "65"],
 [:","],
 [:player, "Wallace"],
 [:minute, "87"]],
[[:player, "Matheus Ferraz"],
 [:minute, "45+1"],
 [:player, "Lins"],
 [:minute, "46"],
 [:player, "João Vítor"],
 [:minute, "82"],
 [:";"],
 [:player, "Diones"],
 [:minute, "72"]],
[[:player, "Rafael Sóbis"],
 [:minute, "15"],
 [:pen, "p"],
 [:player, "Samuel"],
 [:minute, "53"],
 [:";"],
 [:player, "Manoel"],
 [:minute, "28"]],
[[:player, "Diego Souza"],
 [:minute, "5"],
 [:player, "Bruno Rodrigo"],
 [:minute, "30"],
 [:player, "Nílton"],
 [:minute, "40"],
 [:","],
 [:minute, "79"],
 [:player, "Borges"],
 [:minute, "42"]],
[[:player, "Deivid"],
 [:minute, "53"],
 [:player, "Arthur"],
 [:minute, "90+1"],
 [:";"],
 [:player, "Diego Tardelli"],
 [:minute, "51"]],
[[:player, "Fernandes"],
 [:minute, "75"],
 [:player, "Caio"],
 [:minute, "90+4"],
 [:";"],
 [:player, "Araújo"],
 [:minute, "79"],
 [:pen, "p"]],
[[:player, "Jô"], [:minute, "48"]],
[[:player, "Araújo"],
 [:minute, "16"],
 [:player, "Lúcio"],
 [:minute, "32"],
 [:player, "Derley"],
 [:minute, "82"],
 [:";"],
 [:player, "Márcio Azevedo"],
 [:minute, "48"],
 [:player, "Cesinha"],
 [:minute, "59"],
 [:og, "og"]],
[[:player, "Márcio"],
 [:minute, "38"],
 [:pen, "p"],
 [:player, "Felipe"],
 [:minute, "58"],
 [:player, "Joílson"],
 [:minute, "82"],
 [:";"],
 [:player, "Caio"],
 [:minute, "23"],
 [:pen, "p"],
 [:","],
 [:minute, "62"],
 [:pen, "p"]],
[[:player, "Fred"],
 [:minute, "48"],
 [:pen, "p"],
 [:","],
 [:minute, "74"],
 [:pen, "p"],
 [:player, "Thiago Neves"],
 [:minute, "65"],
 [:player, "Wallace"],
 [:minute, "87"]],
[[:player, "Jaime Gavilán"],
 [:minute, "4"],
 [:","],
 [:minute, "90+"],
 [:","],
 [:player, "Adrián Colunga"],
 [:minute, "10"],
 [:","],
 [:player, "Angel Arizmendi"],
 [:minute, "90+"],
 [:og, "og"],
 [:";"]],
[[:player, "Rafa Jordá"], [:minute, "13"]],
[[:player, "Cristiano Ronaldo"], [:minute, "30"], [:","], [:minute, "62"], [:","], [:minute, "90+"], [:pen, "pen"]],
[[:player, "Quincy Owusu-abeyie"], [:minute, "35"]],
[[:player, "Sergio González N'Sue"], [:minute, "37"]],
[[:team, "Cruzeiro"], [:vs, "-"], [:team, "Internacional"]],
[[:team, "Grêmio"], [:vs, "-"], [:team, "Criciúma"]],
[[:team, "Atlético/MG"], [:vs, "-"], [:team, "Grêmio"]],
[[:team, "Internacional"], [:vs, "-"], [:team, "Juventude"]],
[[:team, "Kashima Antlers"], [:vs, "-"], [:team, "Sagan Tosu"]],
[[:team, "Tokyo Verdy"], [:vs, "-"], [:team, "Sanfrecce Hiroshima"]],
[[:team, "Kawasaki Frontale"], [:vs, "-"], [:team, "Vissel Kobe"]],
[[:team, "Shonan Bellmare"], [:vs, "-"], [:team, "Avispa Fukuoka"]],
[[:team, "Albirex Niigata"], [:vs, "-"], [:team, "Júbilo Iwata"]],
[[:team, "Kyoto Sanga"], [:vs, "-"], [:team, "Nagoya Grampus"]],
[[:team, "Gamba Osaka"], [:vs, "-"], [:team, "FC Tokyo"]],
[[:team, "Bournemouth"], [:score, "4-3"], [:team, "Luton"], [:note, "replay"]],
[[:team, "Luton"], [:score, "1-1"], [:team, "Coventry"], [:score_ext, "aet, 6-5 pen"]],
[[:team, "Sheffield W"], [:score, "5-1"], [:team, "Peterborough"], [:score_ext, "aet, 5-3 pen"]],
[[:team, "Stockport"], [:score, "2-1"], [:team, "Salford"], [:score_ext, "aet, 3-1 pen"]],
[[:team, "Stockport"], [:score, "1-1"], [:team, "Carlisle"], [:score_ext, "aet, 4-5 pen"]],
[[:team, "Notts County"], [:score, "2-2"], [:team, "Chesterfield"], [:score_ext, "aet, 4-3 pen"]],
[[:team, "Altrincham"], [:score_wo, "w/o"], [:team, "Gateshead"]],
[[:team, "Morelia"], [:score, "2-2"], [:team, "Tijuana"], [:score_ext, "2-4pen"]],
[[:team, "Toluca"], [:score, "1-1"], [:team, "Atlante"], [:score_ext, "3-5pen"]],
[[:team, "Monterrey"], [:score, "2-2"], [:team, "Leones Negros"], [:score_ext, "4-3pen"]],
[[:team, "Guadalajara"], [:score, "1-1"], [:team, "Atlante"], [:score_ext, "3-5pen"]],
[[:team, "FC Juárez"], [:score, "2-1"], [:team, "Alebrijes"], [:score_ext, "aet; 2-4pen"]],
[[:team, "Düsseldorf"], [:score, "0-3"], [:team, "Bochum"], [:score_ext, "aet, 5-6 pen"]],
[[:team, "Hannover II"], [:score, "3-2"], [:team, "Würzburg"], [:score_ext, "aet, 5-4 pen"]],
[[:team, "SV Bad Schallerbach"], [:score, "2-3"], [:team, "WSG Tirol"], [:score_ext, "aet"]],
[[:team, "ASK Voitsberg"], [:score, "1-2"], [:team, "First Vienna FC 1894"], [:score_ext, "aet"]],
[[:team, "Deutschlandsberger SC"], [:score, "1-1"], [:team, "Kapfenberger SV 1919"], [:score_ext, "aet, 5-6 pen"]],
[[:team, "FC Marchfeld Donauauen"], [:score, "1-1"], [:team, "SC Weiz"], [:score_ext, "aet, 4-2 pen"]],
[[:team, "Austria XIII Wien"],
 [:score, "4-4"],
 [:team, "USV Weindorf Sankt Anna/Aigen"],
 [:score_ext, "aet, 3-4 pen"]],
[[:team, "SV Leobendorf"], [:score, "3-2"], [:team, "SV Horn"], [:score_ext, "aet"]],
[[:team, "Mattersburger SV 2020"], [:score, "1-1"], [:team, "ASV Siegendorf"], [:score_ext, "3-5 pen"]],
[[:team, "ASV Siegendorf"], [:score, "1-1"], [:team, "ASV Draßburg"], [:score_ext, "4-2 pen"]],
[[:team, "Italy"], [:score, "1-1"], [:team, "Spain"], [:score_ext, "aet, 4-2 pen"]],
[[:team, "England"], [:score, "2-1"], [:team, "Denmark"], [:score_ext, "aet"]],
[[:team, "England"], [:score, "1-1"], [:team, "Italy"], [:score_ext, "aet, 2-3 pen"]],
[[:team, "Uruguay"], [:score, "0-0"], [:team, "Colombia"], [:score_ext, "2-4 pen"]],
[[:team, "Argentina"], [:score, "1-1"], [:team, "Colombia"], [:score_ext, "3-2 pen"]],
[[:player, "De Paul"],
 [:minute, "40"],
 [:","],
 [:player, "Lautaro Martinez"],
 [:minute, "84"],
 [:","],
 [:player, "Messi"],
 [:minute, "90+3"]],
[[:player, "Yotun"],
 [:minute, "45"],
 [:","],
 [:player, "Lapadula"],
 [:minute, "82"],
 [:";"],
 [:player, "Cuadrado"],
 [:minute, "49"],
 [:","],
 [:player, "Diaz"],
 [:minute, "66"],
 [:","],
 [:minute, "90+4"]],
[[:player, "Tapia"],
 [:minute, "23"],
 [:og, "og"],
 [:","],
 [:player, "Ayrton Preciado"],
 [:minute, "45+3"],
 [:";"],
 [:player, "Lapadula"],
 [:minute, "49"],
 [:","],
 [:player, "Carrillo"],
 [:minute, "54"]],
[[:player, "Firmino"],
 [:minute, "78"],
 [:","],
 [:player, "Casemiro"],
 [:minute, "90+10"],
 [:";"],
 [:player, "Diaz"],
 [:minute, "10"]]]

assert_equal exp, tree
  end


  def test_misc_ii
txt =<<TXT
## see  https://www.rsssf.org/tables/2022q.html 

Group I

25- 3-21 Andorra la V.   Andorra       0-1 Albania
25- 3-21 London          England       5-0 San Marino
25- 3-21 Budapest        Hungary       3-3 Poland
28- 3-21 Tiranë          Albania       0-2 England
28- 3-21 Warszawa        Poland        3-0 Andorra
28- 3-21 Serravalle      San Marino    0-3 Hungary
31- 3-21 Andorra la V.   Andorra       1-4 Hungary
31- 3-21 London          England       2-1 Poland
31- 3-21 Serravalle      San Marino    0-2 Albania
 2- 9-21 Andorra la V.   Andorra       2-0 San Marino
 2- 9-21 Budapest        Hungary       0-4 England
 2- 9-21 Warszawa        Poland        4-1 Albania


 1- 6-19 Colombo         Sri Lanka     awd Macao         [awarded 3-0]


21- 9-22 São Paulo       Brazil        n/p Argentina     [declared void]


 5- 9-19 Pyongyang       North Korea   2-0 Lebanon       [annulled]
10- 9-19 Ashgabat        Turkmenistan  0-2 South Korea
10- 9-19 Colombo         Sri Lanka     0-1 North Korea   [annulled]

17- 3-22 Doha            Cook Islands  0-2 Solomon I.    [annulled]
17- 3-22 Doha            Tahiti        n/p Vanuatu       
20- 3-22 Doha            Cook Islands  n/p Tahiti        
20- 3-22 Doha            Solomon I.    n/p Vanuatu       
24- 3-22 Doha            Vanuatu       n/p Cook Islands  


13- 6-22 Al-Rayyan       Australia     0-0 Peru         

 8- 9-19 Dar es Salaam   Tanzania      1-1 Burundi       [aet, 3-0 pen.]


  1- 9-21 Douala          Centr.Afr. R. 1-1 Cape Verde


 Semifinals
 24- 3-22 Cardiff         Wales         2-1 Austria
  1- 6-22 Glasgow         Scotland      1-3 Ukrain
 
 Final
  5- 6-22 Cardiff         Wales         1-0 Ukraine
 

#### more from various sources

Atlas              ppd Tigres  
Racing             abd Plaza              [abandoned at 1-0 in 31']
Standard          awd Westerlo          [awarded 0-5, Standard dns]
Innsbruck        awd Sturm            [awarded 0-3; abandoned at 0-1 in 90+1']
Wiener Neustadt  abd Grödig           [abandoned at 1-0 in 20' due to fog]
SV Austria Salzburg         2-0 FC Blau-Weiß Linz           [played in Vöcklabruck]



TXT


lines = txt.split( "\n" )
pp lines


parser = Rsssf::Parser.new

tree = []
lines.each do |line|
 
    ## skip blank and comment lines
    next if line.strip.empty? || line.strip.start_with?('#')

    ## strip inline (end-of-line) comments
    line = line.sub( /#.+$/, '' )

   puts
   puts "line #{line.inspect}"   # note - use inspect (will show \t etc.)
   # t = parser.tokenize( line )
   t = parser.parse( line )
   pp t
   tree << t
end

puts
puts "tree:"
pp tree

exp = [
[[:group, "Group I"]],
[[:date, "25- 3-21"], [:text, "Andorra la V."], [:team, "Andorra"], [:score, "0-1"], [:team, "Albania"]],
[[:date, "25- 3-21"], [:text, "London"], [:team, "England"], [:score, "5-0"], [:team, "San Marino"]],
[[:date, "25- 3-21"], [:text, "Budapest"], [:team, "Hungary"], [:score, "3-3"], [:team, "Poland"]],
[[:date, "28- 3-21"], [:text, "Tiranë"], [:team, "Albania"], [:score, "0-2"], [:team, "England"]],
[[:date, "28- 3-21"], [:text, "Warszawa"], [:team, "Poland"], [:score, "3-0"], [:team, "Andorra"]],
[[:date, "28- 3-21"], [:text, "Serravalle"], [:team, "San Marino"], [:score, "0-3"], [:team, "Hungary"]],
[[:date, "31- 3-21"], [:text, "Andorra la V."], [:team, "Andorra"], [:score, "1-4"], [:team, "Hungary"]],
[[:date, "31- 3-21"], [:text, "London"], [:team, "England"], [:score, "2-1"], [:team, "Poland"]],
[[:date, "31- 3-21"], [:text, "Serravalle"], [:team, "San Marino"], [:score, "0-2"], [:team, "Albania"]],
[[:date, "2- 9-21"], [:text, "Andorra la V."], [:team, "Andorra"], [:score, "2-0"], [:team, "San Marino"]],
[[:date, "2- 9-21"], [:text, "Budapest"], [:team, "Hungary"], [:score, "0-4"], [:team, "England"]],
[[:date, "2- 9-21"], [:text, "Warszawa"], [:team, "Poland"], [:score, "4-1"], [:team, "Albania"]],
[[:date, "1- 6-19"],
 [:text, "Colombo"],
 [:team, "Sri Lanka"],
 [:score_awd, "awd"],
 [:team, "Macao"],
 [:note, "awarded 3-0"]],
[[:date, "21- 9-22"],
 [:text, "São Paulo"],
 [:team, "Brazil"],
 [:score_np, "n/p"],
 [:team, "Argentina"],
 [:note, "declared void"]],
[[:date, "5- 9-19"],
 [:text, "Pyongyang"],
 [:team, "North Korea"],
 [:score, "2-0"],
 [:team, "Lebanon"],
 [:note, "annulled"]],
[[:date, "10- 9-19"], [:text, "Ashgabat"], [:team, "Turkmenistan"], [:score, "0-2"], [:team, "South Korea"]],
[[:date, "10- 9-19"],
 [:text, "Colombo"],
 [:team, "Sri Lanka"],
 [:score, "0-1"],
 [:team, "North Korea"],
 [:note, "annulled"]],
[[:date, "17- 3-22"],
 [:text, "Doha"],
 [:team, "Cook Islands"],
 [:score, "0-2"],
 [:team, "Solomon I."],
 [:note, "annulled"]],
[[:date, "17- 3-22"], [:text, "Doha"], [:team, "Tahiti"], [:score_np, "n/p"], [:team, "Vanuatu"]],
[[:date, "20- 3-22"], [:text, "Doha"], [:team, "Cook Islands"], [:score_np, "n/p"], [:team, "Tahiti"]],
[[:date, "20- 3-22"], [:text, "Doha"], [:team, "Solomon I."], [:score_np, "n/p"], [:team, "Vanuatu"]],
[[:date, "24- 3-22"], [:text, "Doha"], [:team, "Vanuatu"], [:score_np, "n/p"], [:team, "Cook Islands"]],
[[:date, "13- 6-22"], [:text, "Al-Rayyan"], [:team, "Australia"], [:score, "0-0"], [:team, "Peru"]],
[[:date, "8- 9-19"],
 [:text, "Dar es Salaam"],
 [:team, "Tanzania"],
 [:score, "1-1"],
 [:team, "Burundi"],
 [:score_ext, "aet, 3-0 pen."]],
[[:date, "1- 9-21"], [:text, "Douala"], [:team, "Centr.Afr. R."], [:score, "1-1"], [:team, "Cape Verde"]],
[[:round, "Semifinals"]],
[[:date, "24- 3-22"], [:text, "Cardiff"], [:team, "Wales"], [:score, "2-1"], [:team, "Austria"]],
[[:date, "1- 6-22"], [:text, "Glasgow"], [:team, "Scotland"], [:score, "1-3"], [:team, "Ukrain"]],
[[:round, "Final"]],
[[:date, "5- 6-22"], [:text, "Cardiff"], [:team, "Wales"], [:score, "1-0"], [:team, "Ukraine"]],
[[:team, "Atlas"], [:score_ppd, "ppd"], [:team, "Tigres"]],
[[:team, "Racing"], [:score_abd, "abd"], [:team, "Plaza"], [:note, "abandoned at 1-0 in 31'"]],
[[:team, "Standard"], [:score_awd, "awd"], [:team, "Westerlo"], [:note, "awarded 0-5, Standard dns"]],
[[:team, "Innsbruck"], [:score_awd, "awd"], [:team, "Sturm"], [:note, "awarded 0-3; abandoned at 0-1 in 90+1'"]],
[[:team, "Wiener Neustadt"], [:score_abd, "abd"], [:team, "Grödig"], [:note, "abandoned at 1-0 in 20' due to fog"]],
[[:team, "SV Austria Salzburg"], [:score, "2-0"], [:team, "FC Blau-Weiß Linz"], [:note, "played in Vöcklabruck"]]]

    assert_equal exp, tree
  end
end