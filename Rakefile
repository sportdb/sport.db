require 'hoe'
require './lib/sportdb/version.rb'

## NB: plugin (hoe-manifest) not required; just used for future testing/development
## Hoe::plugin :manifest   # more options for manifests (in the future; not yet)


Hoe.spec 'sportdb' do
  
  self.version = SportDb::VERSION
  
  self.summary = 'sportdb - sport.db command line tool'
  self.description = summary

  self.urls    = ['https://github.com/geraldb/sport.db.ruby']
  
  self.author  = 'Gerald Bauer'
  self.email   = 'opensport@googlegroups.com'
    
  # switch extension to .markdown for gihub formatting
  #  -- NB: auto-changed when included in manifest
  # self.readme_file  = 'README.md'
  # self.history_file = 'History.md'
  
  self.extra_deps = [
    ['worlddb', '~> 1.6'],  # NB: worlddb already includes
                               #         - commander
                               #         - logutils
                               #         - textutils
    
    ## 3rd party
    ['commander', '~> 4.1.3']   # remove? -- already included as dep in worlddb

    ## ['activerecord', '~> 3.2'],  # NB: will include activesupport,etc.
    ### ['sqlite3',      '~> 1.3']  # NB: install on your own; remove dependency
  ]

  self.licenses = ['Public Domain']

  self.spec_extras = {
   :required_ruby_version => '>= 1.9.2'
  }

  self.post_install_message =<<EOS
******************************************************************************

Questions? Comments? Send them along to the mailing list.
https://groups.google.com/group/opensport

******************************************************************************
EOS
  
end


##############################
## for testing 
##
## NB: use rake -I ../world.db.ruby/lib -I ./lib sportdb:build

namespace :sportdb do
  
  BUILD_DIR = "./build"
  
  SPORT_DB_PATH = "#{BUILD_DIR}/sport.db"

  DB_CONFIG = {
    :adapter   =>  'sqlite3',
    :database  =>  SPORT_DB_PATH
  }

  directory BUILD_DIR

  task :clean do
    rm SPORT_DB_PATH if File.exists?( SPORT_DB_PATH )
  end

  task :env => BUILD_DIR do
    require 'worlddb'   ### NB: for local testing use rake -I ./lib dev:test e.g. do NOT forget to add -I ./lib
    require 'sportdb'
    require 'logutils/db'

    LogUtils::Logger.root.level = :info

    pp DB_CONFIG
    ActiveRecord::Base.establish_connection( DB_CONFIG )
  end

  task :create => :env do
    LogDb.create
    WorldDb.create
    SportDb.create
  end
  
  task :importworld => :env do
    WorldDb.read_setup( 'setups/sport.db.admin', '../world.db', skip_tags: true )  # populate world tables
    # WorldDb.stats
  end

  task :importsport => :env do
    SportDb.read_setup( 'setups/all', '../football.db' )
    # SportDb.stats
  end

  task :deletesport => :env do
    SportDb.delete!
  end



  desc 'sportdb - build from scratch'
  task :build => [:clean, :create, :importworld, :importsport] do
    puts 'Done.'
  end

  desc 'sportdb - update'
  task :update => [:deletesport, :importsport] do
    puts 'Done.'
  end

end  # namespace :sportdb
