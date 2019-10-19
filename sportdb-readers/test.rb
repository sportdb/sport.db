# encoding: UTF-8


require 'sportdb/config'


## use (switch to) "external" datasets
SportDb::Import.config.clubs_dir   = "../../../openfootball/clubs"
SportDb::Import.config.leagues_dir = "../../../openfootball/leagues"



LEAGUES   = SportDb::Import.config.leagues
CLUBS     = SportDb::Import.config.clubs
COUNTRIES = SportDb::Import.config.countries


require 'sportdb/models'   ## add sql database support

SportDb.connect( adapter: 'sqlite3', database: ':memory:' )
SportDb.create_all   ## build schema

## turn on logging to console
ActiveRecord::Base.logger = Logger.new(STDOUT)



require_relative 'sync'
require_relative 'outline_reader'
require_relative 'event_reader'
require_relative 'match_parser'
require_relative 'match_reader'


path = "../../../openfootball/eng-england/2017-18/1-premierleague.conf.txt"
recs = SportDb::EventReaderV2.read( path )
path = "../../../openfootball/eng-england/2017-18/1-premierleague-i.txt"
recs = SportDb::MatchReaderV2.read( path )
