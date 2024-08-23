###
#  to run use
#     ruby test/test_clubs.rb


require_relative 'helper'


class TestClubs < Minitest::Test

  Club = Sports::Club


  def test_new
    club = Club.new( name: 'Rapid Wien' )

    assert_equal 'Rapid Wien',   club.name
    assert_equal ['Rapid Wien'], club.names
  end

end # class TestClubs
