require 'sportdb/config'


###
# our own code
require 'sportdb/linters/version' # let version always go first
require 'sportdb/linters/club_linter'
require 'sportdb/linters/conf_linter'
require 'sportdb/linters/conf_linter_old'
require 'sportdb/linters/match_linter'

require 'sportdb/linters/season_utils'
require 'sportdb/linters/level_utils'


require 'sportdb/linters/csv/parser_utils'
require 'sportdb/linters/csv/writer'
require 'sportdb/linters/csv/converter'
require 'sportdb/linters/csv/standings'
require 'sportdb/linters/csv/splitter'
require 'sportdb/linters/csv/reports/summary.rb'
require 'sportdb/linters/csv/reports/teams.rb'
require 'sportdb/linters/csv/reports/pyramid.rb'


require 'sportdb/linters/csv/reports/part_teams_by_city.rb'
require 'sportdb/linters/csv/reports/part_team_mappings.rb'
require 'sportdb/linters/csv/reports/part_level.rb'
require 'sportdb/linters/csv/reports/part_datafiles_by_level.rb'
require 'sportdb/linters/csv/reports/part_datafiles_by_season.rb'


require 'sportdb/linters/txt/writer.rb'


########################
#  add a "top-level" convience short-cut  - why? why not?
CsvMatchParser = SportDb::CsvMatchParser




puts SportDb::Module::Linters.banner   # say hello
