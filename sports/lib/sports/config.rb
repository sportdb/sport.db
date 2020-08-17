
module Sports

class Configuration

  attr_reader   :lang
  def lang=(value)
    ## check/todo: always use to_sym - why? needed?
    DateFormats.lang  = value
    ScoreFormats.lang = value
  end

end # class Configuration


## lets you use
##   Sports.configure do |config|
##      config.lang = 'it'
##   end

def self.configure()  yield( config ); end

def self.config()  @config ||= Configuration.new;  end

end   # module Sports
