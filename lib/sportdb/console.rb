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

Badge   = SportDb::Models::Badge
Event   = SportDb::Models::Event
Game    = SportDb::Models::Game
Goal    = SportDb::Models::Goal
Group   = SportDb::Models::Group
League  = SportDb::Models::League
Person  = SportDb::Models::Person
Race    = SportDb::Models::Race
Record  = SportDb::Models::Record
Roster  = SportDb::Models::Roster
Round   = SportDb::Models::Round
Run     = SportDb::Models::Run
Season  = SportDb::Models::Season
Team    = SportDb::Models::Team
Track   = SportDb::Models::Track


Tag       = WorldDb::Models::Tag
Tagging   = WorldDb::Models::Tagging
Continent = WorldDb::Models::Continent
Country   = WorldDb::Models::Country
Region    = WorldDb::Models::Region
City      = WorldDb::Models::City
Prop      = WorldDb::Models::Prop

## connect to db

DB_CONFIG = {
  adapter:  'sqlite3',
  database: 'sport.db'
}

pp DB_CONFIG
ActiveRecord::Base.establish_connection( DB_CONFIG )

## test drive

puts "Welcome to sport.db, version #{SportDb::VERSION} (world.db, version #{WorldDb::VERSION})!"

SportDb.tables

puts "Ready."

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
