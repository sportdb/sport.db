# encoding: utf-8



require 'pp'
require 'csv'
require 'date'
require 'fileutils'



###
# our own code
require 'sportdb/text/version' # let version always go first

require 'sportdb/text/structs/match'
require 'sportdb/text/structs/matchlist'
require 'sportdb/text/structs/standings'
require 'sportdb/text/structs/team'
require 'sportdb/text/structs/team_usage'


require 'sportdb/text/config/league'
require 'sportdb/text/config/league_reader'
require 'sportdb/text/config/team_reader'
require 'sportdb/text/config/config'


require 'sportdb/text/season_utils'
require 'sportdb/text/level_utils'
require 'sportdb/text/league_utils'



require 'sportdb/text/csv/reader'
require 'sportdb/text/csv/writer'
require 'sportdb/text/csv/converter'
require 'sportdb/text/csv/package'
require 'sportdb/text/csv/standings'
require 'sportdb/text/csv/splitter'
require 'sportdb/text/csv/reports/summary.rb'
require 'sportdb/text/csv/reports/teams.rb'
require 'sportdb/text/csv/reports/pyramid.rb'


require 'sportdb/text/csv/reports/part_teams_by_city.rb'
require 'sportdb/text/csv/reports/part_team_mappings.rb'
require 'sportdb/text/csv/reports/part_level.rb'
require 'sportdb/text/csv/reports/part_datafiles_by_level.rb'
require 'sportdb/text/csv/reports/part_datafiles_by_season.rb'


require 'sportdb/text/txt/writer.rb'

require 'sportdb/text/converter/standard.rb'


module SportDb
   Structs = Struct ## add convenience alias (e.g. lets you use include SportDb::Structs)
end




puts SportDb::Text.banner   # say hello
