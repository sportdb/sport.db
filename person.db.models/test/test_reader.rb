# encoding: utf-8

require 'helper'


class TestReader < MiniTest::Test

  def setup  # runs before every test
    PersonDb.delete!   # always clean-out tables
    WorldDb.delete!
    add_world
  end

  def add_world
    ## add some counties
    Country.create!( key: 'br', title: 'Brazil', code: 'BRA', pop: 0, area: 0 )
  end

  def test_read
    br = Country.find_by!( key: 'br' )

    path = "#{PersonDb.test_data_path}/players/south-america/br-brazil/players.txt"
    reader = PersonReader.from_file( path, country_id: br.id )
    reader.read

    assert_equal  23, Person.count
    assert_equal  23, br.persons.count
    
    jefferson = Person.find_by_key!( 'jefferson' )
    assert_equal 'Jefferson De Oliveira Galvao', jefferson.synonyms
    ## todo: add more asserts - use assert_persons ?

  end

end # class TestReader

