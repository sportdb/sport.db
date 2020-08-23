## 3rd party gems
require 'alphabets'      # downcase_i18n, unaccent, variants, ...
require 'date/formats'   # DateFormats.parse, find!, ...
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


###
# our own code
require 'sports/version' # let version always go first
require 'sports/config'
require 'sports/season'

require 'sports/name_helper'

require 'sports/structs/country'
require 'sports/structs/league'
require 'sports/structs/team'
require 'sports/structs/round'
require 'sports/structs/group'
require 'sports/structs/goal'
require 'sports/structs/match'
require 'sports/structs/matchlist'
require 'sports/structs/standings'
require 'sports/structs/team_usage'


require 'sports/match_status_parser'
require 'sports/match_parser_csv'
require 'sports/goal_parser_csv'


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

puts SportDb::Module::Sports.banner   # say hello


