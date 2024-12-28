require 'cocos'
require 'season/formats'   ## add season support


require 'tzinfo'


## our own code
require_relative 'football-timezones/version'
require_relative 'football-timezones/timezones'

####
### note - make find_zone! public/global by default - why? why not?
module Kernel
   include TimezoneHelper
end



require_relative 'football-timezones/datasets'

###
### note - make read_datasets & friends public/global by default - why? why not?
def read_datasets( path )       Datasets.read( path ); end
def parse_datasets( str )       Datasets.parse( str ); end
def parse_datasets_args( args ) Datasets.parse_args( args ); end


###
##  change to
#    read_leagueset
#    parse_leagueset
#    parse_leagueset_args


puts SportDb::Module::Timezones.banner   ## say hello
