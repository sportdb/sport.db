## 3rd party gems
require 'alphabets'       # downcase_i18n, unaccent, variants, ...
require 'season/formats'  # Season.parse, ...
require 'score/formats'



require 'logutils'     ## note: requires (stdlibs) pp, yaml, etc.


## note -  add cocos (code commons)
##
##  pulls in read_csv & parse_csv etc.
require 'cocos'





module SportDb
  ## logging machinery shortcut; use LogUtils for now
  Logging = LogUtils::Logging
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




###
# our own code
require_relative 'structs/version' # let version always go first
require_relative 'structs/config'  # let "global" config "framework" go next - why? why not?


require_relative 'structs/name_helper'

require_relative 'structs/structs/country'
require_relative 'structs/structs/league'
require_relative 'structs/structs/team'
require_relative 'structs/structs/round'
require_relative 'structs/structs/group'
require_relative 'structs/structs/goal'
require_relative 'structs/structs/match'
require_relative 'structs/structs/matchlist'
require_relative 'structs/structs/standings'
require_relative 'structs/structs/team_usage'

require_relative 'structs/structs/ground'


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




require_relative 'structs/match_status_parser'
require_relative 'structs/match_parser_csv'
require_relative 'structs/goal_parser_csv'




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
  ##      config.catalog_path = './catalog.db'
  ##   end

  ## note: just forward to SportDb::Import configuration!!!!!
  ##  keep Sports module / namespace "clean" - why? why not?
  ##    that is, only include data structures (e.g. Match,League,etc) for now - why? why not?
  def self.configure()  yield( config ); end
  def self.config()  SportDb::Import.config; end
end   # module Sports



#####
# note: add Sport and Football convenience alias - why? why not?
Sport    = Sports
Football = Sports





puts SportDb::Module::Structs.banner   # say hello

