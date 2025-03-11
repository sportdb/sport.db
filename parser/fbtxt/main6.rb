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


Penalties:       1-0  Mario Gavranović, 1-1 Paul Pogba, 2-1  Fabian Schär, 2-2 Olivier Giroud,
                 3-2  Manuel Akanji, 3-3 Marcus Thuram, 4-3 Ruben Vargas,
                  4-4  Presnel Kimpembe, 5-4 Admir Mehmedi,  Kylian Mbappé (save)


Penalties:          0-0 Sergio Busquets (post), 0-1 Mario Gavranović, 1-1 Dani Olmo,
                    1-1 Fabian Schär (save), 1-1 Rodrigo Hernández "Rodri" (save),
                    1-1 Manuel Akanji (save), 2-1 Gerard Moreno, 2-1 Ruben Vargas (miss),
                    3-1  Mikel Oyarzabal

Penalties:          Sergio Busquets (post), Mario Gavranović,  Dani Olmo,
                    Fabian Schär (save),  Rodrigo Hernández 'Rodri' (save),
                    Manuel Akanji (save),  Gerard Moreno, Ruben Vargas (miss),
                    Mikel Oyarzabal


Penalty shootout: 0-0 Zinho (held), 0-1 Dudamel; 
                  1-1 Júnior Baiano, 1-2 Gaviria;
                  2-2 Roque Júnior, 2-3 Yepes; 
                  3-3 Rogério, 3-3 Bedoya (post);
                  4-3 Euller, 4-3 Zapata (wide) 


## check special rounds starting with 1/8  1/4  1/2
1/8 FINALS

att: 28_000
attn: 28001
attendance:  123

ref:  Fernando Rapallini (Argentina);  att: 28_099

02.11.1958 @ Bucuresti, 23 August   

## note - allow notes etc. after geo(s) - (auto-)switch back to top-level (mode) on bracket
##                  report other symbols as errors/warns
ITA v FRA  @ Bucuresti, 23 August    [nb: note here]


QUALIFYING ROUND

ITA - FRA  1-1  [aet]
ITA - FRA  2-2  [aet; ITA wins 4-3 on pens]
ITA - FRA  4-4  [aet; 4-3 pen]
ITA - FRA  4-4  [aet, 4-3p]
ITA - FRA  3-4  [3-2 pen]
ITA - FRA  3-4  [3-2p]
ITA - FRA  3-4  [agg 6-4]
ITA - FRA  3-4  [agg 5-5; ITA wins on away goals]
ITA - FRA  5-5  [ITA wins on pens]
ITA - FRA  5-5  [ITA wins on penalties]


ITA  1-1  FRA  [aet]
ITA  2-2  FRA  [aet; ITA wins 4-3 on pens]
ITA  4-4  FRA  [aet; 4-3 pen]
ITA  4-4  FRA  [aet, 4-3p]
ITA  3-4  FRA  [3-2 pen]
ITA  3-4  FRA  [3-2p]
ITA  3-4  FRA  [agg 6-4]
ITA  3-4  FRA  [agg 5-5; ITA wins on away goals]
ITA  5-5  FRA  [ITA wins on pens]
ITA  5-5  FRA  [ITA wins on penalties]


ITA  1-1  FRA  [aet]   @ Roma, Italy


### check  round outline   and geo with geo sep

» 1st Round
» 2nd Round

» Regular Season - 1
» Regular Season - 2


Liverpool Montevideo (URU) v Universidad Catolica (ECU)   @ Parque Alfredo Víctor Viera › Montevideo
Cesar Vallejo (PER) v Caracas FC (VEN)    @ Estadio Monumental › Lima


### check internationals
[Wed Mar 28]
  Iraq - Qatar  1-1   @ Muscat, Oman   [Iraq wins on penalties]


TXT


   
parser = RaccMatchParser.new( txt, debug: true )
tree, errors = parser.parse_with_errors
pp tree

if errors.size > 0
   puts "!! #{errors.size} parse error(s):"
   pp errors
end


puts "bye"

