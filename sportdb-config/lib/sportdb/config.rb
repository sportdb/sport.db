# encoding: utf-8


require 'pp'
require 'date'
require 'fileutils'


## 3rd party gems
require 'csvreader'

def read_csv( path )
  CsvHash.read( path, :header_converters => :symbol )
end

###
# our own code
require 'sportdb/config/version' # let version always go first

require 'sportdb/config/season_utils'
require 'sportdb/config/league_utils'
require 'sportdb/config/league'
require 'sportdb/config/league_reader'

require 'sportdb/config/variants'
require 'sportdb/config/countries'
require 'sportdb/config/club'
require 'sportdb/config/club_reader'
require 'sportdb/config/club_index'
require 'sportdb/config/wiki_reader'
require 'sportdb/config/wiki_index'
require 'sportdb/config/config'




## let's put test configuration in its own namespace / module
module SportDb

class Test    ## todo/check: works with module too? use a module - why? why not?

  ####
  #  todo/fix:  find a better way to configure shared test datasets - why? why not?
  def self.data_dir()        @data_dir ||= './datasets'; end
  def self.data_dir=( path ) @data_dir = path; end
end

end   # module SportDb



puts SportDb::Boot.banner   # say hello
