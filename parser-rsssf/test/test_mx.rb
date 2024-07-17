###
#  to run use
#     ruby test/test_mx.rb


require_relative 'helper'

class TestMx < Minitest::Test

  def test_playoffs
mx =<<TXT

# Playoffs
#
# NB: between top-8 of regular season


Quarterfinals

First Legs
[Nov 22]
Toluca             2-1 Morelia            
  [Fernando Uribe 90, Pablo Barrientos 93; Raúl Ruidiaz 65pen]
León               1-1 Tigres             
  [Mauro Boselli 58; Eduardo Jesús Vargas 75]
[Nov 23]
Cruz Azul          0-0 América            
Atlas              1-2 Monterrey          
  [Christian Tabó 34; Rogelio Funes Mori 4, 17]

Second Legs
[Nov 25]
Tigres             1-1 León               
  [André-Pierre Gignac 19; Andrés Mosquera 24]
Morelia            2-1 Toluca             
  [Raúl Ruidiaz 5, Ángel Sepúlveda 15; Fernando Uribe 4]
[Nov 26]
Monterrey          4-1 Atlas              
  [Rogelio Funes Mori 13, Carlos Sánchez 25, Avilés Hurtado 28, 39; 
   Milton Caraglio 33pen]
América            0-0 Cruz Azul          

# NB: América, Morelia and Tigres qualified on better record regular season

Semifinals

First Legs
[Nov 29]
América            0-1 Tigres             
  [Anselmo Vendrechovski 48pen]
[Nov 30]
Morelia            0-1 Monterrey          
  [Avilés Hurtado 37pen]

Second Legs
[Dec 2]
Tigres             3-0 América            
  [Enner Valencia 56, 71, André-Pierre Gignac 75pen]
[Dec 3]
Monterrey          4-0 Morelia            
  [Rogelio Funes Mori 9, 28, 52, Carlos Sánchez 21pen]

Final

First Leg [Dec 7]
Tigres             1-1 Monterrey          
  [Enner Valencia 26pen; Nicolás Sánchez 8]

Second Leg [Dec 10]
Monterrey          1-2 Tigres             
  [Dorlan Pabón 2; Eduardo Jesús Vargas 30, Francisco Meza 34]


TXT

lines = mx.split( "\n" )
pp lines


tree = []
lines.each do |line|
   ## skip blank and comment lines
   next if line.strip.empty? || line.strip.start_with?('#')

   tree <<  parse( line )
end

pp tree


exp = [
 [[:round, "Quarterfinals"]],
 [[:leg, "First Legs"]],
 [[:date, "Nov 22"]],
 [[:team, "Toluca"], [:score, "2-1"], [:team, "Morelia"]],
   [[:player, "Fernando Uribe"],[:minute, "90"],[:","],
    [:player, "Pablo Barrientos"],[:minute, "93"],[:";"],
    [:player, "Raúl Ruidiaz"],[:minute, "65"],[:pen, "pen"]],
 [[:team, "León"], [:score, "1-1"], [:team, "Tigres"]],
   [[:player, "Mauro Boselli"], [:minute, "58"], [:";"], 
    [:player, "Eduardo Jesús Vargas"], [:minute, "75"]],
 [[:date, "Nov 23"]],
 [[:team, "Cruz Azul"], [:score, "0-0"], [:team, "América"]],
 [[:team, "Atlas"], [:score, "1-2"], [:team, "Monterrey"]],
   [[:player, "Christian Tabó"],[:minute, "34"],[:";"],
    [:player, "Rogelio Funes Mori"],[:minute, "4"],[:","],[:minute, "17"]],
 [[:leg, "Second Legs"]],
 [[:date, "Nov 25"]],
 [[:team, "Tigres"], [:score, "1-1"], [:team, "León"]],
   [[:player, "André-Pierre Gignac"], [:minute, "19"], [:";"], 
    [:player, "Andrés Mosquera"], [:minute, "24"]],
 [[:team, "Morelia"], [:score, "2-1"], [:team, "Toluca"]],
   [[:player, "Raúl Ruidiaz"],[:minute, "5"],[:","],
    [:player, "Ángel Sepúlveda"],[:minute, "15"],[:";"],
    [:player, "Fernando Uribe"],[:minute, "4"]],
 [[:date, "Nov 26"]],
 [[:team, "Monterrey"], [:score, "4-1"], [:team, "Atlas"]],
   [[:player, "Rogelio Funes Mori"],[:minute, "13"],[:","],
    [:player, "Carlos Sánchez"],[:minute, "25"],[:","],
    [:player, "Avilés Hurtado"],[:minute, "28"],[:","],[:minute, "39"],[:";"]],
   [[:player, "Milton Caraglio"], [:minute, "33"], [:pen, "pen"]],
 [[:team, "América"], [:score, "0-0"], [:team, "Cruz Azul"]],
 [[:round, "Semifinals"]],
 [[:leg, "First Legs"]],
 [[:date, "Nov 29"]],
 [[:team, "América"], [:score, "0-1"], [:team, "Tigres"]],
   [[:player, "Anselmo Vendrechovski"], [:minute, "48"], [:pen, "pen"]],
 [[:date, "Nov 30"]],
 [[:team, "Morelia"], [:score, "0-1"], [:team, "Monterrey"]],
   [[:player, "Avilés Hurtado"], [:minute, "37"], [:pen, "pen"]],
 [[:leg, "Second Legs"]],
 [[:date, "Dec 2"]],
 [[:team, "Tigres"], [:score, "3-0"], [:team, "América"]],
   [[:player, "Enner Valencia"],[:minute, "56"],[:","],[:minute, "71"],[:","],
    [:player, "André-Pierre Gignac"],[:minute, "75"],[:pen, "pen"]],
 [[:date, "Dec 3"]],
 [[:team, "Monterrey"], [:score, "4-0"], [:team, "Morelia"]],
   [[:player, "Rogelio Funes Mori"],[:minute, "9"],[:","],[:minute, "28"],[:","],[:minute, "52"],[:","],
    [:player, "Carlos Sánchez"],[:minute, "21"],[:pen, "pen"]],
 [[:round, "Final"]],
 [[:leg, "First Leg"], [:date, "Dec 7"]],
 [[:team, "Tigres"], [:score, "1-1"], [:team, "Monterrey"]],
   [[:player, "Enner Valencia"], [:minute, "26"], [:pen, "pen"], [:";"], 
    [:player, "Nicolás Sánchez"], [:minute, "8"]],
 [[:leg, "Second Leg"], [:date, "Dec 10"]],
 [[:team, "Monterrey"], [:score, "1-2"], [:team, "Tigres"]],
 [[:player, "Dorlan Pabón"],[:minute, "2"],[:";"],
  [:player, "Eduardo Jesús Vargas"],[:minute, "30"],[:","],
  [:player, "Francisco Meza"],[:minute, "34"]]]

    assert_equal exp, tree
  end


  def test_regular

mx =<<TXT

Round 1
[Jul 21]
Morelia            0-0 Monterrey          
Tijuana            0-2 Cruz Azul          
  [Edgar Méndez 20, 82]
[Jul 22]
América            0-1 Querétaro          
  [Camilo Sanvezzo 86pen]
Lobos BUAP         2-2 Santos             
  [Jorge Enríquez 14og, Julián Quiñónes 31; Osvaldo David Martínez 21, Julio César Furch 42]
Tigres             5-0 Puebla             
  [Lucas Zelarayán 15, Enner Valencia 23, 55, 58, Anselmo Vendrechovski 29]
León               0-3 Atlas              
  [Juan Pablo Vigón 2, Gustavo Matías Alustiza 60pen, Milton Caraglio 65]
Guadalajara        0-0 Toluca             
[Jul 23]
Pumas              1-0 Pachuca            
  [Nicolás Castillo 30]
Veracruz           0-2 Necaxa             
  [Jesús Antonio Isijara 11, Carlos Gabriel González 18]

Round 2
[Jul 28]
Puebla             1-1 Morelia            
  [Brayan Angulo 8; Brayan Angulo 45og]
Atlas              2-1 Pumas              
  [Jaine Barreiro 12, Gustavo Matías Alustiza 70; Abraham González 1]
[Jul 29]
Cruz Azul          1-1 Guadalajara        
  [Rafael Baca 30; Rodolfo Pizarro 63]
Querétaro          0-4 Lobos BUAP         
  [Julián Quiñónes 27, Francisco Javier Rodríguez 58, Juan Carlos Medina 65, 
   Diego Rafael Jiménez 94]
Monterrey          1-0 Veracruz           
  [Dorlan Pabón 1]
Pachuca            0-2 América            
  [Cecilio Domínguez 2, 52]
Necaxa             1-0 Tijuana            
  [Jesús Antonio Isijara 20]
[Jul 30]
Toluca             3-1 León               
  [Fernando Uribe 39, 43, Rubens Sambueza 47; Mauro Boselli 79pen]
Santos             1-1 Tigres             
  [Julio César Furch 58; Eduardo Jesús Vargas 12]
TXT


lines = mx.split( "\n" )
pp lines


tree = []
lines.each do |line|
   ## skip blank and comment lines
   next if line.strip.empty? || line.strip.start_with?('#')

   tree <<  parse( line )
end

pp tree

exp =  [
[[:round, "Round 1"]],
[[:date, "Jul 21"]],
[[:team, "Morelia"], [:score, "0-0"], [:team, "Monterrey"]],
[[:team, "Tijuana"], [:score, "0-2"], [:team, "Cruz Azul"]],
   [[:player, "Edgar Méndez"], [:minute, "20"], [:","], [:minute, "82"]],
[[:date, "Jul 22"]],
[[:team, "América"], [:score, "0-1"], [:team, "Querétaro"]],
  [[:player, "Camilo Sanvezzo"], [:minute, "86"], [:pen, "pen"]],
[[:team, "Lobos BUAP"], [:score, "2-2"], [:team, "Santos"]],
  [[:player, "Jorge Enríquez"],[:minute, "14"],[:og, "og"],[:","],
   [:player, "Julián Quiñónes"],[:minute, "31"],[:";"],
   [:player, "Osvaldo David Martínez"],[:minute, "21"],[:","],
   [:player, "Julio César Furch"],[:minute, "42"]],
[[:team, "Tigres"], [:score, "5-0"], [:team, "Puebla"]],
  [[:player, "Lucas Zelarayán"],[:minute, "15"],[:","],
   [:player, "Enner Valencia"],[:minute, "23"],[:","],[:minute, "55"],[:","],[:minute, "58"],[:","],
   [:player, "Anselmo Vendrechovski"],[:minute, "29"]],
[[:team, "León"], [:score, "0-3"], [:team, "Atlas"]],
  [[:player, "Juan Pablo Vigón"],[:minute, "2"],[:","],
   [:player, "Gustavo Matías Alustiza"],[:minute, "60"],[:pen, "pen"],[:","],
   [:player, "Milton Caraglio"],[:minute, "65"]],
[[:team, "Guadalajara"], [:score, "0-0"], [:team, "Toluca"]],
[[:date, "Jul 23"]],
[[:team, "Pumas"], [:score, "1-0"], [:team, "Pachuca"]],
[[:player, "Nicolás Castillo"], [:minute, "30"]],
[[:team, "Veracruz"], [:score, "0-2"], [:team, "Necaxa"]],
[[:player, "Jesús Antonio Isijara"], [:minute, "11"], [:","], 
 [:player, "Carlos Gabriel González"], [:minute, "18"]],
[[:round, "Round 2"]],
[[:date, "Jul 28"]],
[[:team, "Puebla"], [:score, "1-1"], [:team, "Morelia"]],
[[:player, "Brayan Angulo"], [:minute, "8"], [:";"], [:player, "Brayan Angulo"], [:minute, "45"], [:og, "og"]],
[[:team, "Atlas"], [:score, "2-1"], [:team, "Pumas"]],
  [[:player, "Jaine Barreiro"],[:minute, "12"],[:","],
   [:player, "Gustavo Matías Alustiza"],[:minute, "70"],[:";"],
   [:player, "Abraham González"],[:minute, "1"]],
[[:date, "Jul 29"]],
[[:team, "Cruz Azul"], [:score, "1-1"], [:team, "Guadalajara"]],
  [[:player, "Rafael Baca"], [:minute, "30"], [:";"], 
   [:player, "Rodolfo Pizarro"], [:minute, "63"]],
[[:team, "Querétaro"], [:score, "0-4"], [:team, "Lobos BUAP"]],
  [[:player, "Julián Quiñónes"],[:minute, "27"],[:","],
   [:player, "Francisco Javier Rodríguez"],[:minute, "58"],[:","],
   [:player, "Juan Carlos Medina"],[:minute, "65"],[:","]],
  [[:player, "Diego Rafael Jiménez"], [:minute, "94"]],
[[:team, "Monterrey"], [:score, "1-0"], [:team, "Veracruz"]],
  [[:player, "Dorlan Pabón"], [:minute, "1"]],
[[:team, "Pachuca"], [:score, "0-2"], [:team, "América"]],
  [[:player, "Cecilio Domínguez"], [:minute, "2"], [:","], [:minute, "52"]],
[[:team, "Necaxa"], [:score, "1-0"], [:team, "Tijuana"]],
  [[:player, "Jesús Antonio Isijara"], [:minute, "20"]],
[[:date, "Jul 30"]],
[[:team, "Toluca"], [:score, "3-1"], [:team, "León"]],
  [[:player, "Fernando Uribe"],[:minute, "39"],[:","],[:minute, "43"],[:","],
   [:player, "Rubens Sambueza"],[:minute, "47"],[:";"],
   [:player, "Mauro Boselli"],[:minute, "79"],[:pen, "pen"]],
[[:team, "Santos"], [:score, "1-1"], [:team, "Tigres"]],
  [[:player, "Julio César Furch"], [:minute, "58"], [:";"], 
   [:player, "Eduardo Jesús Vargas"], [:minute, "12"]]] 


  assert_equal exp, tree

  end  
end # class TestMx
