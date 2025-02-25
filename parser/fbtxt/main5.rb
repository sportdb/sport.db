####
#  to run use:
#    $ ruby ./main5.rb  (in /fbtxt)



$LOAD_PATH.unshift( '../lib' )
require 'sportdb/parser'


##
##  try new note(s)
##    e.g.  [Uruguay wins on penalties]
##  and try n/a for minutes (find a better syntax - why? why not?)
##       ??'  and    ?? for name




txt = <<-TXT

[Sat Jun 3]
  Republic of St. Pauli - Gibraltar  1-2   @ Hamburg, Germany
  Northern Cyprus - Zanzibar  0-0   @ Hamburg, Germany    [Northern Cyprus wins on penalties]
     Wirtz 0' Musiala ??' Havertz 45+1' (pen.) Wu Xi 54' Sun Ke 68'; 
     Rüdiger 87' (o.g.)


## try n/a (NA) for minutes (??') - find a better syntax 
##                 e.g.  --' or __' or  0' or 00'

### try
###   Copa América 1979 @ https://www.rsssf.org/tables/79safull.html
###
###  todo - support 08.08.1979 and 1979.08.08 too ???


1979-08-08  @ San Cristóbal, Pueblo Nuevo 

VEN - CHI   1-1 (0-0)

## 1-0 Carvajal 70',  1-1 Peredo 81'

##  (14,000) César Pagano PER 

###  fix - make minute optional!!!

VEN: Vega - Contreras, Castro, Vidal, Campos - Mendoza, Páez, Sánchez - 
     Peña (Santana 0'), Carvajal, Hernández (Castillo 0')
CHI: Osbén - González, Valenzuela, Soto, Escobar - Rivas (Quiroz 0'), Dubó, Neira - 
     Yáñez, Peredo, Véliz

# VEN: Vega - Contreras, Castro, Vidal, Campos - Mendoza, Páez, Sánchez - 
#      Peña (Santana), Carvajal, Hernández (Castillo)
# CHI: Osbén - González, Valenzuela, Soto, Escobar - Rivas (Quiroz), Dubó, Neira - 
#     Yáñez, Peredo, Véliz


# 02.08.79 Río de Janeiro, Maracaná 
1979-08-02  @  Río de Janeiro, Maracaná 

BRA v ARG  2-1 (1-1) 

## (130,000) Edison Pérez PER 

BRA: Leão - Toninho, Amaral, Edinho, Pedrinho - Carpeggiani, Zenon (Batista 0'), Tita -
     Palinha (Juan 0'), Zico, Zé Sergio 
ARG: Vidallé - Barbas, Van Tuyne, Passarella, Bordón - Gáspari, Larraquy, Gaitán (López 46') -
     Coscia, Maradona, Díaz (Castro 62')

# 1-0 Zico 2', 1-1 Coscia 29', 2-1 Tita 54'



TXT



  parser = RaccMatchParser.new( txt, debug: true )
  tree, errors = parser.parse_with_errors
  pp tree

  if errors.size > 0
     puts "!! #{errors.size} parse error(s):"
     pp errors
  end


puts "bye"

