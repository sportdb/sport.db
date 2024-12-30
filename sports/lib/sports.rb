## 3rd party gems
require 'sportdb/structs'


###
# our own code
require_relative 'sports/version'    # let version always go first


# auto-include to "top-level" data struct(ures) / classes e.g.
#   Match, Team, Standings, etc.
include Sports


puts SportDb::Module::Sports.banner   # say hello
