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
           Galeano, Alex (Tiago), Pena (Marcelo Ramos), 
           Euller (Faustino Asprilla);  Coach: Luis Felipe Scolari 

BOCA JUNIORS: Oscar Córdoba - Hugo Ibarra, Jorge Bermúdez, Walter Samuel,
              Rodolfo Arruabarrena - Cristian Traverso, Sebastian Battaglia, 
              Juan Román Riquelme, Gustavo Barros Schelotto (César La Paglia),
              Christian Giménez (Martín Palermo), 
              Antonio Barijho (Guillermo Barros Schelotto); 
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


### try nested subs

### todo/check for nested sub !!!
##    e.g. Clément Lenglet (Kingsley Coman 46' (Marcus Thuram 111'))

France:             Hugo Lloris - Benjamin Pavard, Raphaël Varane, 
                    Clément Lenglet (46' Kingsley Coman (111' Marcus Thuram)),
                    ## Clément Lenglet ( 46' Kingsley Coman ( 111' Marcus Thuram  )   )  , 
                    Clément Lenglet ( Kingsley Coman 46' ( Marcus Thuram 111' ) )  , 
                    Clément Lenglet (Kingsley Coman 45+2' (Marcus Thuram 112')), 
                    Clément Lenglet [Y] (Kingsley Coman [Y] 45+2' (Marcus Thuram [R] 112')), 
                    Clément Lenglet [Y 11'] (Kingsley Coman [Y 55'] 45+2' (Marcus Thuram [R 122'] 112')), 
                    ## Clément Lenglet ( Kingsley Coman ( Marcus Thuram 111' ) 46' ) , 
                    ## Clément Lenglet [Y] ( Kingsley Coman [Y] ( Marcus Thuram  ) )  , 
                    ## Clément Lenglet (Kingsley Coman 46'), 
                    Presnel Kimpembe, Adrien Rabiot -
                    Paul Pogba, N'Golo Kanté, Antoine Griezmann (Moussa Sissoko) -
                    Karim Benzema (Olivier Giroud), Kylian Mbappé;
                    Coach: Didier Deschamps

Referee:            Fernando Rapallini (Argentina)


TXT


   
parser = RaccMatchParser.new( txt, debug: true )
tree, errors = parser.parse_with_errors
pp tree

if errors.size > 0
   puts "!! #{errors.size} parse error(s):"
   pp errors
end


puts "bye"

