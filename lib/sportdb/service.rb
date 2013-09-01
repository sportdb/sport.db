######
# NB: use rackup to startup Sinatra service (see config.ru)
#
#  e.g. config.ru:
#   require './boot'
#   run SportDb::Service::Server


# 3rd party libs/gems

require 'sinatra/base'


# our own code

require 'sportdb/service/version'


module SportDb::Service

  def self.banner
    "sportdb-service #{VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}] on Sinatra/#{Sinatra::VERSION} (#{ENV['RACK_ENV']})"
  end

### fix: move to SportDb
  def self.root
    "#{File.expand_path( File.dirname(File.dirname(File.dirname(__FILE__))) )}"
  end

=begin  
  def self.config_path
    ## needed? use default db connection?
    "#{root}/config"
  end
=end

end #  module SportDb

require 'sportdb/service/server'

# say hello
puts SportDb::Service.banner
