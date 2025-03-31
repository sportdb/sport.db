require 'cocos'
require 'season/formats'   ## add season support


## our own code
require_relative 'leagues/version'
require_relative 'leagues/league_config'  
require_relative 'leagues/league_codes'  



###################
## setup (quick) leagues (info) table

module LeagueInfoHelper
  def _league_info   ## load config on demand
    @_leagues ||= begin
                    leagues = SportDb::LeagueConfig.new
                    ['leagues',
                     'leagues_more',
                    ].each do |name|
                      recs = read_csv( "#{SportDb::Module::Leagues.root}/config/#{name}.csv" )
                      leagues.add( recs )
                    end
                    leagues
                  end
  end

  def find_league_info( league )
     raise ArgumentError, "league key as string|symbol expected"  unless league.is_a?(String) || league.is_a?(Symbol)
     _league_info[ league ]
  end
end  # module LeagueInfoHelper




####
### note - make find_league_info public/global by default - why? why not?
module Kernel
   include LeagueInfoHelper
end



puts SportDb::Module::Leagues.banner   ## say hello
