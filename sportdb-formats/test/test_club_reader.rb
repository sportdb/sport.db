###
#  to run use
#     ruby test/test_club_reader.rb


require_relative 'helper'

class TestClubReader < Minitest::Test

  def test_parse_ii   ## test club/team B/II
    recs = SportDb::Import::ClubReader.parse( <<TXT )
= Austria

FK Austria Wien, Wien
   | Austria Vienna | Austria Wien
  Fischhofgasse 12 ~ 1100 Wien    ## address line style a
  Fischhofgasse 12 ++ 1100 Wien   ## address line style b
  Fischhofgasse 12 // 1100 Wien   ## address line style c
(ii) Young Violets Austria Wien
   | Young Violets A. W.

SK Rapid Wien, Wien
  | Rapid Vienna | Rapid Wien
 Keisslergasse 3 ~ 1140 Wien     ## address line style a
 Keisslergasse 3 +++ 1140 Wien   ## address line style b
 Keisslergasse 3 /// 1140 Wien   ## address line style c
(2) SK Rapid Wien II
  | Rapid Wien Am.
TXT

    pp recs

    assert_equal 4, recs.size
    assert_equal 'FK Austria Wien',             recs[0].name
    assert_equal 'Young Violets Austria Wien',  recs[0].b.name
    assert_equal 'Wien',                        recs[0].city
    assert       recs[0].a?
    assert       recs[0].b? == false

    assert_equal 'Young Violets Austria Wien',  recs[1].name
    assert_equal 'FK Austria Wien',             recs[1].a.name
    assert_equal 'Wien',                        recs[1].city
    assert       recs[1].a? == false
    assert       recs[1].b?


    assert_equal 'SK Rapid Wien',    recs[2].name
    assert_equal 'SK Rapid Wien II', recs[2].b.name
    assert_equal 'Wien',             recs[2].city
    assert       recs[2].a?
    assert       recs[2].b? == false

    assert_equal 'SK Rapid Wien II', recs[3].name
    assert_equal 'SK Rapid Wien',    recs[3].a.name
    assert_equal 'Wien',             recs[3].city
    assert       recs[3].a? == false
    assert       recs[3].b?
  end

  def test_parse_at
    recs = SportDb::Import::ClubReader.parse( <<TXT )
==================================
=  Austria

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
    recs = SportDb::Import::ClubReader.parse( <<TXT )
==================================================
=  United States

#######################################
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
    recs = SportDb::Import::ClubReader.parse( <<TXT )
= United States
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
    recs = SportDb::Import::ClubReader.parse( <<TXT )
=  England
== Greater London

Fulham FC, 1879,  @ Craven Cottage,   London (Fulham)   › Greater London
  | Fulham | FC Fulham
Charlton Athletic FC,  @ The Valley,  London (Charlton) › Greater London
  | Charlton | Charlton Athletic

=  Deutschland
== Hamburg

St. Pauli,   Hamburg (St. Pauli)
TXT

    pp recs

    assert_equal 3, recs.size
    assert_equal 'London',           recs[0].city
    assert_equal 'Fulham',           recs[0].district
    assert_equal ['Greater London'], recs[0].geos
    assert_equal 'England',          recs[0].country.name
    assert_equal 'eng',              recs[0].country.key

    assert_equal 'London',           recs[1].city
    assert_equal 'Charlton',         recs[1].district
    assert_equal ['Greater London'], recs[1].geos
    assert_equal 'England',          recs[1].country.name
    assert_equal 'eng',              recs[1].country.key

    assert_equal 'Hamburg',          recs[2].city
    assert_equal 'St. Pauli',        recs[2].district
    assert_equal ['Hamburg'],        recs[2].geos
    assert_equal 'Germany',          recs[2].country.name
    assert_equal 'de',               recs[2].country.key
  end


  def test_parse_headings
    recs = SportDb::Import::ClubReader.parse( <<TXT )
==============
====
===========
## note: Heading 1  - always expects / requires country as text for now
= Austria
= Austria ==================
== Heading 2
== Heading 2 =========
=== Heading 3
=== Heading 3 ===============
=== Heading 3             # with end-of-line comment
=== Heading 3             ## with end-of-line comment
=== Heading 3 =========   # with end-of-line comment
== Heading 2
==== Heading 4
= ?????
== ???
TXT

    pp recs

    assert_equal 0, recs.size
  end

end # class TestClubReader
