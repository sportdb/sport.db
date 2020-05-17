# encoding: utf-8

require 'sportdb/readers'

require 'logutils/activerecord'   ## NOTE: check - add to/include in/move to sportdb/models

## check if already included in datafile gem ??
require 'fetcher'   # for fetching/downloading fixtures via HTTP/HTTPS etc.
require 'datafile'   ## lets us use Datafile::Builder,Datafile etc.

require 'gli'

# our own code

require 'sportdb/cli/version'    # let version always go first
require 'sportdb/cli/opts'
require 'sportdb/cli/main'



module SportDb

  def self.main( args=ARGV )
    Tool.new.run( args )
  end

end  # module SportDb



##################
# add web service support / machinery

require 'webservice'

####
##  used for server/service command
##   "preconfigured" base class for webservice
class SportDbService < Webservice::Base
  include SportDb::Models   # e.g. League, Season, Team, etc.

  ## (auto-)add some (built-in) routes

  get '/version(s)?' do
    {
      "sportdb":        SportDbCli::VERSION,  ## todo/fix: change to DbTool!!!
      "sportdb/models": SportDb::VERSION,
      ## todo/fix: add beerdb/note version - if present
      ## todo/fix: add worlddb/models version
      ## todo/fix: add some more libs - why? why not??
      "activerecord":  [ActiveRecord::VERSION::MAJOR,ActiveRecord::VERSION::MINOR,ActiveRecord::VERSION::TINY].join('.'),
      "webservice":    Webservice::VERSION,
      "rack":          "#{Rack::RELEASE} (#{Rack::VERSION.join('.')})",     ## note: VERSION is the protocoll version as an array e.g.[1,2]
      "ruby":          "#{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}]",
    }
  end

  get '/(stats|tables)' do
    {
      "teams":        SportDb::Model::Team.count,
      "games":        SportDb::Model::Game.count,
      "events":       SportDb::Model::Event.count,
      "leagues":      SportDb::Model::League.count,
      "seasons":      SportDb::Model::Season.count,
      "countries":    WorldDb::Model::Country.count,
      "system": {
        "props":      ConfDb::Models::Prop.count,
        "logs":       LogDb::Models::Log.count,
      }
    }
  end

  get '/props(.:format)?' do    # note: add format - lets you use props.csv and props.html
    ConfDb::Models::Prop.all
  end

  get '/logs(.:format)?' do
    LogDb::Models::Log.all
  end


  ## add favicon support
  # get '/favicon.ico' do
    ## use 302 to redirect
    ##  note: use strg+F5 to refresh page (clear cache for favicon.ico)
  #  redirect '/webservice-sportdb-32x32.png'
  # end

  # get '/webservice-beerdb-32x32.png' do
  #  send_file "#{SportDbCli.root}/assets/webservice-sportdb-32x32.png"
  # end

end  # class SportDbService



SportDb.main   if __FILE__ == $0
