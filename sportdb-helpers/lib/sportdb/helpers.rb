## note - dependes on sportdb/structs and
##                    sportdb/search  (pulls in structs et al)
require 'sportdb/search'


##
## todo/fix - move  OutlineReader to cocos!!
##                  use read_outline/parse_outline - why? why not?
###   now in sportdb/parser
require 'sportdb/parser'


## more
require 'logutils'
module SportDb
  ## logging machinery shortcut; use LogUtils for now
  Logging = LogUtils::Logging
end



## our own code
require_relative 'helpers/country_reader'
require_relative 'helpers/ground_reader'
require_relative 'helpers/league_reader'






