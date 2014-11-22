# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_load.rb
#  or better
#     rake -I ./lib test


require 'helper'

class TestLoad < MiniTest::Test

  def setup
    WorldDb.delete!
    SportDb.delete!
    PersonDb.delete!
    SportDb.read_builtin   # add 2014 season
  end


  def test_br
    br  = Country.create!( key: 'br', title: 'Brazil', code: 'BRA', pop: 1, area: 1)
    bra = Team.create!( key: 'bra', title: 'Brazil', code: 'BRA', country_id: br.id )

    reader = Reader.new( SportDb.test_data_path ) 

    ## fix: add to country_matcher - allow players/br-brazil.txt e.g. country encode in file
    ## reader.load( 'players/south-america/br-brazil/players' )
    ## assert_equal 30, Person.count

    reader.load( 'world-cup/leagues' )
    assert_equal 1, League.count
    reader.load( 'world-cup/2014/cup' )
    assert_equal 1, Event.count

    reader.load( 'world-cup/2014/squads/br-brazil' )
    assert_equal 23, Roster.count
  end  # method test_br


  def test_de
    de  = Country.create!( key: 'de', title: 'Germany', code: 'GER', pop: 1, area: 1)
    ger = Team.create!( key: 'ger', title: 'Germany', code: 'GER', country_id: de.id )

    reader = Reader.new( SportDb.test_data_path ) 

    ## reader.load( 'players/europe/de-deutschland/players' )
    ## assert_equal 27, Person.count

    reader.load( 'world-cup/leagues' )
    assert_equal 1, League.count
    reader.load( 'world-cup/2014/cup' )
    assert_equal 1, Event.count

    reader.load( 'world-cup/2014/squads/de-deutschland' )
    assert_equal 3, Roster.count
  end  # method test_de


end # class TestLoad
