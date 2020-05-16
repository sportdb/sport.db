# encoding: utf-8


###
# note: footballdb is an addon/plugin for sportdb
##   assume sportdb required


require 'csv'    ##  todo: add/move require to sportdb


#########
# our own code

require 'footballdb/version'    # let version always go first

require 'footballdb/models/stats/player_stat'
require 'footballdb/models/person'

require 'footballdb/readers/player_stat'


require 'footballdb/schema'       # NB: requires sportdb/models (include SportDB::Models)


module FootballDb

  def self.banner
    "footballdb/#{VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}]"
  end

  def self.root
    "#{File.expand_path( File.dirname(File.dirname(__FILE__)) )}"
  end

  def self.test_data_path
    "#{root}/test/data"
  end

  def self.create
    CreateDb.new.up
    ## ConfDb::Model::Prop.create!( key: 'db.schema.football.version', value: VERSION )
  end
  
  def self.delete!
    ## fix/todo: move into deleter class (see worlddb,sportdb etc.)
    SportDb::Model::PlayerStat.delete_all
  end

end  # module FootballDb


## say hello
puts FootballDb.banner

