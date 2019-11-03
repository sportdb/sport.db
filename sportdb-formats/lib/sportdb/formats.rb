# encoding: utf-8


## 3rd party gems
require 'alphabets'      # downcase_i18n, unaccent, variants, ...
require 'csvreader'

def read_csv( path )
  CsvHash.read( path, :header_converters => :symbol )
end

def parse_csv( txt )
  CsvHash.parse( txt, :header_converters => :symbol )
end


require 'textutils'     # TextUtils::Classifier, ...


###
# our own code
require 'sportdb/formats/version' # let version always go first
require 'sportdb/formats/outline_reader'
require 'sportdb/formats/datafile'
require 'sportdb/formats/season_utils'

require 'sportdb/formats/lang'
require 'sportdb/formats/date'

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


module SportDb
  def self.lang
    # todo/fix: find a better way for single instance ??
    #  will get us ruby warning:  instance variable @lang not initialized   => find a better way!!!
    #   just use @lang w/o .nil?  e.g.
    #  @lang =|| Lang.new   why? why not??  or better use @@lang =|| Lang.new  for class variable!!!
     @lang ||= Lang.new
     @lang
  end
end # module SportDb



puts SportDb::Formats.banner   # say hello
