
module SportDb
  module Import
    class Configuration

      attr_reader   :lang
      def lang=(value)
        ## check/todo: always use to_sym - why? needed?
        DateFormats.lang  = value
        ScoreFormats.lang = value
      end

      ## lets you use
      ##   SportDb.configure do |config|
      ##      config.lang = 'it'
      ##   end

    def self.configure()  yield( config ); end

    end # class Configuration
    def self.config()  @config ||= Configuration.new;  end
  end
end



module Sports

## lets you use
##   Sports.configure do |config|
##      config.lang = 'it'
##   end

## note: just forward to SportDb::Import configuration!!!!!
##  keep Sports module / namespace "clean"
##    that is, only include data structures (e.g. Match,League,etc) for now - why? why not?
def self.configure()  yield( config ); end
def self.config()  SportDb::Import.config; end

end   # module Sports
