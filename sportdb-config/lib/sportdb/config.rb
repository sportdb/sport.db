# encoding: utf-8


require 'pp'
require 'date'
require 'fileutils'



###
# our own code
require 'sportdb/config/version' # let version always go first

require 'sportdb/config/season_utils'
require 'sportdb/config/league_utils'
require 'sportdb/config/league'
require 'sportdb/config/league_reader'
require 'sportdb/config/team_reader'

require 'sportdb/config/countries'
require 'sportdb/config/config'



puts SportDb::Boot.banner   # say hello
