# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_national_team_reader.rb
#  or better
#     rake -I ./lib test


require 'helper'

class TestNationalTeamReader < MiniTest::Unit::TestCase

  def setup
    WorldDb.delete!
    SportDb.delete!
    PersonDb.delete!
    
    add_world_cup_2014
  end

  def add_world_cup_2014
    SportDb.read_builtin   # add 2014 season

    leaguereader = LeagueReader.new( SportDb.test_data_path )
    leaguereader.read( 'world-cup/leagues' )

    assert_equal 1, League.count

    l = League.find_by_key!( 'world' )
    assert_equal 'World Cup', l.title

    gamereader = GameReader.new( SportDb.test_data_path )
    gamereader.read( 'world-cup/2014/cup' )

    assert_equal 1, Event.count
  end

  def test_br
    br  = Country.create!( key: 'br', title: 'Brazil', code: 'BRA', pop: 1, area: 1)
    
    ## read persons
    personreader = PersonReader.new( SportDb.test_data_path )
    personreader.read( 'players/br-brazil', country_id: br.id ) 

    assert_equal 30, Person.count

    bra = Team.create!( key: 'bra', title: 'Brazil', code: 'BRA', country_id: br.id )


    event = Event.find_by_key!( 'world.2014' )

    reader = NationalTeamReader.new( SportDb.test_data_path )
    reader.read( 'world-cup/2014/squads/br-brazil', country_id: br.id, event_id: event.id )

    assert_equal 23, Roster.count
  end  # method test_br


  def test_de
    de  = Country.create!( key: 'de', title: 'Germany', code: 'GER', pop: 1, area: 1)

    ## read persons
    personreader = PersonReader.new( SportDb.test_data_path )
    personreader.read( 'players/de-deutschland', country_id: de.id ) 

    assert_equal 27, Person.count

    ger = Team.create!( key: 'ger', title: 'Germany', code: 'GER', country_id: de.id )

    event = Event.find_by_key!( 'world.2014' )

    reader = NationalTeamReader.new( SportDb.test_data_path )
    reader.read( 'world-cup/2014/squads/de-deutschland', country_id: de.id, event_id: event.id )

    assert_equal 3, Roster.count
  end  # method test_de


end # class TestNationalTeamReader
