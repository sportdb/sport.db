# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_clubs.rb


require 'helper'

class TestClubs < MiniTest::Test

  Club = SportDb::Import::Club

  def test_create
    club = Club.create( name: 'Rapid Wien' )

    assert_equal 'Rapid Wien',   club.name
    assert_equal ['Rapid Wien'], club.names
  end


  def test_duplicates
    club = Club.new
    club.name = 'Rapid Wien'

    assert_equal false, club.duplicates?
    duplicates = {}
    assert_equal duplicates,  club.duplicates

    club.alt_names_auto += ['Rapid', 'Rapid Wien', 'SK Rapid Wien']

    pp club

    assert_equal true,              club.duplicates?
    duplicates = {'rapidwien'=>['Rapid Wien','Rapid Wien']}
    pp club.duplicates
    assert_equal duplicates, club.duplicates
  end

end # class TestClubs
