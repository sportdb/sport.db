## 3rd party gems
# require 'sportdb/structs'
# require 'sportdb/parser'
require 'sportdb/quick'


require 'zip'     ## todo/check: if zip is alreay included in a required module



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



require_relative 'formats/txt/league_outline_reader'
require_relative 'formats/txt/conf_parser'
require_relative 'formats/txt/quick_match_linter'


# require_relative 'formats/team/club_reader_history'
# require_relative 'formats/team/club_index_history'



### auto-configure builtin lookups via catalog.db(s)
require 'sportdb/search'



puts SportDb::Module::Formats.banner   # say hello
