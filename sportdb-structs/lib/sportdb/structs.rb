## 3rd party gems
require 'alphabets'       # unaccent, downcase_i18n, variants, ...
require 'season/formats'  # Season.parse, ...
require 'score/formats'


###
# our own code
require_relative 'structs/version' # let version always go first

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




#####
# note: add Sport and Football convenience alias - why? why not?
Sport    = Sports
Football = Sports




puts SportDb::Module::Structs.banner   # say hello

