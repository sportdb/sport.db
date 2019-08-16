# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_club_index.rb


require 'helper'

class TestClubIndex < MiniTest::Test

  def test_match
    
    recs = SportDb::Import::ClubReader.parse( <<TXT )
=================================
=  Österreich • Austria (at)

== Wien ==

FK Austria Wien,   Wien (Favoriten)
  | Austria Vienna | Austria Wien
SK Rapid Wien,     Wien (Hütteldorf)
  | Rapid Vienna | Rapid Wien


====================================
=  England (eng)

Arsenal FC, 1886, @ Emirates Stadium, London   ## Greater London
  | Arsenal | FC Arsenal
Chelsea FC, 1905, @ Stamford Bridge, London   ## Greater London
  | Chelsea | FC Chelsea


=====================================
=  Russia (ru)

Arsenal Tula,  Tula
  | Arsenal | FC Arsenal Tula


===========================
=  Argentina (ar)

== Buenos Aires ==

Arsenal de Sarandí,  Sarandí › Buenos Aires    #  Sarandí es una ciudad de la Zona Sur del Gran Buenos Aires
  | Arsenal | Arsenal Sarandi
  | Arsenal FC | Arsenal Fútbol Club
TXT    

    pp SportDb::Import.config.clubs.errors

    SportDb::Import.config.clubs.dump_duplicates

    m = SportDb::Import.config.clubs.match( 'Rapid Wien' )
    assert_equal 'SK Rapid Wien', m[0].name
    assert_equal 'Austria',       m[0].country.name
    assert_equal 'Wien',          m[0].city

    m = SportDb::Import.config.clubs.match( 'rapid wien' )
    assert_equal 'SK Rapid Wien', m[0].name
    assert_equal 'Austria',       m[0].country.name
    assert_equal 'Wien',          m[0].city

    ## note: all dots (.) get always removed
    m = SportDb::Import.config.clubs.match( '...r.a.p.i.d w.i.e.n...' )
    assert_equal 'SK Rapid Wien', m[0].name
    assert_equal 'Austria',       m[0].country.name
    assert_equal 'Wien',          m[0].city

    ## note: all spaces and dashes (-) get always removed
    m = SportDb::Import.config.clubs.match( '--- r a p i d  w i e n ---' )
    assert_equal 'SK Rapid Wien', m[0].name
    assert_equal 'Austria',       m[0].country.name
    assert_equal 'Wien',          m[0].city

    m = SportDb::Import.config.clubs.match( 'RAPID WIEN' )
    assert_equal 'SK Rapid Wien', m[0].name
    assert_equal 'Austria',       m[0].country.name
    assert_equal 'Wien',          m[0].city


    c = SportDb::Import.config.clubs[ 'SK Rapid Wien' ]   ## check canoncial name match (only)
    assert_equal 'SK Rapid Wien', c.name
    assert_equal 'Austria',       c.country.name
    assert_equal 'Wien',          c.city


    m = SportDb::Import.config.clubs.match( 'Arsenal' )
    assert_equal 3, m.size

    m = SportDb::Import.config.clubs.match( 'ARSENAL' )
    assert_equal 3, m.size

    m = SportDb::Import.config.clubs.match_by( name: 'Arsenal', country: 'eng' )
    assert_equal 1, m.size
    assert_equal 'Arsenal FC', m[0].name
    assert_equal 'England',    m[0].country.name
    assert_equal 'London',     m[0].city

    m = SportDb::Import.config.clubs.match_by( name: 'Arsenal', country: 'ar' )
    assert_equal 1, m.size
    assert_equal 'Arsenal de Sarandí', m[0].name
    assert_equal 'Argentina',          m[0].country.name
    assert_equal 'Sarandí',            m[0].city

    m = SportDb::Import.config.clubs.match_by( name: 'Arsenal', country: 'ru' )
    assert_equal 1, m.size
    assert_equal 'Arsenal Tula', m[0].name
    assert_equal 'Russia',       m[0].country.name
    assert_equal 'Tula',         m[0].city


    m = SportDb::Import.config.clubs.match( 'Arsenal FC' )
    assert_equal 2, m.size

    m = SportDb::Import.config.clubs.match( 'Arsenal F.C.' )
    assert_equal 2, m.size

    m = SportDb::Import.config.clubs.match( '...A.r.s.e.n.a.l... F.C...' )
    assert_equal 2, m.size

def test_wikipedia    # test wikipedia names and links/urls

   recs = SportDb::Import::ClubReader.parse( <<TXT )
==================================
=  Belgium (be)

== Brussels ==

RSC Anderlecht, 1908,   Brussels      ## use (just) Anderlecht or Brussel-Anderlecht ??
  | Anderlecht | R.S.C. Anderlecht | Royal Sporting Club Anderlecht

== West-Vlaanderen › Vlaanderen ==

Club Brugge, 1891,    Brugge › West-Vlaanderen › Vlaanderen
  | Club Brugge KV | Club Brugge Koninklijke Voetbalvereniging
TXT
 
    m = SportDb::Import.config.clubs.match( 'Club Brugge KV' )
    assert_equal 1, m.size
    assert_equal 'Club Brugge KV', m[0].wikipedia
    assert_equal 'https://en.wikipedia.org/wiki/Club_Brugge_KV', m[0].wikipedia_url

    m = SportDb::Import.config.clubs.match( 'RSC Anderlecht' )
    assert_equal 1, m.size
    assert_equal 'R.S.C. Anderlecht', m[0].wikipedia
    assert_equal 'https://en.wikipedia.org/wiki/R.S.C._Anderlecht', m[0].wikipedia_url
  end

end # class TestClubIndex
