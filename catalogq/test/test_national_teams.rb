###
#  to run use
#     ruby -I ./lib -I ./test test/test_national_teams.rb


require 'helper'

class TestNationalTeams < MiniTest::Test

  NATIONAL_TEAMS = SportDb::Import.catalog.national_teams


  def test_find
    t = NATIONAL_TEAMS.find( 'AUT' )
    assert_equal 'Austria', t.name
    assert_equal 'aut',     t.key
    assert_equal 'AUT',     t.code


    t = NATIONAL_TEAMS.find( 'England' )
    assert_equal 'England', t.name
    assert_equal 'eng',     t.key
    assert_equal 'ENG',     t.code

    ## note: all dots (.) get always removed
    t = NATIONAL_TEAMS.find( '...e.n.g.l.a.n.d...' )
    assert_equal 'England', t.name
    assert_equal 'eng',     t.key
    assert_equal 'ENG',     t.code

    ## note: all spaces and dashes (-) get always removed
    t = NATIONAL_TEAMS.find( '--- e n g l a n d ---' )
    assert_equal 'England', t.name
    assert_equal 'eng',     t.key
    assert_equal 'ENG',     t.code
  end

end  # class TestNationalTeams
