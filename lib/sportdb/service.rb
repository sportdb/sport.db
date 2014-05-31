######
# NB: use rackup to startup Sinatra service (see config.ru)
#
#  e.g. config.ru:
#   require './boot'
#   run SportDb::Service::Server


# 3rd party libs/gems

require 'sinatra/base'


# our own code

module SportDb
  module Service

  def self.banner
    "sportdb-service/#{VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}] on Sinatra/#{Sinatra::VERSION} (#{ENV['RACK_ENV']})"
  end

  end # module Service
end #  module SportDb


require 'sportdb/service/server'

# say hello
puts SportDb::Service.banner
