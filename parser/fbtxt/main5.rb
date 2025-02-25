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
     Wirtz 0' Musiala ??' Havertz 45+1' (pen.) Füllkrug 68' Can 90+3'; 
     Rüdiger 87' (o.g.)


## try n/a (NA) for minutes (??') - find a better syntax 
##                 e.g.  --' or __' or  0' or 00'

TXT



  parser = RaccMatchParser.new( txt, debug: true )
  tree, errors = parser.parse_with_errors
  pp tree

  if errors.size > 0
     puts "!! #{errors.size} parse error(s):"
     pp errors
  end


puts "bye"

