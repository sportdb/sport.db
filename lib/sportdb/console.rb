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

Event   = SportDb::Models::Event
Team    = SportDb::Models::Team
Game    = SportDb::Models::Game
Group   = SportDb::Models::Group
Round   = SportDb::Models::Round
Season  = SportDb::Models::Season
League  = SportDb::Models::League
Badge   = SportDb::Models::Badge

Tag     = WorldDb::Models::Tag
Tagging = WorldDb::Models::Tagging
Country = WorldDb::Models::Country
Region  = WorldDb::Models::Region
City    = WorldDb::Models::City
Prop    = WorldDb::Models::Prop

## connect to db

DB_CONFIG = {
  adapter:  'sqlite3',
  database: 'sport.db'
}

pp DB_CONFIG
ActiveRecord::Base.establish_connection( DB_CONFIG )

## test drive

puts "Welcome to sport.db, version #{SportDb::VERSION} (world.db, version #{WorldDb::VERSION})!"
puts "  #{'%5d' % Event.count} events"
puts "  #{'%5d' % Team.count} teams"
puts "  #{'%5d' % Game.count} games"
puts "  #{'%5d' % City.count} cities"
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

BL = Event.find_by_key( 'de.2012/13' )
PL = Event.find_by_key( 'en.2012/13' )

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
