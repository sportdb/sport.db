####
#  to run use:
#    $ ruby ./main5_lex.rb  (in /fbtxt)



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
 
  Northern Cyprus - Zanzibar  0-0   @ Hamburg, Germany   
  
  Austria - Rapid
  
  xxx

#  yyyy  Wu Xi 54'
#  zzzz  Sun Ke   68'

  Wirtz 0' Musiala ??' Havertz 45+1' (pen.) Wu Xi 54' Sun Ke 68'; 
     Rüdiger 87' (o.g.)

 [Wirtz 0' Musiala ??' Havertz 45+1' (pen.) Wu Xi 54' Sun Ke 68'; 
     Rüdiger 87' (o.g.)]


### try props

  Germany:    Neuer - Kimmich, Rüdiger, Tah [Y], Mittelstädt - Andrich [Y] (Groß 46'),
              Kroos (Can 80') - Musiala (Müller 74'), Gündogan, Wirtz (Sane 63') - 
              Havertz (Füllkrug 63')

TXT


     
  lexer = SportDb::Lexer.new( txt, debug: true )
  tokens, errors = lexer.tokenize_with_errors
  pp tokens

  if errors.size > 0
     puts "!! #{errors.size} tokenize error(s):"
     pp errors
  end


puts "bye"

