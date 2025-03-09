####
#  to run use:
#    $ ruby sandbox/test_lex.rb  



$LOAD_PATH.unshift( './lib' )
require 'sportdb/parser'


txt = read_text( '/sports/openfootball/world.more/2023-24/de.1.txt' )
## txt = read_text( '/sports/openfootball/world.more/2023-24/at.1.txt' )
pp txt
     
  lexer = SportDb::Lexer.new( txt, debug: true )
  tokens, errors = lexer.tokenize_with_errors
  pp tokens

  if errors.size > 0
     puts "!! #{errors.size} tokenize error(s):"
     pp errors
  end


puts "bye"

