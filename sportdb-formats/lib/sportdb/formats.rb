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

require_relative 'formats/package'
require_relative 'formats/datafile_package'



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



require_relative 'formats/txt/league_outline_reader'
require_relative 'formats/txt/match_parser'
require_relative 'formats/txt/conf_parser'


# require_relative 'formats/team/club_reader_history'
# require_relative 'formats/team/club_index_history'



### auto-configure builtin lookups via catalog.db(s)
require 'sportdb/search'



puts SportDb::Module::Formats.banner   # say hello
