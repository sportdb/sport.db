# encoding: utf-8

######
# NB: use rackup to startup Sinatra service (see config.ru)
#
#  e.g. config.ru:
#   require './boot'
#   run SportDb::Server


###
# note: it's an addon to sportdb (get all libs via sportdb)
require 'sportdb'

###
# extra 3rd party gems
require 'sinatra/base'


# our own code
require 'sportdb/service/version' # let it always go first


module SportDb
  module Service

  def self.banner
    "sportdb-service/#{VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}]"
  end

  def self.root
    "#{File.expand_path( File.dirname( File.dirname(File.dirname(__FILE__))) )}"
  end

  end # module Service
end # module SportDb


require 'sportdb/service/server'

### for legacy old code e.g. SportDb::Service::Server - remove later - do NOT use
##   use just SportDb::Server
module SportDb
  module Service
    Server = SportDb::Server
  end # module Service
end #  module SportDb




puts SportDb::Service.banner   # say hello
