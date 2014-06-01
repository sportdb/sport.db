# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_assoc_reader.rb
#  or better
#     rake -I ./lib test


require 'helper'

class TestAssocReader < MiniTest::Unit::TestCase

  def setup
    WorldDb.delete!
    SportDb.delete!
    PersonDb.delete!
  end

  def test_fifa
    reader = AssocReader.new( SportDb.test_data_path )
    reader.read( 'national-teams/assocs' )

    assert_equal 20, Assoc.count
    
    fifa = Assoc.find_by_key!( 'fifa' )
    
    assert_equal 'Fédération Internationale de Football Association (FIFA)', fifa.title
    assert_equal 1904, fifa.since
    assert_equal 'www.fifa.com', fifa.web

    uefa = Assoc.find_by_key!( 'uefa' )

    assert_equal 'Union of European Football Associations (UEFA)', uefa.title
    assert_equal 1954, uefa.since
    assert_equal 'www.uefa.com', uefa.web
  end  # method test_fifa


end # class TestAssocReader
