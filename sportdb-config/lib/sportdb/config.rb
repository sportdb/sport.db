# encoding: utf-8

### our own sportdb libs / gems
require 'sportdb/formats'

### "built-in" default dataset libs / gems
require 'fifa'    ## get a list of all fifa countries with (three letter) codes
require 'footballdb/leagues'
require 'footballdb/clubs'


###
# our own code
require 'sportdb/config/version' # let version always go first
require 'sportdb/config/wiki_index'
require 'sportdb/config/catalog'
require 'sportdb/config/config'


puts SportDb::Boot.banner   # say hello
