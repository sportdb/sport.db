# encoding: utf-8


require 'date'
require 'fileutils'


## 3rd party gems
require 'alphabets'      # downcase_i18n, unaccent, variants, ...


##   todo/fix: move csvreader to sportdb-config - why? why not?

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
  attr_accessor :alt_names

  def initialize( key, name, fifa )
    @key, @name, @fifa = key, name, fifa
    @alt_names      = []
  end

  ## add csv-like access by hash key for compatibility
  def []( key ) send( key ); end


  ###################################
  # "global" helper - move to ___ ? why? why not?
  ##   todo/fix: use shared helpers for country, club, etc. (do NOT duplicate)!!!
  YEAR_REGEX = /\([0-9,\- ]+?\)/
  def self.strip_year( name )
    ## check for year(s) e.g. (1887-1911), (-2013),
    ##                        (1946-2001, 2013-) etc.
    name.gsub( YEAR_REGEX, '' ).strip
  end

  def self.has_year?( name ) name =~ YEAR_REGEX; end

  LANG_REGEX = /\[[a-z]{1,2}\]/   ## note also allow [a] or [d] or [e] - why? why not?
  def self.strip_lang( name )
    name.gsub( LANG_REGEX, '' ).strip
  end

  def self.has_lang?( name ) name =~ LANG_REGEX; end


   NORM_REGEX =  /[.'º\-\/]/
   ## note: remove all dots (.), dash (-), ', º, /, etc.
   ##         for norm(alizing) names
   def self.strip_norm( name )
     name.gsub( NORM_REGEX, '' )
   end

   def self.normalize( name )
     # note: do NOT call sanitize here (keep normalize "atomic" for reuse)

     ## remove all dots (.), dash (-), º, /, etc.
     name = strip_norm( name )
     name = name.gsub( ' ', '' )  # note: also remove all spaces!!!

     ## todo/fix: use our own downcase - why? why not?
     name = downcase_i18n( name )     ## do NOT care about upper and lowercase for now
     name
   end
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
