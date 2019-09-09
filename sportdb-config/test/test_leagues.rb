# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_leagues.rb


require 'helper'

class TestLeagues < MiniTest::Test

  def test_match
    pp SportDb::Import.config.leagues.errors

    SportDb::Import.config.leagues.dump_duplicates

    m = SportDb::Import.config.leagues.match( 'English Premier League' )
    assert_equal 'English Premier League', m[0].name
    assert_equal 'eng.1',                  m[0].key
    assert_equal 'England',                m[0].country.name
    assert_equal 'eng',                    m[0].country.key
  end

end # class TestLeagues
