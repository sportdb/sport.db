## note - dependes on sportdb/structs and
##                    sportdb/search  (pulls in structs et al)
require 'sportdb/search'

require 'date/formats'   ## remove? - see use in event info
                         ##  or add upstream - why? why not?


##
## todo/fix - move  OutlineReader to cocos!!
##                  use read_outline/parse_outline - why? why not?
###   now in sportdb/parser
require 'sportdb/parser'


## note -  add cocos (code commons)
##
##  pulls in read_csv & parse_csv etc.
require 'cocos'



## more
require 'logutils'
module SportDb
  ## logging machinery shortcut; use LogUtils for now
  Logging = LogUtils::Logging
end



## our own code
require_relative 'helpers/version'
require_relative 'helpers/country_reader'
require_relative 'helpers/ground_reader'
require_relative 'helpers/league_reader'
require_relative 'helpers/club_reader'
require_relative 'helpers/club_reader_props'
require_relative 'helpers/club_reader_history'
require_relative 'helpers/wiki_reader'
require_relative 'helpers/event_reader'



###
## add convenience helper / short-cuts
module SportDb
module Import
  class Country
    def self.read( path )  CountryReader.read( path ); end
    def self.parse( txt )  CountryReader.parse( txt ); end
  end   # class Country

  class League
    def self.read( path )  LeagueReader.read( path ); end
    def self.parse( txt )  LeagueReader.parse( txt ); end
  end   # class League

  class Club
    def self.read( path )  ClubReader.read( path ); end
    def self.parse( txt )  ClubReader.parse( txt ); end

    def self.read_props( path )  ClubPropsReader.read( path ); end
    def self.parse_props( txt )  ClubPropsReader.parse( txt ); end
    ##  todo/check: use ClubProps.read and ClubProps.parse convenience alternate shortcuts - why? why not?
  end # class Club

  class EventInfo
    def self.read( path )  EventInfoReader.read( path ); end
    def self.parse( txt )  EventInfoReader.parse( txt ); end
  end   # class EventInfo
end   # module Import
end   # module SportDb





puts SportDb::Module::Helpers.banner   # say hello

