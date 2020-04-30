# encoding: utf-8

### our own sportdb libs / gems
require 'sportdb/countries'
require 'sportdb/leagues'
require 'sportdb/teams'


### "built-in" default dataset libs / gems
require 'fifa'    ## get a list of all fifa countries with (three letter) codes
require 'footballdb/leagues'
require 'footballdb/clubs'

## more sportdb libs / gems for match format schedules etc.
require 'sportdb/match/formats'


###
# our own code
require 'sportdb/config/version' # let version always go first
require 'sportdb/config/wiki_index'
require 'sportdb/config/catalog'
require 'sportdb/config/config'


puts SportDb::Boot.banner   # say hello
