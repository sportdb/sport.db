# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_clubs.rb


require 'helper'

class TestClubs < MiniTest::Test


  def match1( txt ) SportDb::Import::Configuration::CLUBS_REGEX1.match( txt ); end
  def match2( txt ) SportDb::Import::Configuration::CLUBS_REGEX2.match( txt ); end

  def test_find_clubs
    m = match1( 'de.clubs.txt' )
    assert_equal 'de', m[:country]

    m = match1( 'deutschland/de.clubs.txt' )
    assert_equal 'de', m[:country]

    m = match2( 'europe/de-deutschland/clubs.txt' )
    assert_equal 'de', m[:country]

    m = match2( 'de-deutschland/clubs.txt' )
    assert_equal 'de', m[:country]


    assert match1( 'clubs.txt' ) == nil
    assert match2( 'clubs.txt' ) == nil
    assert match1( 'deutschland/clubs.txt' ) == nil
    assert match2( 'deutschland/clubs.txt' ) == nil
  end

end # class TestClubs
