require_relative 'parser'



mx =<<TXT
Round 2
[Jul 28]
Puebla             1-1 Morelia            
  [Brayan Angulo 8'; Brayan Angulo 45'(og)]
Atlas              2-1 Pumas              
  [Jaine Barreiro 12', Gustavo Matías Alustiza 70'; Abraham González 1']
[Jul 29]
Cruz Azul          1-1 Guadalajara        
  [Rafael Baca 30'; Rodolfo Pizarro 63']
Querétaro          0-4 Lobos BUAP         
  [Julián Quiñónes 27', Francisco Javier Rodríguez 58', Juan Carlos Medina 65', 
   Diego Rafael Jiménez 94']
TXT


lines = mx.split( "\n" )
pp lines

lines.each_with_index do |line,i|
  puts
  puts "line #{i+1}/#{lines.size}  >#{line}<"
  tokens = tokenize( line )
  pp tokens
end



puts "bye"