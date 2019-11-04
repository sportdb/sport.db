# encoding: utf-8


require 'sportdb/clubs'
require 'sportdb/leagues'


require 'sportdb/models'   ## add sql database support



###
# our own code
require 'sportdb/sync/version' # let version always go first
require 'sportdb/sync/sync'


puts SportDb::Sync.banner   # say hello
