###
# NB: for local testing run like:
#
# 1.9.x: ruby -Ilib lib/sportdb.rb

# core and stlibs

require 'yaml'
require 'pp'
require 'logger'
require 'optparse'
require 'fileutils'
require 'erb'

# rubygems

require 'active_record'   ## todo: add sqlite3? etc.
require 'worlddb'


# our own code

require 'sportdb/version'

require 'sportdb/keys'
require 'sportdb/models/forward'
require 'sportdb/models/badge'
require 'sportdb/models/city'
require 'sportdb/models/country'
require 'sportdb/models/event'
require 'sportdb/models/event_team'
require 'sportdb/models/game'
require 'sportdb/models/group'
require 'sportdb/models/group_team'
require 'sportdb/models/league'
require 'sportdb/models/prop'
require 'sportdb/models/region'
require 'sportdb/models/round'
require 'sportdb/models/season'
require 'sportdb/models/team'
require 'sportdb/schema'       # NB: requires sportdb/models (include SportDB::Models)
require 'sportdb/utils'
require 'sportdb/loader'
require 'sportdb/reader'
require 'sportdb/templater'
require 'sportdb/cli/opts'
require 'sportdb/cli/runner'


module SportDB

  def self.banner
    "sportdb #{VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}]"
  end

  def self.root
    "#{File.expand_path( File.dirname(File.dirname(__FILE__)) )}"
  end

  def self.main
    Runner.new.run(ARGV)
  end

  def self.create
    CreateDB.up
  end

  class Fixtures
    ## todo: move into its own file???    
    
    ## make constants in Keys availabe (get include in Models) - do NOT pollute/include in SportDB
    ## make models available in sportdb module by default with namespace
    #  e.g. lets you use Team instead of Models::Team 
    include SportDB::Models


    def self.fixtures_rb_test
     ['leagues',
      'seasons',
#      'at/2011_12/bl',
#      'at/2011_12/cup',
#      'at/2012_13/bl',
#      'at/2012_13/cup',
#      'copa/sud_2012_13',
#      'world/quali_2012_13_america'
     ]
    end

    def self.fixtures_txt_test
      [
#       [ AT_2011_12,        'at/2011_12/bl'],
#       [ AT_2012_13,        'at/2012_13/bl'],
#       [ AT_CUP_2012_13,    'at/2012_13/cup'],
#       ['copa.sud.2012/13', 'copa/sud_2012_13'],
#       [ WORLD_QUALI_AMERICA_2012_13, 'world/quali_2012_13_america']
      ]
    end


    def self.team_fixtures
      at = Country.find_by_key!( 'at' )
      de = Country.find_by_key!( 'de' )
      en = Country.find_by_key!( 'en' )
      es = Country.find_by_key!( 'es' )
      ro = Country.find_by_key!( 'ro' )
      mx = Country.find_by_key!( 'mx' )

      [
        [ 'america/teams', { national: true } ],
        [ 'euro/teams',    { national: true } ],
        [ 'world/teams',   { national: true } ],
        [ 'at/teams', { club: true, country_id: at.id } ],
        [ 'de/teams', { club: true, country_id: de.id } ],
        [ 'en/teams', { club: true, country_id: en.id } ],
        [ 'es/teams', { club: true, country_id: es.id } ],
#        [ 'ro/teams', { club: true, country_id: ro.id } ],
        [ 'mx/teams', { club: true, country_id: mx.id } ],
        [ 'cl/teams', { club: true } ],
        [ 'copa/teams', { club: true } ],
        [ 'nhl/teams', { club: true } ]
      ]
    end

    def self.fixtures_rb  # all builtin ruby fixtures; helper for covenience
     ['leagues',
      'seasons',
      'at/badges',
      'at/2011_12/bl',
      'at/2011_12/cup',
      'at/2012_13/bl',
      'at/2012_13/cup',
      'cl/badges',
      'cl/2011_12/cl',
      'cl/2011_12/el',
      'cl/2012_13/cl',
      'de/2012_13/bl',
      'en/2012_13/pl',
      'euro/2008',
      'euro/2012',
      'america/2011',
      'copa/sud_2012_13',
      'mx/apertura_2012',
      'world/2010',
      'world/quali_2012_13_europe',
      'world/quali_2012_13_america'
      ]
    end

    def self.fixtures_txt
      [[ AT_2011_12,        'at/2011_12/bl'],
       [ AT_2012_13,        'at/2012_13/bl'],
       [ AT_CUP_2012_13,    'at/2012_13/cup'],
       ['de.2012/13',       'de/2012_13/bl'],
       ['en.2012/13',       'en/2012_13/pl'],
       ['america.2011',     'america/2011'],
       ['mx.apertura.2012', 'mx/apertura_2012'],
       ['copa.sud.2012/13', 'copa/sud_2012_13'],
       [ EURO_2008,                   'euro/2008'],
       [ WORLD_2010,                  'world/2010'],
       [ WORLD_QUALI_EURO_2012_13,    'world/quali_2012_13_europe_c'],
       [ WORLD_QUALI_AMERICA_2012_13, 'world/quali_2012_13_america']]
    end
  end # class Fixtures

  def self.team_fixtures
    Fixtures.team_fixtures
  end

  def self.fixtures_rb  # all builtin ruby fixtures; helper for covenience
    Fixtures.fixtures_rb
  end
  
  def self.fixtures_txt
    Fixtures.fixtures_txt
  end

  def self.load_all
    ## load teams first
    read( team_fixtures )  # converted to plain text fixtures (.rb no longer exist)
    
    load( fixtures_rb )
  end


  def self.read_all
    ## todo/fix: remove!! roll into load_all
    read( fixtures_txt )
  end

  # load built-in (that is, bundled within the gem) named seeds
  # - pass in an array of seed names e.g. [ 'cl/teams', 'cl/2012_13/cl' ] etc.

  def self.load( ary )
    loader = Loader.new
    ary.each do |name|
      loader.load_fixtures_builtin( name )
    end
  end

  # load built-in (that is, bundled within the gem) named plain text seeds
  # - pass in an array of pairs of event/seed names e.g. [['at.2012/13', 'at/2012_13/bl'], ['cl.2012/13', 'cl/2012_13/cl']] etc.

  def self.read( ary )
    reader = Reader.new
    ary.each do |rec|
      ## todo: check for teams in name too?
      if rec[1].nil? || rec[1].kind_of?( Hash )   ## assume team fixtures
        reader.load_teams_builtin( rec[0], rec[1] )  ## NB: name goes first than opt more_values hash
      else
        reader.load_fixtures_builtin( rec[0], rec[1] ) # event_key, name  -- assume game fixtures
      end
    end
  end

  
  class Deleter
    ## todo: move into its own file???    
    
    ## make models available in sportdb module by default with namespace
    #  e.g. lets you use Team instead of Models::Team 
    include SportDB::Models

    def run( args=[] )
      # for now delete all tables
      
      Team.delete_all
      Game.delete_all
      Event.delete_all
      EventTeam.delete_all
      Group.delete_all
      GroupTeam.delete_all
      Round.delete_all
      Badge.delete_all
      League.delete_all
      Season.delete_all
    end
    
  end
  
  # delete ALL records (use with care!)
  def self.delete!
    puts '*** deleting sport table records/data...'
    Deleter.new.run
  end # method delete!


  class Stats
    include SportDB::Models

    def tables
      puts "Stats:"
      puts "  #{Event.count} events  /  #{Round.count} rounds  /  #{Group.count} groups"
      puts "  #{League.count} leagues  /  #{Season.count} seasons"
      puts "  #{Country.count} countries / #{Region.count} regions / #{City.count} cities"
      puts "  #{Team.count} teams"
      puts "  #{Game.count} games"
      puts "  #{Badge.count} badges"
      
      ## todo: add tags / taggings from worlddb
    end
    
    def props
      puts "Props:"
      Prop.order( 'created_at asc' ).all.each do |prop|
        puts "  #{prop.key} / #{prop.value} || #{prop.created_at}"
      end
    end
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

end  # module SportDB


## SportDB::load_plugins


if __FILE__ == $0
  SportDB.main
else
   ## say hello
  puts SportDB.banner
end