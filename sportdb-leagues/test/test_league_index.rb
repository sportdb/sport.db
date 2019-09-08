# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_league_index.rb


require 'helper'

class TestLeagueIndex < MiniTest::Test

  def test_match

    recs = SportDb::Import::LeagueReader.parse( <<TXT )
= England (eng) =
1       English Premier League
          | ENG PL | England Premier League | Premier League
2       English Championship
          | ENG CS | England Championship | Championship
3       English League One
          | ENG 1  | England League One | League One
4       English League Two
5       English National League

cup      EFL Cup
          | League Cup | Football League Cup
          | ENG LC | England Liga Cup

= Scotland (sco) =
1       Scottish Premiership
2       Scottish Championship
3       Scottish League One
4       Scottish League Two
TXT

   leagues = SportDb::Import::LeagueIndex.new
   leagues.add( recs )

    pp leagues.errors

    leagues.dump_duplicates

    m = leagues.match( 'English Premier League' )
    assert_equal 'English Premier League', m[0].name
    assert_equal 'eng.1',                  m[0].key
    assert_equal 'England',                m[0].country.name
    assert_equal 'eng',                    m[0].country.key

    m = leagues.match( 'english premier league' )
    assert_equal 'English Premier League', m[0].name
    assert_equal 'eng.1',                  m[0].key
    assert_equal 'England',                m[0].country.name
    assert_equal 'eng',                    m[0].country.key

    m = leagues.match( 'englishpremierleague' )
    assert_equal 'English Premier League', m[0].name
    assert_equal 'eng.1',                  m[0].key
    assert_equal 'England',                m[0].country.name
    assert_equal 'eng',                    m[0].country.key

    ## note: all dots (.) get always removed
    m = leagues.match( '...e.n.g.l.i.s.h.p.r.e.m.i.e.r.l.e.a.g.u.e...' )
    assert_equal 'English Premier League', m[0].name
    assert_equal 'eng.1',                  m[0].key
    assert_equal 'England',                m[0].country.name
    assert_equal 'eng',                    m[0].country.key

    ## note: all spaces and dashes (-) get always removed
    m = leagues.match( '--- e n g l i s h  p r e m i e r  l e a g u e ---' )
    assert_equal 'English Premier League', m[0].name
    assert_equal 'eng.1',                  m[0].key
    assert_equal 'England',                m[0].country.name
    assert_equal 'eng',                    m[0].country.key

    m = leagues.match( 'ENGLISH PREMIER LEAGUE' )
    assert_equal 'English Premier League', m[0].name
    assert_equal 'eng.1',                  m[0].key
    assert_equal 'England',                m[0].country.name
    assert_equal 'eng',                    m[0].country.key

    ## check alt names
    m = leagues.match( 'ENG PL' )
    assert_equal 'English Premier League', m[0].name
    assert_equal 'eng.1',                  m[0].key
    assert_equal 'England',                m[0].country.name
    assert_equal 'eng',                    m[0].country.key
end

end # class TestLeagueIndex
