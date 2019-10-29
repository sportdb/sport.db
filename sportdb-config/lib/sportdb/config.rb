# encoding: utf-8

### our own sportdb libs / gems
require 'sportdb/countries'
require 'sportdb/clubs'
require 'sportdb/leagues'


### "built-in" default dataset libs / gems
require 'fifa'    ## get a list of all fifa countries with (three letter) codes
require 'footballdb/clubs'
require 'footballdb/leagues'


###
# our own code
require 'sportdb/config/version' # let version always go first
require 'sportdb/config/wiki_index'
require 'sportdb/config/config'



## use global Import config - required for countries lookup / mapping (service)
SportDb::Import::ClubReader.config   = SportDb::Import.config
SportDb::Import::ClubIndex.config    = SportDb::Import.config
SportDb::Import::WikiReader.config   = SportDb::Import.config

SportDb::Import::LeagueReader.config  = SportDb::Import.config
SportDb::Import::LeagueIndex.config   = SportDb::Import.config



puts SportDb::Boot.banner   # say hello
