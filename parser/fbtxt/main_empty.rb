####
#  to run use:
#    $ ruby ./main_empty.rb  (in /fbtxt)


## try empty doc


$LOAD_PATH.unshift( '../lib' )
require 'sportdb/parser'


### check tokenizer - 
#    note -  text input gets preprocessed
##           e.g. removes comments, empty lines etc (by default)!!!!
  puts "tokenize:"
  parser = RaccMatchParser.new( '' )
  pp parser.next_token

  puts "parse:"
  parser = RaccMatchParser.new( '' )
  tree = parser.parse
  pp tree



puts "bye"