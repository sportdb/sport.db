## 3rd party gems
require 'alphabets'       # downcase_i18n, unaccent, variants, ...
require 'date/formats'    # DateFormats.parse, find!, ...
require 'season/formats'  # Season.parse, ...
require 'score/formats'
require 'csvreader'


def read_csv( path, sep:             nil,
                    symbolize_names: nil )
  opts = {}
  opts[:sep]               = sep         if sep
  opts[:header_converters] = :symbol     if symbolize_names

  CsvHash.read( path, **opts )
end

def parse_csv( txt, sep:             nil,
                    symbolize_names: nil )
  opts = {}
  opts[:sep]               = sep         if sep
  opts[:header_converters] = :symbol     if symbolize_names

  CsvHash.parse( txt, **opts )
end



## more sportdb libs/gems
require 'sportdb/langs'


## todo/fix: move shortcut up to sportdb/langs!!!
module SportDb
  Logging = LogUtils::Logging     ## logging machinery shortcut; use LogUtils for now
end

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


## todo/check: move up config to langs too - why? why not?




###
# our own code
require 'sportdb/structs/version' # let version always go first
require 'sportdb/structs/config'  # let "global" config "framework" go next - why? why not?


require 'sportdb/structs/name_helper'

require 'sportdb/structs/structs/country'
require 'sportdb/structs/structs/league'
require 'sportdb/structs/structs/team'
require 'sportdb/structs/structs/round'
require 'sportdb/structs/structs/group'
require 'sportdb/structs/structs/goal'
require 'sportdb/structs/structs/match'
require 'sportdb/structs/structs/matchlist'
require 'sportdb/structs/structs/standings'
require 'sportdb/structs/structs/team_usage'

require 'sportdb/structs/structs/ground'


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




require 'sportdb/structs/match_status_parser'
require 'sportdb/structs/match_parser_csv'
require 'sportdb/structs/goal_parser_csv'




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



module Sports
  ## lets you use
  ##   Sports.configure do |config|
  ##      config.lang = 'it'
  ##   end

  ## note: just forward to SportDb::Import configuration!!!!!
  ##  keep Sports module / namespace "clean"
  ##    that is, only include data structures (e.g. Match,League,etc) for now - why? why not?
  def self.configure()  yield( config ); end
  def self.config()  SportDb::Import.config; end
end   # module Sports



#####
# note: add Sport and Football convenience alias - why? why not?
Sport    = Sports
Football = Sports





puts SportDb::Module::Structs.banner   # say hello


