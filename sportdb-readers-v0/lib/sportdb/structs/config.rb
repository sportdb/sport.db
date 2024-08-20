module SportDb
module Import

class Configuration
  ##
  ##  todo: allow configure of countries_dir like clubs_dir
  ##         "fallback" and use a default built-in world/countries.txt

  ##  note: catalog defined/added in sports-catalogs gem!!!
  ## attr_accessor   :catalog

  attr_reader   :lang
  def lang=(value)
    ## check/todo: always use to_sym - why? needed?
    DateFormats.lang  = value
    ScoreFormats.lang = value
  end

end # class Configuration


## lets you use
##   SportDb::Import.configure do |config|
##      config.lang = 'it'
##   end
def self.configure()  yield( config ); end

def self.config()  @config ||= Configuration.new;  end


end   # module Import
end   # module SportDb

