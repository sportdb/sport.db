require 'sportdb/structs'  # deps:  score-foramts
                           #         season-formats
                           #         alphabets
require 'sportdb/parser'   # deps:   cocos
                           #         season-formats



require 'logutils'
module SportDb
  ## logging machinery shortcut; use LogUtils for now
  Logging = LogUtils::Logging
end



## our own code
require_relative 'quick/version'

## "generic" outline readers, documents & more
##
##  todo/check - move outline reader upstream to cocos - why? why not?
##       use  read_outline(), parse_outline()  - why? why not?
require_relative 'quick/outline_reader'
require_relative 'quick/outline'

##  match & league machinery
require_relative 'quick/match_parser'

require_relative 'quick/quick_league_outline'
require_relative 'quick/quick_match_reader'



puts SportDb::Module::Quick.banner    # say hello


