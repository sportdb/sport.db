# encoding: utf-8


## 3rd party gemss
require 'sportdb/config'


###
# our own code
require 'sportdb/text/version' # let version always go first



require 'sportdb/text/season_utils'
require 'sportdb/text/level_utils'


require 'sportdb/text/csv/reader'
require 'sportdb/text/csv/reader_utils'
require 'sportdb/text/csv/writer'
require 'sportdb/text/csv/converter'
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


########################
#  add a "top-level" convience short-cut  - why? why not?
CsvMatchReader = SportDb::CsvMatchReader



puts SportDb::Module::Text.banner   # say hello
