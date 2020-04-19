# encoding: utf-8

require 'sportdb/formats'


###
# our own code
require 'sportdb/countries/version' # let version always go first
require 'sportdb/countries/country_reader'
require 'sportdb/countries/country_index'



## add convenience helper
module SportDb
module Import
class Country
  def self.read( path )  CountryReader.read( path ); end
  def self.parse( txt )  CountryReader.parse( txt ); end
end   # class Country
end   # module Import
end   # module SportDb



puts SportDb::Countries.banner   # say hello
