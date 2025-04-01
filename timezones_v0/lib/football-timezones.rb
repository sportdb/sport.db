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



puts SportDb::Module::Timezones.banner   ## say hello
