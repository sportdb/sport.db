# encoding: utf-8

require 'sportdb/config'
require 'sportdb/models'   ## add sql database support


##
# fix!!!
#   patches for worlddb/models  - move upstream!!!!
module WorldDb
  COUNTRY_KEY_PATTERN = '\A[a-z]{2,}\z'    # allow two AND three letter keys e.g. at, mx, eng, sco, etc.
  COUNTRY_KEY_PATTERN_MESSAGE = "expected two or more lowercase letters a-z /#{COUNTRY_KEY_PATTERN}/"

  COUNTRY_CODE_PATTERN = '\A[A-Z_]{2,}\z'
  COUNTRY_CODE_PATTERN_MESSAGE = "expected two or more uppercase letters A-Z (and _) /#{COUNTRY_CODE_PATTERN}/"
end  # module WorldDb


###
# our own code
require 'sportdb/sync/version' # let version always go first
require 'sportdb/sync/country'
require 'sportdb/sync/league'
require 'sportdb/sync/season'
require 'sportdb/sync/event'
require 'sportdb/sync/club'
require 'sportdb/sync/sync'


puts SportDb::Sync.banner   # say hello
