# encoding: utf-8


require 'pp'
require 'date'
require 'fileutils'


## 3rd party gems
require 'csvreader'

def read_csv( path )
  CsvHash.read( path, :header_converters => :symbol )
end

def parse_csv( txt )
  CsvHash.parse( txt, :header_converters => :symbol )
end



###
# our own code
require 'sportdb/countries/version' # let version always go first


module SportDb
module Import

##
#  note: use our own (internal) country struct for now - why? why not?
#    - check that shape/structure/fields/attributes match
#      the Country struct in sportdb-text (in SportDb::Struct::Country)
##       and the ActiveRecord model !!!!
class Country
  ## note: is read-only/immutable for now - why? why not?
  ##          add cities (array/list) - why? why not?
  attr_reader :key, :name, :fifa
  def initialize( key, name, fifa )
    @key, @name, @fifa = key, name, fifa
  end

  ## add csv-like access by hash key for compatibility
  def []( key ) send( key ); end
end  # class Country



end   # module Import
end   # module SportDb


require 'sportdb/countries/country_reader'
require 'sportdb/countries/country_index'




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



puts SportDb::Countries.banner   # say hello
