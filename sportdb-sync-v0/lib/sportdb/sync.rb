require 'sportdb/catalogs'
require 'sportdb/models'   ## add sql database support



###
# our own code
require_relative 'sync/version' # let version always go first
require_relative 'sync/country'
require_relative 'sync/league'
require_relative 'sync/season'
require_relative 'sync/event'
require_relative 'sync/club'
require_relative 'sync/sync'


puts SportDb::Module::Sync.banner   # say hello
