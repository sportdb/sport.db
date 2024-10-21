###
#  to run use
#     ruby test/test_leagues.rb


require_relative 'helper'

class TestLeagues < Minitest::Test

  League       = CatalogDb::Metal::League

  def test_match
    m = League.match_by_name( 'English Premier League' )
    pp m
    assert_equal 'Premier League',         m[0].name
    assert_equal 'England',                m[0].country.name
    assert_equal 'eng',                    m[0].country.key
    assert                                 m[0].clubs?
    assert                                 m[0].domestic?
    assert_equal false,                    m[0].intl?
    assert_equal false,                    m[0].national_teams?

    m = League.match_by_name( 'Euro' )
    pp m
    assert_equal 'Euro',                   m[0].name
    assert                                 m[0].national_teams?
    assert                                 m[0].intl?
    assert_equal false,                    m[0].clubs?
  end

end # class TestLeagues
