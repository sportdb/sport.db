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
    assert_equal 'Atlanta',            recs[0].city
    assert_equal ['Georgia'],          recs[0].geos
  end


  def test_parse_years
    recs = SportDb::Import::TeamReader.parse( <<TXT )
FC Dallas (1996-),         Frisco        › Texas
Miami Fusion (1998-2001),  Fort Lauderdale › Florida
CD Chivas USA (-2014),     Carson          › California
TXT

    pp recs

    assert_equal 3, recs.size
    assert_equal 1996,   recs[0].year
    assert_equal false,  recs[0].historic?
    assert_equal false,  recs[0].past?

    assert_equal 1998,   recs[1].year
    assert_equal 2001,   recs[1].year_end
    assert_equal true,   recs[1].historic?
    assert_equal true,   recs[1].past?

    assert_equal 2014,   recs[2].year_end
    assert_equal true,   recs[2].historic?
    assert_equal true,   recs[2].past?
  end

  def test_parse_geos
    recs = SportDb::Import::TeamReader.parse( <<TXT )
#
Fulham FC, 1879,  @ Craven Cottage,   London (Fulham)   › Greater London
  | Fulham | FC Fulham
Charlton Athletic FC,  @ The Valley,  London (Charlton) › Greater London
  | Charlton | Charlton Athletic

St. Pauli,   Hamburg (St. Pauli)
TXT

    pp recs

    assert_equal 3, recs.size
    assert_equal 'London',           recs[0].city
    assert_equal 'Fulham',           recs[0].district
    assert_equal ['Greater London'], recs[0].geos

    assert_equal 'London',           recs[1].city
    assert_equal 'Charlton',         recs[1].district
    assert_equal ['Greater London'], recs[1].geos

    assert_equal 'Hamburg',          recs[2].city
    assert_equal 'St. Pauli',        recs[2].district
  end
end # class TestTeamReader
