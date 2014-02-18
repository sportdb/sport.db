## for use to run with interactive ruby (irb)
##  e.g.  irb -r sportdb/console

require 'sportdb'

# some ruby stdlibs

require 'logger'
require 'pp'   # pretty printer
require 'uri'
require 'json'
require 'yaml'


## shortcuts for models

##
##  todo/fix: just use include SportDb::Models  - why? why not? is it possible/working?

Badge   = SportDb::Model::Badge
Event   = SportDb::Model::Event
Game    = SportDb::Model::Game
Goal    = SportDb::Model::Goal
Group   = SportDb::Model::Group
League  = SportDb::Model::League
Person  = SportDb::Model::Person
Race    = SportDb::Model::Race
Record  = SportDb::Model::Record
Roster  = SportDb::Model::Roster
Round   = SportDb::Model::Round
Run     = SportDb::Model::Run
Season  = SportDb::Model::Season
Team    = SportDb::Model::Team
Track   = SportDb::Model::Track


Tag       = WorldDb::Model::Tag
Tagging   = WorldDb::Model::Tagging
Continent = WorldDb::Model::Continent
Country   = WorldDb::Model::Country
Region    = WorldDb::Model::Region
City      = WorldDb::Model::City
Prop      = WorldDb::Model::Prop


## connect to db

DB_CONFIG = {
  adapter:  'sqlite3',
  database: 'sport.db'
}

pp DB_CONFIG
ActiveRecord::Base.establish_connection( DB_CONFIG )

## test drive

puts "Welcome to sport.db, version #{SportDb::VERSION} (world.db, version #{WorldDb::VERSION})!"

## print tables stats (e.g. no of records)
puts 'sport.db'
puts '--------'
SportDb.tables

puts 'world.db'
puts '--------'
WorldDb.tables

puts 'Ready.'


## add some predefined shortcuts

##### some countries

AT = Country.find_by_key( 'at' )
DE = Country.find_by_key( 'de' )
EN = Country.find_by_key( 'en' )

US = Country.find_by_key( 'us' )
CA = Country.find_by_key( 'ca' )
MX = Country.find_by_key( 'mx' )

#### some events

EURO2008 = Event.find_by_key( 'euro.2008' )
EURO2012 = Event.find_by_key( 'euro.2012' )
EURO = EURO2012  # add alias

BL = Event.find_by_key( 'de.2013/14' )
PL = Event.find_by_key( 'en.2013/14' )

### some club teams

BARCA   = Team.find_by_key( 'barcelona' )
MANU    = Team.find_by_key( 'manunited' )
MUN = MANUNITED = MANU    # add alias
BAYERN  = Team.find_by_key( 'bayern' )
AUSTRIA = Team.find_by_key( 'austria' )

### some national teams (three letter fifa codes)

ESP = Team.find_by_key( 'esp' )
GER = Team.find_by_key( 'ger' )
AUT = Team.find_by_key( 'aut' )

MEX = Team.find_by_key( 'mex' )
ARG = Team.find_by_key( 'arg' )

## turn on activerecord logging to console

ActiveRecord::Base.logger = Logger.new( STDOUT )
