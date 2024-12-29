
require 'sportdb/quick'



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
require_relative 'writers/goals'
require_relative 'writers/txt_writer'


###
#  fbtxt & friends tools   - remove in future - why? why not?
require 'football/timezones'    ## pulls in read_datasets, etc.



puts SportDb::Module::Writers.banner   # say hello
