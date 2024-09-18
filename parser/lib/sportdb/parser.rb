## pulls in
require 'cocos'
require 'season/formats'  # e.g. Season() support machinery


## more stdlibs
require 'optparse'   ## check - already auto-required in cocos? keep? why? why not?



####
# try a (simple) tokenizer/parser with regex

## note - match line-by-line
#            avoid massive backtracking by definition
#             that is, making it impossible

## sym(bols) -
##  text - change text to name - why? why not?


require_relative 'parser/version'
require_relative 'parser/token-score'
require_relative 'parser/token-date'
require_relative 'parser/token-text'
require_relative 'parser/token'
require_relative 'parser/lang'
require_relative 'parser/parser'


####
##  todo/check - move outline reader upstream to cocos - why? why not?
##       use  read_outline(), parse_outline()  - why? why not?
require_relative 'parser/outline_reader'


require_relative 'parser/opts'
require_relative 'parser/linter'
require_relative 'parser/fbtok/main'


###
#  make parser api (easily) available - why? why not?

=begin
module SportDb
   def self.parser() @@parser ||= Parser.new; end
   def self.parse( ... )
   end
   def self.tokenize( ... )
   end
end  # module SportDb
=end


puts SportDb::Module::Parser.banner    # say hello

