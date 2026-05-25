
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

require_relative 'writers/rounds'

require_relative 'writers/build_stats'
require_relative 'writers/build_goals'

require_relative 'writers/build'



module SportDb
class TxtMatchWriter




  ## fix - change name: to title: !!!!
  ##    fix:  remove rounds: true|false  - make it works without rounds without flag!!!!!

  def self.write( path, matches, name:, rounds: true)

    buf = build( matches, rounds: rounds )

    puts "==> writing to >#{path}<..."

    txt = "= #{name}\n\n" + buf
    write_text( path, txt )
  end # method self.write




  class << self
    alias_method :write_v2, :write
    alias_method :build_v2, :build
  end

end  # class TxtMatchWriter
end  # module SportDb




puts SportDb::Module::Writers.banner   # say hello
