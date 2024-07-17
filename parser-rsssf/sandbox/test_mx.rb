####
#  to run use:
#    $ ruby sandbox/test_mx.rb


$LOAD_PATH.unshift( '../parser/lib' )
$LOAD_PATH.unshift( './lib' )
require 'rsssf/parser'



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


# minutes with Offset
[De Paul 40, Lautaro Martinez 84, Messi 90+3]
[Yotun 45, Lapadula 82; Cuadrado 49, Diaz 66, 90+4]

[Tapia 23og, Ayrton Preciado 45+3; Lapadula 49, Carrillo 54]
[Firmino 78, Casemiro 90+10; Diaz 10]


## try club names with numbers
##  and dates without []

Jul 23
SSV Ulm 1846    0-0   FC Ingolstadt 04
Bayer 04 Leverkusen  1-1   TSG 1899 Hoffenheim
1.FC Heidenheim  2-2  1.FSV Mainz 05


Jul/24
SSV Ulm 1846 0-0 FC Ingolstadt 04
Bayer 04 Leverkusen 1-1 TSG 1899 Hoffenheim
1.FC Heidenheim 2-2 1.FSV Mainz 05

## try inline  notes

[played in Macaé-RJ]
[postponed due to problems with the screen of the stadium]
[postponed from Sep 10-12 due to death Queen Elizabeth II]
[originally scheduled to play in Mexico City] 
[suspended at 0-0 in 12' due to storm]  
[remaining 79']     
[In Estadio La Corregidora]  
[in Unidad Deportiva Centenario] 
[Rescheduled due to earthquake occurred in Mexico on September 19]
[awarded match to Leones Negros by undue alignment; original result 1-2]
[awarded 3-0 to Cafetaleros by undue alignment; originally ended 2-0]
[awarded 3-0; originally 0-2, América used ineligible player (Federico Viñas)]
[abandoned at 1-1 in 65' due to cardiac arrest Luton player Tom Lockyer]


## try player with quotes
## see https://github.com/rsssf/espana/blob/master/2010-11/1-liga.txt

["Renato" Dirnei Florencio 87,  
  "Simao" Pedro Fonseca 90]   
  
[  "Nilmar" Honorato da Silva 77, "Tiago" Cardoso Mendes 80; 
  "Cristiano Ronaldo" dos Santos Aveiro 74]
   

[ "Tiago" Cardoso Mendes 80,
    "Zé Castro" José Eduardo Rosa Vale Castro 60og,
     Antonio Galdeano "Apoño" 61pen,
     Xavier "Xavi" Hernández 73]


TXT



lines = mx.split( "\n" )
pp lines


parser = Rsssf::Parser.new

tree = []
lines.each do |line|
    ## skip blank and comment lines
    next if line.strip.empty? || line.strip.start_with?('#')

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


puts "bye"