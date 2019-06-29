# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_team_reader.rb


require 'helper'

class TestTeamReader < MiniTest::Test

  def test_parse_at
    recs = SportDb::Import::TeamReader.parse( <<TXT )
##########################
#  Austria (AUT), at

FK Austria Wien, Wien
  | Austria Vienna | Austria Wien
SK Rapid Wien, Wien
  | Rapid Vienna | Rapid Wien
Wiener Sport-Club, Wien
TXT

    pp recs

    assert_equal 3, recs.size
    assert_equal 'FK Austria Wien',  recs[0].name
    assert_equal 'Wien',             recs[0].city
  end

  def test_parse_us
    recs = SportDb::Import::TeamReader.parse( <<TXT )
######################################################
# Major League Soccer (MLS) teams

Atlanta United FC, 2017,  Atlanta       › Georgia
  | Atlanta United
Chicago Fire, 1998,  Bridgeview    › Illinois
FC Dallas, 1996,  Frisco        › Texas     ## note: FC Dallas named >Dallas Burn< from 1996-2004

##################################
#  Defunct / Historic
Miami Fusion     (1998-2001),  Fort Lauderdale › Florida
CD Chivas USA    (2005-2014),  Carson          › California
  | Chivas USA
TXT

    pp recs

    assert_equal 5, recs.size
    assert_equal 'Atlanta United FC',  recs[0].name
    assert_equal 2017,                 recs[0].year
    assert_equal 'Atlanta › Georgia',  recs[0].city
  end

end # class TestTeamReader
