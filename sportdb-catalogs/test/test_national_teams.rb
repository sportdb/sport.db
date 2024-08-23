###
#  to run use
#     ruby test/test_national_teams.rb


require_relative 'helper'


class TestNationalTeams < Minitest::Test


  NationalTeam = CatalogDb::Metal::NationalTeam


  def test_find
    t = NationalTeam.find( 'AUT' )
    assert_equal 'Austria', t.name
    assert_equal 'aut',     t.key
    assert_equal 'AUT',     t.code


    t = NationalTeam.find( 'England' )
    assert_equal 'England', t.name
    assert_equal 'eng',     t.key
    assert_equal 'ENG',     t.code

    ## note: all dots (.) get always removed
    t = NationalTeam.find( '...e.n.g.l.a.n.d...' )
    assert_equal 'England', t.name
    assert_equal 'eng',     t.key
    assert_equal 'ENG',     t.code

    ## note: all spaces and dashes (-) get always removed
    t = NationalTeam.find( '--- e n g l a n d ---' )
    assert_equal 'England', t.name
    assert_equal 'eng',     t.key
    assert_equal 'ENG',     t.code
  end

end  # class TestNationalTeams
