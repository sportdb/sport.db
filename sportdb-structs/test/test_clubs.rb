###
#  to run use
#     ruby -I ./lib -I ./test test/test_clubs.rb


require_relative 'helper'


class TestClubs < Minitest::Test

  Club = Sports::Club


  def test_new
    club = Club.new( name: 'Rapid Wien' )

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
