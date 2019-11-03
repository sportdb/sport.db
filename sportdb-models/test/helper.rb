
## $:.unshift(File.dirname(__FILE__))

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



####################
# Reader shortcuts

Reader                  = SportDb::Reader
TeamReader              = SportDb::TeamReader
TeamIndexer             = SportDb::TeamIndexer
AssocReader             = SportDb::AssocReader
SeasonReader            = SportDb::SeasonReader
LeagueReader            = SportDb::LeagueReader
EventReader             = SportDb::EventReader
EventMetaReader         = SportDb::EventMetaReader
EventTableReader        = SportDb::EventTableReader
GameReader              = SportDb::GameReader
NationalTeamSquadReader = SportDb::NationalTeamSquadReader
ClubSquadReader         = SportDb::ClubSquadReader

## moved to racing.db  - remove/delete!!
## RaceTeamReader     = SportDb::RaceTeamReader

PersonReader       = PersonDb::PersonReader

######
# New Reader ShortCuts

module TestPrettyPrinter
  def self.from_file( name, opts={} )
    SportDb::PrettyPrinter.from_file( "#{SportDb.test_data_path}/#{name}.txt", opts )
  end
end


module TestTeamReader
  def self.from_file( name, more_attribs={} )
    TeamReader.from_file( "#{SportDb.test_data_path}/#{name}.txt", more_attribs )
  end
end

module TestTeamIndexer
  def self.from_file( name, more_attribs={} )
    TeamIndexer.from_file( "#{SportDb.test_data_path}/#{name}.txt", more_attribs )
  end
end


module TestClubSquadReader
  def self.from_file( name, more_attribs={} )
    ClubSquadReader.from_file( "#{SportDb.test_data_path}/#{name}.txt", more_attribs )
  end
end

module TestNationalTeamSquadReader
  def self.from_file( name, more_attribs={} )
    NationalTeamSquadReader.from_file( "#{SportDb.test_data_path}/#{name}.txt", more_attribs )
  end
end

module TestLeagueReader
  def self.from_file( name, more_attribs={} )
    LeagueReader.from_file( "#{SportDb.test_data_path}/#{name}.txt", more_attribs )
  end
end

module TestSeasonReader
  def self.from_file( name )
    SeasonReader.from_file( "#{SportDb.test_data_path}/#{name}.txt" )
  end
end

module TestEventReader
  def self.from_file( name )
    EventReader.from_file( "#{SportDb.test_data_path}/#{name}.yml" )
  end
end

module TestEventMetaReader
  def self.from_file( name )
    EventMetaReader.from_file( "#{SportDb.test_data_path}/#{name}.yml" )
  end
end

module TestEventTableReader
  def self.from_file( name )
    EventTableReader.from_file( "#{SportDb.test_data_path}/#{name}.txt" )
  end
end


module TestGameReader
  ## NOTE: pass in .yml as path (that is, event config!!!!)
  def self.from_file( name, more_attribs={} )
    GameReader.from_file( "#{SportDb.test_data_path}/#{name}.yml", more_attribs )
  end
end

module TestAssocReader
  def self.from_file( name )
    AssocReader.from_file( "#{SportDb.test_data_path}/#{name}.txt" )
  end
end



#################################
# setup db -> schema / tables

SportDb.setup_in_memory_db
