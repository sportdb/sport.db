
require 'sportdb/quick'


require 'optparse'    ## command-line processing; check if included updstream?



module Writer
  class Configuration
     def out_dir()        @out_dir   || './tmp'; end
     def out_dir=(value)  @out_dir = value; end
     ## add outdir alias - why? why not?
  end # class Configuration

  ## lets you use
  ##   Write.configure do |config|
  ##      config.out_dir = "??"
  ##   end
  def self.configure()  yield( config ); end
  def self.config()  @config ||= Configuration.new;  end
end   # module Writer



###
# our own code
require_relative 'writers/version'

## setup  leagues (info) table
require_relative 'writers/league_config'

module Writer
  LEAGUES = SportDb::LeagueConfig.new

  ['leagues',
  ].each do |name|
    recs = read_csv( "#{SportDb::Module::Writers.root}/config/#{name}.csv" )
    LEAGUES.add( recs )
  end
end  # module Writer


require_relative 'writers/goals'
require_relative 'writers/txt_writer'


###
#  fbtxt tool
require 'football/timezones'    ## pulls in read_datasets, etc.

require_relative 'fbgen/main'




puts SportDb::Module::Writers.banner   # say hello
