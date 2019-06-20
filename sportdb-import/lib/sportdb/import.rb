# encoding: utf-8


## 3rd party gemss
require 'sportdb/text'
require 'sportdb/models'   ## add sql database support


###
# our own code
require 'sportdb/import/version' # let version always go first


puts SportDb::Import.banner   # say hello
