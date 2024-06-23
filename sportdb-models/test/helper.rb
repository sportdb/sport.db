## minitest setup
require 'minitest/autorun'


$LOAD_PATH.unshift( './lib' )

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
Lineup      = SportDb::Model::Lineup
Assoc       = SportDb::Model::Assoc
AssocAssoc  = SportDb::Model::AssocAssoc

Round       = SportDb::Model::Round
Group       = SportDb::Model::Group
Stage       = SportDb::Model::Stage
Match       = SportDb::Model::Match
MatchCursor = SportDb::Model::MatchCursor


EventStanding        = SportDb::Model::EventStanding
EventStandingEntry   = SportDb::Model::EventStandingEntry
GroupStanding        = SportDb::Model::GroupStanding
GroupStandingEntry   = SportDb::Model::GroupStandingEntry
AlltimeStanding      = SportDb::Model::AlltimeStanding
AlltimeStandingEntry = SportDb::Model::AlltimeStandingEntry


#################################
# setup db -> schema / tables

SportDb.open_mem  # was setup_in_memory_db

## test helpers here
SportDb.delete!
SportDb.tables
