## 3rd party gems
require 'sportdb/structs'
require 'sportdb/parser'


require 'zip'     ## todo/check: if zip is alreay included in a required module






###
# our own code
require_relative 'formats/version' # let version always go first

require_relative 'formats/datafile'
require_relative 'formats/datafile_package'
require_relative 'formats/package'



###
# define search services apis  (move to its own gem later - why? why not?)

module SportDb
module Import

class Configuration
  ## note: add more configs (open class), see sportdb-structs for original config!!!

  ## add
  def world()        @world ||= WorldSearch.new( countries: DummyCountrySearch.new ); end
  def world=(world)  @world = world; end

  ## tood/fix - add/move catalog here from   sportdb-catalogs!!!
  ## def catalog()         @catalog ||= Catalog.new;  end
  ## def catalog(catalog)  @catalog = catalog; end
end # class Configuration

  ##  e.g. use config.catalog  -- keep Import.catalog as a shortcut (for "read-only" access)
  ## def self.catalog() config.catalog;  end
  def self.world()   config.world;    end
end   # module Import
end   # module SportDb

require_relative 'formats/search/world'
require_relative 'formats/search/sport'
require_relative 'formats/search/structs'





module SportDb
  module Import
    Season = ::Season   ## add a convenience alias for top-level Season class

    ## add "old" convenience aliases for structs - why? why not?
    ##   todo/check: just use include Sports !!!!
    Country      = ::Sports::Country
    League       = ::Sports::League
    Group        = ::Sports::Group
    Round        = ::Sports::Round
    Match        = ::Sports::Match
    Matchlist    = ::Sports::Matchlist
    Goal         = ::Sports::Goal
    Team         = ::Sports::Team
    NationalTeam = ::Sports::NationalTeam
    Club         = ::Sports::Club
    Standings    = ::Sports::Standings
    TeamUsage    = ::Sports::TeamUsage

    Ground       = ::Sports::Ground

    Player       = ::Sports::Player


    class Team
      ## add convenience lookup helper / method for name by season for now
      ##   use clubs history - for now kept separate from struct - why? why not?
      def name_by_season( season )
        ## note: returns / fallback to "regular" name if no records found in history
        SportDb::Import.catalog.clubs_history.find_name_by( name: name, season: season ) || name
      end
    end  # class Team

  end   # module Import
end     # module SportDb


require_relative 'formats/match/match_parser'
require_relative 'formats/match/conf_parser'



require_relative 'formats/country/country_reader'


## add convenience helper
module SportDb
module Import
class Country
  def self.read( path )  CountryReader.read( path ); end
  def self.parse( txt )  CountryReader.parse( txt ); end
end   # class Country
end   # module Import
end   # module SportDb


require_relative 'formats/league/league_reader'
require_relative 'formats/league/league_outline_reader'

##
## add convenience helper / short-cuts
module SportDb
module Import
class League
  def self.read( path ) LeagueReader.read( path ); end
  def self.parse( txt ) LeagueReader.parse( txt ); end
end   # class League
end   # module Import
end   # module SportDb


require_relative 'formats/team/club_reader'
require_relative 'formats/team/club_reader_props'
require_relative 'formats/team/wiki_reader'

require_relative 'formats/team/club_reader_history'
require_relative 'formats/team/club_index_history'


###
# add convenience helpers / shortcuts
module SportDb
  module Import

class Club
  def self.read( path )  ClubReader.read( path ); end
  def self.parse( txt )  ClubReader.parse( txt ); end

  def self.read_props( path )  ClubPropsReader.read( path ); end
  def self.parse_props( txt )  ClubPropsReader.parse( txt ); end
  ##  todo/check: use ClubProps.read and ClubProps.parse convenience alternate shortcuts - why? why not?
end # class Club

end   # module Import
end   # module SportDb


require_relative 'formats/event/event_reader'

## add convenience helper
module SportDb
module Import
class EventInfo
  def self.read( path )  EventInfoReader.read( path ); end
  def self.parse( txt )  EventInfoReader.parse( txt ); end
end   # class EventInfo
end   # module Import
end   # module SportDb



require_relative 'formats/ground/ground_reader'



puts SportDb::Module::Formats.banner   # say hello
