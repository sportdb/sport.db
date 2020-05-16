# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_reader.rb
#  or better
#     rake -I ./lib test


require 'helper'

class TestReader < MiniTest::Unit::TestCase

  def setup
    WorldDb.delete!
    SportDb.delete!
    FootballDb.delete!
    PersonDb.delete!

    add_mls_2014
  end

  def add_mls_2014
    SportDb.read_builtin    ## add (builtin) seasons (e.g. 2014)

    us   = Country.create!( key: 'us', name: 'United States', code: 'USA', pop: 1, area: 1)

    ## fix: change title: to name:
    League.create!( key: 'mls', title: 'Major League Soccer', country_id: us.id )
    Team.create!( key: 'chicago', title: 'Chicago Fire', code: 'CHI', country_id: us.id )

    assert_equal 1, League.count
    assert_equal 1, Team.count

    ### todo/fix:
    ## juse EventReader instead of GameReader
    ##  remove mls.txt empty fixture file

    ### todo/fix: change/will get renamed to MatchReader
    reader = GameReader.new( FootballDb.test_data_path )
    reader.read( 'major-league-soccer/2014/mls' )

    assert_equal 1, Event.count
    
    mls = Event.find_by_key!( 'mls.2014' )
    assert_equal 1, mls.teams.count   # note: for testing only one team included for now (chicago)
  end


  def test_stats_reader
    assert_equal 0, Person.count
    assert_equal 0, Roster.count    ## note: will get renames to Squad
    assert_equal 0, PlayerStat.count

    ## now add some persons
    ##
    #  todo/fix: SquadsReader -  for mapping do NOT depend on country for clubs

#    seanjohnson    = Person.create!( key: 'seanjohnson',    name: 'Sean Johnson' )
#    gregcochrane   = Person.create!( key: 'gregcochrane',   name: 'Greg Cochrane' )
#    quincyamarikwa = Person.create!( key: 'quincyamarikwa', name: 'Quincy Amarikwa' )

#    assert_equal 3, Person.count
    
    mls     = Event.find_by_key!( 'mls.2014' )
    chicago = Team.find_by_key!( 'chicago' )
    
    squadreader = SquadReader.new( FootballDb.test_data_path )
    squadreader.read( 'major-league-soccer/2014/squads/chicago', team_id: chicago.id, event_id: mls.id )
    
    assert_equal 3, Roster.count   ## note: will get renames to Squad
    
    statreader = PlayerStatReader.new( FootballDb.test_data_path )
    statreader.read( 'major-league-soccer/2014/squads/chicago', team_id: chicago.id, event_id: mls.id )
  end


end # class TestReader
