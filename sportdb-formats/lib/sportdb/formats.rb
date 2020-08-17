# encoding: utf-8


## 3rd party gems
require 'sports'


require 'zip'     ## todo/check: if zip is alreay included in a required module


## more sportdb libs/gems
require 'sportdb/langs'


## todo/fix: move shortcut to sportdb/langs!!!
module SportDb
  Logging = LogUtils::Logging     ## logging machinery shortcut; use LogUtils for now
end



###
# our own code
require 'sportdb/formats/version' # let version always go first

require 'sportdb/formats/config'  # let "global" config "framework" go next - why? why not?

require 'sportdb/formats/outline_reader'
require 'sportdb/formats/datafile'
require 'sportdb/formats/datafile_package'
require 'sportdb/formats/package'


module SportDb
  ## add "old" alias for name helper
  NameHelper = ::Sports::NameHelper
end

require 'sportdb/formats/parser_helper'


module SportDb
  module Import
    Season = ::Season   ## add a convenience alias for top-level Season class

    ## add "old" convenience aliases for structs - why? why not?
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


require 'sportdb/formats/goals'


require 'sportdb/formats/match/match_parser_csv'
require 'sportdb/formats/match/match_status_parser'


module SportDb
  CsvMatchParser = ::Sports::CsvMatchParser
  Status         = ::Sports::Status
  StatusParser   = ::Sports::StatusParser
end

require 'sportdb/formats/match/mapper'
require 'sportdb/formats/match/mapper_teams'
require 'sportdb/formats/match/match_parser'
require 'sportdb/formats/match/match_parser_auto_conf'
require 'sportdb/formats/match/conf_parser'



require 'sportdb/formats/country/country_reader'
require 'sportdb/formats/country/country_index'


## add convenience helper
module SportDb
module Import
class Country
  def self.read( path )  CountryReader.read( path ); end
  def self.parse( txt )  CountryReader.parse( txt ); end
end   # class Country
end   # module Import
end   # module SportDb


require 'sportdb/formats/league/league_reader'
require 'sportdb/formats/league/league_index'
require 'sportdb/formats/league/league_outline_reader'

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


require 'sportdb/formats/team/club_reader'
require 'sportdb/formats/team/club_reader_props'
require 'sportdb/formats/team/club_index'
require 'sportdb/formats/team/wiki_reader'
require 'sportdb/formats/team/national_team_index'
require 'sportdb/formats/team/team_index'

require 'sportdb/formats/team/club_reader_history'
require 'sportdb/formats/team/club_index_history'


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


require 'sportdb/formats/event/event_reader'
require 'sportdb/formats/event/event_index'

## add convenience helper
module SportDb
module Import
class EventInfo
  def self.read( path )  EventInfoReader.read( path ); end
  def self.parse( txt )  EventInfoReader.parse( txt ); end
end   # class EventInfo
end   # module Import
end   # module SportDb










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




puts SportDb::Module::Formats.banner   # say hello
