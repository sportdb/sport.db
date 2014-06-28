# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_squad_reader.rb
#  or better
#     rake -I ./lib test


require 'helper'

class TestSquadReader < MiniTest::Unit::TestCase

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
    personreader.read( 'players/south-america/br-brazil/players', country_id: br.id ) 

    assert_equal 30, Person.count

    bra = Team.create!( key: 'bra', title: 'Brazil', code: 'BRA', country_id: br.id )


    event = Event.find_by_key!( 'world.2014' )

    reader = SquadReader.new( SportDb.test_data_path )
    reader.read( 'world-cup/2014/squads/br-brazil', team_id: bra.id, event_id: event.id )

    assert_equal 23, Roster.count
  end  # method test_br


  def test_de
    de  = Country.create!( key: 'de', title: 'Germany', code: 'GER', pop: 1, area: 1)

    ## read persons
    personreader = PersonReader.new( SportDb.test_data_path )
    personreader.read( 'players/europe/de-deutschland/players', country_id: de.id ) 

    assert_equal 27, Person.count

    ger = Team.create!( key: 'ger', title: 'Germany', code: 'GER', country_id: de.id )

    event = Event.find_by_key!( 'world.2014' )

    reader = SquadReader.new( SportDb.test_data_path )
    reader.read( 'world-cup/2014/squads/de-deutschland', team_id: ger.id, event_id: event.id )

    assert_equal 3, Roster.count
  end  # method test_de


  def test_uy
    uy = Country.create!( key: 'uy', title: 'Uruguay', code: 'URU', pop: 1, area: 1)

    assert_equal 0, Person.count
    assert_equal 0, Roster.count

    uru = Team.create!( key: 'uru', title: 'Uruguay', code: 'URU', country_id: uy.id )

    event = Event.find_by_key!( 'world.2014' )

    reader = SquadReader.new( SportDb.test_data_path )
    reader.read( 'world-cup/2014/squads/uy-uruguay', team_id: uru.id, event_id: event.id )

    assert_equal 23, Roster.count
    assert_equal 23, Person.count
  end  # method test_uy


  def test_jp
    jp = Country.create!( key: 'jp', title: 'Japan', code: 'JPN', pop: 1, area: 1)

    assert_equal 0, Person.count
    assert_equal 0, Roster.count

    jpn = Team.create!( key: 'jpn', title: 'Japan', code: 'JPN', country_id: jp.id )

    event = Event.find_by_key!( 'world.2014' )

    reader = SquadReader.new( SportDb.test_data_path )
    reader.read( 'world-cup/2014/squads/jp-japan', team_id: jpn.id, event_id: event.id )

    assert_equal 23, Roster.count
    assert_equal 23, Person.count
  end  # method test_jp


end # class TestSquadReader
