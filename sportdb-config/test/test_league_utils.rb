# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_league_utils.rb


require 'helper'

class TestLeagueUtils < MiniTest::Test

  def test_basename_eng
    assert_equal '1-premierleague',   LeagueUtils.basename( '1',  country: 'eng', season: '2011-12' )
    assert_equal '1-premierleague',   LeagueUtils.basename( '1',  country: 'eng' )
    assert_equal '1-premierleague',   LeagueUtils.basename( '1',  country: 'eng-england' ) ## allow country code or (repo) package name
    assert_equal '1-division1',       LeagueUtils.basename( '1',  country: 'eng', season: '1991-92' )
    assert_equal '3a',                LeagueUtils.basename( '3a', country: 'eng', season: '2011-12' )

    assert_equal '2-championship',    LeagueUtils.basename( '2',  country: 'eng', season: '2011-12' )
    assert_equal '2-championship',    LeagueUtils.basename( '2',  country: 'eng' )
    assert_equal '2-championship',    LeagueUtils.basename( '2',  country: 'eng-england' ) ## allow country code or (repo) package name
    assert_equal '2-division1',       LeagueUtils.basename( '2',  country: 'eng', season: '2003-04' )
    assert_equal '2-division2',       LeagueUtils.basename( '2',  country: 'eng', season: '1991-92' )
    assert_equal '2-division2',       LeagueUtils.basename( '2',  country: 'eng', season: '1989-90' )
  end  # method test_basename

  def test_basename_sco
    assert_equal '1-premiership',     LeagueUtils.basename( '1',  country: 'sco' )
    assert_equal '1-premierleague',   LeagueUtils.basename( '1',  country: 'sco', season: '2012-13' )
    assert_equal '1-premierdivision', LeagueUtils.basename( '1',  country: 'sco', season: '1997-98' )

    assert_equal '2-championship',    LeagueUtils.basename( '2',  country: 'sco' )
    assert_equal '2-division1',       LeagueUtils.basename( '2',  country: 'sco', season: '2012-13' )
  end

  def test_basename_fr
    assert_equal '1-ligue1',          LeagueUtils.basename( '1',  country: 'fr' )
    assert_equal '1-division1',       LeagueUtils.basename( '1',  country: 'fr', season: '2001-02' )
  end

  def test_basename_gr
    assert_equal '1-superleague',     LeagueUtils.basename( '1',  country: 'gr' )
    assert_equal '1-alphaethniki',    LeagueUtils.basename( '1',  country: 'gr', season: '2005-06' )
  end

end # class TestLeagueUtils
