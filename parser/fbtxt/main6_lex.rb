####
#  to run use:
#    $ ruby ./main6_lex.rb  (in /fbtxt)



$LOAD_PATH.unshift( '../lib' )
require 'sportdb/parser'



txt = <<-TXT

Final - First Leg 

Jun 14 2000    Boca Juniors  2-2  Palmeiras   @ Buenos Aires, ARG   ## (att: 50580)

Referee: Gustavo Méndez (URU) 

BOCA JUNIORS: Oscar Córdoba - Hugo Ibarra, Jorge Bermúdez, Walter Samuel,
              Rodolfo Arruabarrena - Cristian Traverso, Sebastian Battaglia, 
              Juan Román Riquelme, Gustavo Barros Schelotto (César La Paglia 65'),
              Christian Giménez (Martín Palermo 46'), 
              Antonio Barijho (Guillermo Barros Schelotto 46'); Coach: Carlos Bianchi 
PALMEIRAS: Marcos - Nenem, Roque Júnior, Argel, Júnior - Rogério, César Sampaio -
           Galeano, Alex (Tiago 87'), Pena (Marcelo Ramos 62'), Euller (Faustino Asprilla 85');
           Coach: Luis Felipe Scolari 

Goals:  Arruabarrena 22' Arruabarrena 61'; Pena 43' Euller 63' 
Goals:  Arruabarrena  Arruabarrena; Pena  Euller    ## without (optional) minutes 

Goals:  Arruabarrena 45+1' Arruabarrena 61' (og); Pena 43' Euller 63' (pen) 


Yellow cards: Giménez 8', Riquelme 59', Traverso 65', Guillermo Barros Schelotto 88';
              Roque Júnior 5', Argel 60', Nenem 64' 

Yellow cards: Giménez, Riquelme, Traverso, Guillermo Barros Schelotto;
              Roque Júnior, Argel, Nenem 

Referee:  Danny Makkelie (Netherlands)
Referee:  Danny Makkelie 


    Merih Demiral 53' (og) Ciro Immobile 66' Lorenzo Insigne 79'


    
att: 28_000

attendance:  1234

02.11.1958 @ Bucuresti, 23 August   



### check  round outline   and geo with geo sep

» 1st Round
» 2nd Round

» Regular Season - 1
» Regular Season - 2


## check on text errors
      Gurten v Lustenau  4-0 (2-0)   @ Park-Arena Gurten › Gurten
     Gurten v Lustenau  4-0 (2-0)   @ Park21-Arena Gurten › Gurten
 
  Venezuela v Iceland  0-1 (0-0)   @ motion_invest Arena › Maria Enzersdorf


  ##  check for - time like 106.9  in geo name 
  AA v BB  @ Cheshire Silk 106.9 Stadium
  
  ##  check for v / vs in geo name
  AA v BB  @  Stadium v xyz
  AA v BB  @  Stadium vs xyz

TXT


     
  lexer = SportDb::Lexer.new( txt, debug: true )
  tokens, errors = lexer.tokenize_with_errors
  pp tokens

  if errors.size > 0
     puts "!! #{errors.size} tokenize error(s):"
     pp errors
  end


puts "bye"

