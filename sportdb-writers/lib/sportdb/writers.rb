
require 'sportdb/structs'


##
### todo/fix - add SportDb namespace for config? why? why not?
##     check where used?
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



module SportDb
class TxtMatchWriter
  def self.write( path, matches, name:, rounds: true)

    buf = build( matches, rounds: rounds )
  
    ## for convenience - make sure parent folders/directories exist
    FileUtils.mkdir_p( File.dirname( path) )  unless Dir.exist?( File.dirname( path ))
  
    puts "==> writing to >#{path}<..."
    File.open( path, 'w:utf-8' ) do |f|
      f.write( "= #{name}\n" )
      f.write( buf )
    end
  end # method self.write
end  # class TxtMatchWriter
end  # module SportDb




puts SportDb::Module::Writers.banner   # say hello
