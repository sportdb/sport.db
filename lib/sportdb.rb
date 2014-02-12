# encoding: utf-8


###
# NB: for local testing run like:
#
# 1.9.x: ruby -Ilib lib/sportdb.rb

# core and stlibs

require 'yaml'
require 'pp'
require 'logger'             ## todo/fix: no longer needed - replaced by logutils??
require 'fileutils'
require 'erb'

# rubygems  / 3rd party libs

require 'active_record'   ## todo: add sqlite3? etc.

require 'logutils'
require 'textutils'

require 'worlddb'

require 'fetcher'   # for fetching/downloading fixtures via HTTP/HTTPS etc.

# our own code

require 'sportdb/version'

require 'sportdb/title'   ## fix - move to textutils gem
require 'sportdb/models/forward'
require 'sportdb/models/world/city'
require 'sportdb/models/world/country'
require 'sportdb/models/world/continent'
require 'sportdb/models/world/region'
require 'sportdb/models/badge'
require 'sportdb/models/event'
require 'sportdb/models/event_ground'
require 'sportdb/models/event_team'
require 'sportdb/models/game'
require 'sportdb/models/goal'
require 'sportdb/models/ground'
require 'sportdb/models/group'
require 'sportdb/models/group_team'
require 'sportdb/models/league'
require 'sportdb/models/person'
require 'sportdb/models/race'
require 'sportdb/models/record'
require 'sportdb/models/roster'
require 'sportdb/models/round'
require 'sportdb/models/run'
require 'sportdb/models/season'
require 'sportdb/models/team'
require 'sportdb/models/track'

require 'sportdb/models/utils'   # e.g. GameCursor

## add backwards compatible namespace (delete later!)
module SportDb
  Models = Model
end


require 'sportdb/schema'       # NB: requires sportdb/models (include SportDB::Models)
require 'sportdb/utils'
require 'sportdb/reader'
require 'sportdb/lang'

require 'sportdb/updater'
require 'sportdb/deleter'
require 'sportdb/stats'

###############
# optional: for convenience add some finders etc. for known fixtures
#
#  only used for sportdb/console.rb
#   and  sportdb/tasks/test.rb  -> rename to tasks.rb?
#
#  todo/fix => remove from here and move into console.rb and tasks.rb

require 'sportdb/data/keys'
require 'sportdb/data/models'     # add convenience finders for known fixtures



module SportDb

  def self.banner
    "sportdb/#{VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}]"
  end

  def self.root
    "#{File.expand_path( File.dirname(File.dirname(__FILE__)) )}"
  end

  def self.config_path
    "#{root}/config"
  end
  
  def self.data_path
    "#{root}/data"
  end

  def self.lang
    # todo/fix: find a better way for single instance ??
    #  will get us ruby warning:  instance variable @lang not initialized   => find a better way!!!
    #   just use @lang w/o .nil?  e.g.
    #  @lang =|| Lang.new   why? why not??  or better use @@lang =|| Lang.new  for class variable!!!
     if @lang.nil?
       @lang = Lang.new
     end
     @lang
  end


  def self.main
    ## Runner.new.run(ARGV) - old code
    require 'sportdb/cli/main'
  end

  def self.create
    CreateDb.new.up
    WorldDb::Model::Prop.create!( key: 'db.schema.sport.version', value: VERSION )
  end

  def self.read_setup( setup, include_path )
    reader = Reader.new( include_path )
    reader.load_setup( setup )
  end

  def self.read_all( include_path )   # convenience helper
    read_setup( 'setups/all', include_path )
  end

  def self.read_builtin
    read_setup( 'setups/all', data_path )
  end


  # load built-in (that is, bundled within the gem) named plain text seeds
  # - pass in an array of pairs of event/seed names e.g.
  #   [['at.2012/13', 'at/2012_13/bl'],
  #    ['cl.2012/13', 'cl/2012_13/cl']] etc.

  def self.read( ary, include_path )
    reader = Reader.new( include_path )
    ## todo: check kind_of?( Array ) or kind_of?(String) to support array or string
    ary.each do |name|
      reader.load( name )
    end
  end


  # delete ALL records (use with care!)
  def self.delete!
    puts '*** deleting sport table records/data...'
    Deleter.new.run
  end # method delete!

  def self.update!
    puts '*** update event fixtures...'
    Updater.new.run
  end


  def self.stats
    stats = Stats.new
    stats.tables
    stats.props
  end

  def self.tables
    Stats.new.tables
  end

  def self.props
    Stats.new.props
  end



  def self.load_plugins

    @found  ||= []
    @loaded ||= {}
    @files  ||= Gem.find_files( 'sportdb_plugin.rb' )

    puts "#{@files.size} plugin files found:"
    @files.each do |file|
      puts "  >#{file}<"
    end
    
    ## todo: extract version and name of gem?
    puts "normalized/match pattern:"
    @files.each do |file|
      if file =~ /sportdb-([a-z]+)-(\d\.\d.\d)/
        puts "  >#{$1}< | >#{$2}<"
        @found << file
      else
        puts "*** error: ignoring plugin script >#{file}< not matching gem naming pattern"
      end
    end
    
    @found.each do |file|
      begin
        puts  "loading plugin script #{file}"
        require file
      rescue LoadError => e
        puts "*** error loading plugin script #{file.inspect}: #{e.message}. skipping..."
      end
    end

  end

end  # module SportDb


## SportDb::load_plugins


if __FILE__ == $0
  SportDb.main
else
   ## say hello
  puts SportDb.banner
end