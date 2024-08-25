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
require 'sportdb/search'



puts SportDb::Module::Formats.banner   # say hello
