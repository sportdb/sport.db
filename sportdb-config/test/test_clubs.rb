# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_clubs.rb


require 'helper'

class TestClubs < MiniTest::Test

  def test_duplicats
    club = SportDb::Import::Club.new
    club.name = "Rapid Wien"

    assert_equal false, club.duplicates?
    duplicates = {}
    assert_equal duplicates,  club.duplicates

    club.alt_names_auto += ['Rapid', 'Rapid Wien', 'SK Rapid Wien']

    pp club

    assert_equal true,              club.duplicates?
    duplicates = {'rapid wien'=>['Rapid Wien','Rapid Wien']}
    pp club.duplicates
    assert_equal duplicates, club.duplicates
  end

end # class TestClubs
