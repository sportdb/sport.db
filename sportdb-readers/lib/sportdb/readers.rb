# encoding: UTF-8


require 'sportdb/config'
require 'sportdb/models'   ## add sql database support



###
# our own code
require 'sportdb/readers/version' # let version always go first
require 'sportdb/readers/sync'
require 'sportdb/readers/outline_reader'
require 'sportdb/readers/event_reader'
require 'sportdb/readers/match_parser'
require 'sportdb/readers/match_reader'





puts SportDb::Readers.banner   # say hello
