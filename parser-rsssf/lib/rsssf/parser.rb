
####
##  build on "standard" parse
require 'sportdb/parser'
## pulled in for/uses only
##  -  SportDb::Parser::Tokens  !!!
##  
##  plus in the future pull in SportDb::OutlineReader
##
##  note - pulls in more deps e.g. cococs AND season-formats



## our own code
require_relative 'parser/version'
require_relative 'parser/token-text'
require_relative 'parser/token-note'
require_relative 'parser/token-round'    ## round (& group)
require_relative 'parser/token-date'
require_relative 'parser/token-score'
require_relative 'parser/token-goals'
require_relative 'parser/token'

require_relative 'parser/parser'

require_relative 'parser/linter'



# say hello
puts SportDb::Module::RsssfParser.banner