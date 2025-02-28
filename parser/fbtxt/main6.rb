####
#  to run use:
#    $ ruby ./main6.rb  (in /fbtxt)



$LOAD_PATH.unshift( '../lib' )
require 'sportdb/parser'



txt = <<-TXT

Final - First Leg 

Jun 14 2000    Boca Juniors  2-2  Palmeiras   @ Buenos Aires, ARG   ## (att: 50580)

Referee: Gustavo Méndez (URU) 

PALMEIRAS: Marcos - Nenem, Roque Júnior, Argel, Júnior - Rogério, César Sampaio -
           Galeano, Alex (Tiago 87'), Pena (Marcelo Ramos 62'), 
           Euller (Faustino Asprilla 85');  Coach: Luis Felipe Scolari 

BOCA JUNIORS: Oscar Córdoba - Hugo Ibarra, Jorge Bermúdez, Walter Samuel,
              Rodolfo Arruabarrena - Cristian Traverso, Sebastian Battaglia, 
              Juan Román Riquelme, Gustavo Barros Schelotto (César La Paglia 65'),
              Christian Giménez (Martín Palermo 46'), 
              Antonio Barijho (Guillermo Barros Schelotto 46'); 
              Coach: Carlos Bianchi 



Yellow cards: Giménez 8', Riquelme 45+2', Traverso 65', Guillermo Barros Schelotto 88';
              Roque Júnior 5', Argel 60', Nenem 64' 

Sent off: Giménez, Riquelme, Traverso, Guillermo Barros Schelotto;
            Roque Júnior, Argel, Nenem 

Referee:  Danny Makkelie (Netherlands)


Goals:  Arruabarrena 22' Arruabarrena 61'; Pena 43' Euller 63' 
### todo/fix - add support for goals WITHOUT minutes
### Goals:  Arruabarrena  Arruabarrena; Pena  Euller    ## without (optional) minutes 

Goals:  Arruabarrena 45+1' Arruabarrena 61' (og); Pena 43' Euller 63' (pen) 


Italy v  France  
    Merih Demiral 53' (og) Ciro Immobile 66' Lorenzo Insigne 79'


TXT


   
parser = RaccMatchParser.new( txt, debug: true )
tree, errors = parser.parse_with_errors
pp tree

if errors.size > 0
   puts "!! #{errors.size} parse error(s):"
   pp errors
end


puts "bye"

