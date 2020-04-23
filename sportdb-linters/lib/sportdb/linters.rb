require 'sportdb/config'


###
# our own code
require 'sportdb/linters/version' # let version always go first
require 'sportdb/linters/club_linter'
require 'sportdb/linters/conf_linter'
require 'sportdb/linters/conf_linter_old'
require 'sportdb/linters/match_linter'




puts SportDb::Linters.banner   # say hello
