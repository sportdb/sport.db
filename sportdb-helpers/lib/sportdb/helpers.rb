## note - dependes on sportdb/structs and
##                    sportdb/search  (pulls in structs et al)
require 'sportdb/search'


##
## todo/fix - move  OutlineReader to cocos!!
##                  use read_outline/parse_outline - why? why not?
###   now in sportdb/parser
##   note - keep for now
##     added SportDb::Parser.parse_date( str, start: ) helper!!!
##      to replace DateFormats
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
module Sports
  class Country
    def self.read( path )  SportDb::Import::CountryReader.read( path ); end
    def self.parse( txt )  SportDb::Import::CountryReader.parse( txt ); end
  end   # class Country

  class League
    def self.read( path )  SportDb::Import::LeagueReader.read( path ); end
    def self.parse( txt )  SportDb::Import::LeagueReader.parse( txt ); end
  end   # class League

  class Club
    def self.read( path )  SportDb::Import::ClubReader.read( path ); end
    def self.parse( txt )  SportDb::Import::ClubReader.parse( txt ); end

    def self.read_props( path )  SportDb::Import::ClubPropsReader.read( path ); end
    def self.parse_props( txt )  SportDb::Import::ClubPropsReader.parse( txt ); end
    ##  todo/check: use ClubProps.read and ClubProps.parse convenience alternate shortcuts - why? why not?
  end # class Club

  class EventInfo
    def self.read( path )  SportDb::Import::EventInfoReader.read( path ); end
    def self.parse( txt )  SportDb::Import::EventInfoReader.parse( txt ); end
  end   # class EventInfo
end   # module SportDb





puts SportDb::Module::Helpers.banner   # say hello

