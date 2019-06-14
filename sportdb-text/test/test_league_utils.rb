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



  def test_read_txt

    hash = SportDb::Import::LeagueReader.read( <<TXT)
1  =>  premierleague,   English Premier League
2  =>  championship,    English Championship League
3  =>  league1,         English League 1
4  =>  league2,         English League 2
5  =>  conference,      English Conference

#########################################
# until (including) 2003-04 season

[2003-04]    # or just use 2003-04: or similar - why? why not?
             # or use 2003/04 - 1992/93 - why? why not?

1 => premierleague,   English Premier League
2 => division1,       English Division 1
3 => division2,       English Division 2
4 => division3,       English Division 3


#############################################
# note: in season 1992/93 the premier league starts
#        until (including) 1991-92} season

[1991-92]
1  => division1,   English Division 1
2  => division2,   English Division 2
3  => division3,   English Division 3
3a => division3n,  English Division 3 (North)
3b => division3s,  English Division 3 (South)
4  => division4,   English Division 4      ## check if real?
TXT


   assert_equal 'premierleague', hash['*']['1']
   assert_equal 'championship',  hash['*']['2']
   assert_equal 'league1',       hash['*']['3']

   assert_equal 'division1', hash['1991-92']['1']
   assert_equal 'division2', hash['1991-92']['2']
  end  # method test_parse_leagues_txt
end # class TestLeagueUtils
