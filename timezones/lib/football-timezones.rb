require 'cocos'
require 'season/formats'   ## add season support


require 'tzinfo'


## our own code
require_relative 'football-timezones/version'
require_relative 'football-timezones/timezones'



###################
## setup (quick) leagues (info) table
require_relative 'football-timezones/league_config'

module LeagueInfoHelper
  def _league_info   ## load config on demand
    @_leagues ||= begin
                    leagues = SportDb::LeagueConfig.new
                    ['leagues',
                     'leagues_more',
                    ].each do |name|
                      recs = read_csv( "#{SportDb::Module::Timezones.root}/config/#{name}.csv" )
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





require_relative 'football-timezones/leagueset'

#### add alias - why? why not?
LeagueSet = Leagueset    


module LeaguesetHelper
  ###
  ### note - make read_leagueset & friends public/global by default - why? why not?
  def read_leagueset( path )       Leagueset.read( path ); end
  def parse_leagueset( txt )       Leagueset.parse( txt ); end
  def parse_leagueset_args( args ) Leagueset.parse_args( args ); end
end



module FileHelper
  def find_file( filename, path: )
    path.each do |src_dir|
      path = "#{src_dir}/#{filename}"
      return path   if File.exist?( path )
    end

    ##  fix - raise file not found error!!!
    nil  ## not found - raise filenot found error - why? why not?
  end
end



####
### note - make find_zone! public/global by default - why? why not?
module Kernel
   include FileHelper
   include TimezoneHelper
   include LeagueInfoHelper
   include LeaguesetHelper
end



puts SportDb::Module::Timezones.banner   ## say hello
