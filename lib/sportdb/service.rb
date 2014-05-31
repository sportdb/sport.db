######
# NB: use rackup to startup Sinatra service (see config.ru)
#
#  e.g. config.ru:
#   require './boot'
#   run SportDb::Server


# 3rd party libs/gems

require 'sinatra/base'


# our own code


require 'sportdb/service/server'


### for legacy old code e.g. SportDb::Service::Server - remove later - do NOT use
##  remove module Service (obsolete)
module SportDb
  module Service
    Server = SportDb::Server
  end # module Service
end #  module SportDb


# say hello
puts SportDb::Server.banner
