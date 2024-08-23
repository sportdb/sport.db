## 3rd party gems
require 'sportdb/structs'
require 'sportdb/parser'
require 'date/formats'


require 'zip'     ## todo/check: if zip is alreay included in a required module


## note -  add cocos (code commons)
##
##  pulls in read_csv & parse_csv etc.
require 'cocos'


require 'logutils'
module SportDb
  ## logging machinery shortcut; use LogUtils for now
  Logging = LogUtils::Logging
end




###
# our own code
require_relative 'formats/version' # let version always go first

require_relative 'formats/datafile'
require_relative 'formats/datafile_package'
require_relative 'formats/package'



## let's put test configuration in its own namespace / module
module SportDb
  class Test    ## todo/check: works with module too? use a module - why? why not?

    ####
    #  todo/fix:  find a better way to configure shared test datasets - why? why not?
    #    note: use one-up (..) directory for now as default - why? why not?
    def self.data_dir()        @data_dir ||= '../test'; end
    def self.data_dir=( path ) @data_dir = path; end
  end
end   # module SportDb



###
# define search services apis  (move to its own gem later - why? why not?)

module SportDb
module Import

class Configuration
  def world()        @world ||= WorldSearch.new( countries: DummyCountrySearch.new ); end
  def world=(world)  @world = world; end

  ## todo/fix - add/move catalog here from   sportdb-catalogs!!!
  ## def catalog()         @catalog ||= Catalog.new;  end
  ## def catalog(catalog)  @catalog = catalog; end
end # class Configuration

  ##  e.g. use config.catalog  -- keep Import.catalog as a shortcut (for "read-only" access)
  ## def self.catalog() config.catalog;  end
  def self.world()   config.world;    end

  ## lets you use
  ##   SportDb::Import.configure do |config|
  ##      config.catalog_path = './catalog.db'
  ##   end
def self.configure()  yield( config ); end
def self.config()  @config ||= Configuration.new;  end
end   # module Import
end   # module SportDb


require_relative 'formats/search/world'
require_relative 'formats/search/sport'
require_relative 'formats/search/structs'



module Sports
  ## note: just forward to SportDb::Import configuration!!!!!
  ##  keep Sports module / namespace "clean" - why? why not?
  ##    that is, only include data structures (e.g. Match,League,etc) for now - why? why not?
  def self.configure()  yield( config ); end
  def self.config()  SportDb::Import.config; end
end   # module Sports


###
#  csv (tabular dataset) support / machinery
require_relative 'formats/csv/match_status_parser'
require_relative 'formats/csv/goal'
require_relative 'formats/csv/goal_parser_csv'
require_relative 'formats/csv/match_parser_csv'


### add convenience shortcut helpers
module Sports
  class Match
    def self.read_csv( path, headers: nil, filters: nil, converters: nil, sep: nil )
       SportDb::CsvMatchParser.read( path,
                                       headers:    headers,
                                       filters:    filters,
                                       converters: converters,
                                       sep:        sep )
    end

    def self.parse_csv( txt, headers: nil, filters: nil, converters: nil, sep: nil )
       SportDb::CsvMatchParser.parse( txt,
                                        headers:    headers,
                                        filters:    filters,
                                        converters: converters,
                                        sep:        sep )
    end
  end # class Match
end # module Sports








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

    EventInfo    = ::Sports::EventInfo


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





### auto-configure builtin lookups via catalog.db(s)
require 'sportdb/catalogs'


module SportDb
module Import

class Configuration
  ## note: add more configs (open class), see sportdb-structs for original config!!!

  ###
  #  find a better name for setting - why? why not?
  #     how about catalogdb or ???
  attr_reader   :catalog_path
  def catalog_path=(path)
      @catalog_path = path
      ########
      # reset database here to new path
      CatalogDb::Metal::Record.database = path

      ##  plus automagically set world search too (to use CatalogDb)
      self.world = WorldSearch.new(
                          countries: CatalogDb::Metal::Country,
                          cities:    CatalogDb::Metal::City,
                        )

      @catalog_path
  end

  def catalog
       @catalog ||= SportSearch.new(
                           leagues:        CatalogDb::Metal::League,
                           national_teams: CatalogDb::Metal::NationalTeam,
                           clubs:          CatalogDb::Metal::Club,
                           grounds:        CatalogDb::Metal::Ground,
                           events:         CatalogDb::Metal::EventInfo,
                           players:        CatalogDb::Metal::Player,    # note - via players.db !!!
                        )
  end

  ###
  #  find a better name for setting - why? why not?
  #     how about playersdb or ???
  attr_reader   :players_path
  def players_path=(path)
      @players_path = path
      ########
      # reset database here to new path
      CatalogDb::Metal::PlayerRecord.database = path

      @players_path
  end
end # class Configuration


  ##  e.g. use config.catalog  -- keep Import.catalog as a shortcut (for "read-only" access)
  def self.catalog() config.catalog;  end
end   # module Import
end   # module SportDb


###
## add default/built-in catalog here - why? why not?
##  todo/fix  - set catalog_path on demand
##   note:  for now required for world search setup etc.
SportDb::Import.config.catalog_path = "#{FootballDb::Data.data_dir}/catalog.db"



puts SportDb::Module::Formats.banner   # say hello
