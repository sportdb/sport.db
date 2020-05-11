## minitest setup
require 'minitest/autorun'


## our own code
require 'sportdb/models'


#####################
# Models shortcuts

Country    = WorldDb::Model::Country

Person     = PersonDb::Model::Person

League      = SportDb::Model::League
Season      = SportDb::Model::Season
Event       = SportDb::Model::Event
Team        = SportDb::Model::Team
Roster      = SportDb::Model::Roster
Assoc       = SportDb::Model::Assoc
AssocAssoc  = SportDb::Model::AssocAssoc

Round      = SportDb::Model::Round
Group      = SportDb::Model::Group
Stage      = SportDb::Model::Stage
Game       = SportDb::Model::Game
GameCursor = SportDb::Model::GameCursor


EventStanding        = SportDb::Model::EventStanding
EventStandingEntry   = SportDb::Model::EventStandingEntry
GroupStanding        = SportDb::Model::GroupStanding
GroupStandingEntry   = SportDb::Model::GroupStandingEntry
AlltimeStanding      = SportDb::Model::AlltimeStanding
AlltimeStandingEntry = SportDb::Model::AlltimeStandingEntry


#################################
# setup db -> schema / tables

SportDb.setup_in_memory_db
