
## $:.unshift(File.dirname(__FILE__))

## minitest setup

# require 'minitest/unit'
require 'minitest/autorun'


## our own code

require 'sportdb'


#####################
# Models shortcuts

Country    = WorldDb::Model::Country

Person     = PersonDb::Model::Person

League     = SportDb::Model::League
Season     = SportDb::Model::Season
Event      = SportDb::Model::Event
Team       = SportDb::Model::Team

Round      = SportDb::Model::Round
Game       = SportDb::Model::Game
GameCursor = SportDb::Model::GameCursor


####################
# Reader shortcuts

TeamReader         = SportDb::TeamReader
SeasonReader       = SportDb::SeasonReader
LeagueReader       = SportDb::LeagueReader
GameReader         = SportDb::GameReader
NationalTeamReader = SportDb::NationalTeamReader
RaceTeamReader     = SportDb::RaceTeamReader

PersonReader       = PersonDb::PersonReader

#################################
# setup db -> schema / tables

SportDb.setup_in_memory_db

