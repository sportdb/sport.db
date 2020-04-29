# encoding: utf-8

module SportDb
  module Import

class Configuration
  ##
  ##  todo: allow configure of countries_dir like clubs_dir
  ##         "fallback" and use a default built-in world/countries.txt

  ####
  #  todo/check:  find a better way to configure club / team datasets - why? why not?
  attr_accessor   :clubs_dir
  def clubs_dir()      @clubs_dir; end   ### note: return nil if NOT set on purpose for now - why? why not?

  attr_accessor   :leagues_dir
  def leagues_dir()    @leagues_dir; end
end # class Configuration


## lets you use
##   SportDb::Import.configure do |config|
##      config.hello = 'World'
##   end

def self.configure()  yield( config ); end

def self.config()  @config ||= Configuration.new;  end


def self.catalog() @catalog ||= Catalog.new;  end

end   # module Import
end   # module SportDb
