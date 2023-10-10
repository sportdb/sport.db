# encoding: utf-8


require 'helper'


class TestModels < MiniTest::Test

  def setup  # runs before every test
    PersonDb.delete!   # always clean-out tables
    WorldDb.delete!
    add_world
  end

  def add_world
    ## add some counties
    at          = Country.create!( key: 'at', title: 'Austria', code: 'AUT', pop: 0, area: 0 )
    n           = State.create!( key: 'n', title: 'Niederösterreich', country_id: at.id )
    feuersbrunn = City.create!( key: 'feuersbrunn', title: 'Feuersbrunn', country_id: at.id, state_id: n.id )
  end


  def test_worlddb_assocs
    at          =  Country.find_by!( key: 'at' )
    n           =  State.find_by!( key: 'n' )
    feuersbrunn =  City.find_by!( key: 'feuersbrunn' )

    assert_equal 0, at.persons.count
    assert_equal 0, n.persons.count
    assert_equal 0, feuersbrunn.persons.count
  end

  def test_count
    assert_equal 0, Person.count

    PersonDb.tables  # print stats
  end

end # class TestModels
