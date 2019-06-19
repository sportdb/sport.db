# encoding: utf-8


require 'pp'
require 'date'
require 'fileutils'



###
# our own code
require 'sportdb/config/version' # let version always go first

require 'sportdb/config/structs/team'

require 'sportdb/config/utils/season_utils'
require 'sportdb/config/utils/league_utils'

require 'sportdb/config/league'
require 'sportdb/config/league_reader'
require 'sportdb/config/team_reader'
require 'sportdb/config/config'



puts SportDb::Boot.banner   # say hello
