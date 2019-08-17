# encoding: utf-8


require 'pp'
require 'date'
require 'fileutils'


## 3rd party gems
require 'csvreader'

def read_csv( path )
  CsvHash.read( path, :header_converters => :symbol )
end


require 'fifa'    ## get a list of all fifa countries with (three letter) codes


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




puts SportDb::Boot.banner   # say hello
