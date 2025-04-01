require 'cocos'
require 'season/formats'   ## add season support


require 'tzinfo'




## our own code
require_relative 'leagues/version'
require_relative 'leagues/league_codes'  

require_relative 'leagues/leagueset'

require_relative 'leagues/timezones'


###
## note - make LeagueCodes "global" by default for now - why? why not?
LeagueCodes = SportDb::LeagueCodes
Leagueset   = SportDb::Leagueset
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
   include LeaguesetHelper
   include TimezoneHelper
end




puts SportDb::Module::Leagues.banner   ## say hello
