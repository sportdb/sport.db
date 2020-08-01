# encoding: utf-8

### our own sportdb libs / gems
require 'sportdb/formats'

### "built-in" default dataset libs / gems
require 'fifa'    ## get a list of all fifa countries with (three letter) codes
require 'footballdb/leagues'
require 'footballdb/clubs'


###
# our own code
require 'sportdb/catalogs/version' # let version always go first
require 'sportdb/catalogs/wiki_index'
require 'sportdb/catalogs/catalog'
require 'sportdb/catalogs/config'


puts SportDb::Module::Catalogs.banner   # say hello
