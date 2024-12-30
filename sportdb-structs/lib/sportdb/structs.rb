## 3rd party gems
require 'alphabets'       # unaccent, downcase_i18n, variants, ...
require 'season/formats'  # Season.parse, ...
require 'score/formats'

require 'cocos'    # pull-in for read_csv & more


###
# our own code
require_relative 'structs/version' # let version always go first

## shared support helpers/machinery
require_relative 'structs/name_helper'

require_relative 'structs/country'
require_relative 'structs/league'
require_relative 'structs/team'
require_relative 'structs/ground'
require_relative 'structs/round'
require_relative 'structs/group'
require_relative 'structs/goal'
require_relative 'structs/match'

require_relative 'structs/matchlist'
require_relative 'structs/standings'
require_relative 'structs/team_usage'

require_relative 'structs/event_info'



##
## todo/fix  - move "inline" player to structs/player file !!!!

module Sports
### note - own classes for National(Squad)Player and
##                        Club(Squad)Player and such in use

class Player
  attr_reader :name,
              :pos,      # position (g/d/m/f) for now
              :nat,      # nationality
              :height,   # in cm!! (integer) expected
              :birthdate,
              :birthplace

  attr_accessor :alt_names

def initialize( name:,
                pos:    nil,
                nat:    nil,
                height: nil,
                birthdate: nil,
                birthplace: nil )
    @name       = name
    @alt_names  = []
    @pos        = pos
    @nat        = nat
    @height     = height
    @birthdate  = birthdate
    @birthplace = birthplace
end
end  # class Player
end  # module Sports






##
##  add all structs in SportDb::Import namespace too
module SportDb
  module Import
    Season = ::Season   ## add a convenience alias for top-level Season class

    ## add "old" convenience aliases for structs - why? why not?
    ##   todo/check: just use include Sports !!!!
    Country      = ::Sports::Country
    City         = ::Sports::City

    League       = ::Sports::League
    LeaguePeriod = ::Sports::LeaguePeriod
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
  end   # module Import
end     # module SportDb




###
#  csv (tabular dataset) support / machinery
require_relative 'csv/match_status_parser'
require_relative 'csv/goal'
require_relative 'csv/goal_parser_csv'
require_relative 'csv/match_parser_csv'


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




#####
# note: add Sport and Football convenience alias - why? why not?
Sport    = Sports
Football = Sports


puts SportDb::Module::Structs.banner   # say hello

