require 'sportdb/structs'  # deps:  score-foramts
                           #         season-formats
                           #         alphabets
require 'sportdb/parser'   # deps:   cocos
                           #         season-formats



require 'logutils'
module SportDb
  ## logging machinery shortcut; use LogUtils for now
  Logging = LogUtils::Logging
end



## our own code
require_relative 'quick/version'
require_relative 'quick/opts'
require_relative 'quick/linter'
require_relative 'quick/outline_reader'

require_relative 'quick/match_parser'

require_relative 'quick/quick_league_outline_reader'
require_relative 'quick/quick_match_reader'




###
#  csv (tabular dataset) support / machinery
require_relative 'quick/csv/match_status_parser'
require_relative 'quick/csv/goal'
require_relative 'quick/csv/goal_parser_csv'
require_relative 'quick/csv/match_parser_csv'


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



puts SportDb::Module::Quick.banner    # say hello


