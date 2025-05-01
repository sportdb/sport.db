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
  def read_leagueset( path, autofill: nil )       
      Leagueset.read( path, autofill: autofill )
  end
  def parse_leagueset( txt, autofill: nil )       
      Leagueset.parse( txt, autofill: autofill )
  end
  def parse_leagueset_args( args, autofill: nil ) 
      Leagueset.parse_args( args, autofill: autofill )
  end
end



##
## todo/check
##  note - move FileHelper upstream to cocos (code commons) - why? why not?
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
