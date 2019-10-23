# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_league.rb


require 'helper'

class TestLeague < MiniTest::Test

  def test_match
    m = League.match( 'English Premier League' )
    assert_equal 'English Premier League', m[0].name
    assert_equal 'eng.1',                  m[0].key
    assert_equal 'England',                m[0].country.name

    m = League.match( 'ENG PL' )
    assert_equal 'English Premier League', m[0].name
    assert_equal 'eng.1',                  m[0].key
    assert_equal 'England',                m[0].country.name
  end

  def test_match_by
    m = League.match( 'Premier League' )
    assert m.size > 1     ## more than one match expected

    m = League.match_by( name: 'Premier League', country: 'eng' )
    assert_equal 'English Premier League', m[0].name
    assert_equal 'eng.1',                  m[0].key
    assert_equal 'England',                m[0].country.name
end

end # class TestLeague
