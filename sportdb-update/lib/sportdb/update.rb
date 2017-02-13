# encoding: utf-8

###
# NOTE: it's an addon to sportdb (get all libs via sportdb)
#  NOTE: avoid circular require/include !! (do NOT require sportdb because sportdb requires sportdb/update!!)
# require 'sportdb'


# our own code

require 'sportdb/update/version' # let it always go first
require 'sportdb/update/updater'



puts SportDb::Update.banner   # say hello

