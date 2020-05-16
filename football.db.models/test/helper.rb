
## minitest setup

# require 'minitest/unit'
require 'minitest/autorun'

require 'sportdb'


## our own code
require 'footballdb'


#####################
# Models shortcuts

Country    = WorldDb::Model::Country

Person      = PersonDb::Model::Person

League      = SportDb::Model::League
Season      = SportDb::Model::Season
Event       = SportDb::Model::Event
Team        = SportDb::Model::Team
Roster      = SportDb::Model::Roster

PlayerStat  = SportDb::Model::PlayerStat



####################
# Reader shortcuts

TeamReader         = SportDb::TeamReader
SeasonReader       = SportDb::SeasonReader
LeagueReader       = SportDb::LeagueReader
EventReader        = SportDb::EventReader
GameReader         = SportDb::GameReader
SquadReader        = SportDb::SquadReader

PlayerStatReader   = SportDb::PlayerStatReader

PersonReader       = PersonDb::PersonReader


#################################
# setup db -> schema / tables

SportDb.setup_in_memory_db

## add football db tables
FootballDb.create    # see footballdb/schema

