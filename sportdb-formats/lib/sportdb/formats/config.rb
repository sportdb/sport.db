# encoding: utf-8

module SportDb
  module Import

class Configuration
  ##
  ##  todo: allow configure of countries_dir like clubs_dir
  ##         "fallback" and use a default built-in world/countries.txt

  attr_accessor   :catalog

  attr_reader   :lang
  def lang=(value)
    ## check/todo: always use to_sym - why? needed?
    DateFormats.lang  = value
    ScoreFormats.lang = value
    SportDb.lang.lang = value

    ## todo/fix:  change SportDb.lang to SportDb.parser.lang or lang_parser or utils or someting !!!!
    ##   use Sport.lang only as a read-only shortcut a la catalog for config.lang!!!!
  end

end # class Configuration


## lets you use
##   SportDb::Import.configure do |config|
##      config.lang = 'it'
##   end

def self.configure()  yield( config ); end

def self.config()  @config ||= Configuration.new;  end

##  e.g. use config.catalog  -- keep Import.catalog as a shortcut (for "read-only" access)
def self.catalog() config.catalog;  end

end   # module Import
end   # module SportDb
