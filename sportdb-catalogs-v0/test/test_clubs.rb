###
#  to run use
#     ruby -I ./lib -I ./test test/test_clubs.rb


require 'helper'

class TestClubs < MiniTest::Test

   CLUBS = SportDb::Import.catalog.clubs


  def test_match
    pp CLUBS.errors

    CLUBS.dump_duplicates

    m = CLUBS.match( 'Rapid Wien' )
    assert_equal 'SK Rapid Wien', m[0].name
    assert_equal 'Austria',       m[0].country.name
    assert_equal 'Wien',          m[0].city

    m = CLUBS.match( 'rapid wien' )
    assert_equal 'SK Rapid Wien', m[0].name
    assert_equal 'Austria',       m[0].country.name
    assert_equal 'Wien',          m[0].city

    ## note: all dots (.) get always removed
    m = CLUBS.match( '...r.a.p.i.d w.i.e.n...' )
    assert_equal 'SK Rapid Wien', m[0].name
    assert_equal 'Austria',       m[0].country.name
    assert_equal 'Wien',          m[0].city

    ## note: all spaces and dashes (-) get always removed
    m = CLUBS.match( '--- r a p i d  w i e n ---' )
    assert_equal 'SK Rapid Wien', m[0].name
    assert_equal 'Austria',       m[0].country.name
    assert_equal 'Wien',          m[0].city

    m = CLUBS.match( 'RAPID WIEN' )
    assert_equal 'SK Rapid Wien', m[0].name
    assert_equal 'Austria',       m[0].country.name
    assert_equal 'Wien',          m[0].city


    c = CLUBS[ 'SK Rapid Wien' ]   ## check canoncial name match (only)
    assert_equal 'SK Rapid Wien', c.name
    assert_equal 'Austria',       c.country.name
    assert_equal 'Wien',          c.city


    m = CLUBS.match( 'Arsenal' )
    assert_equal 3, m.size

    m = CLUBS.match( 'ARSENAL' )
    assert_equal 3, m.size

    m = CLUBS.match_by( name: 'Arsenal', country: 'eng' )
    assert_equal 1, m.size
    assert_equal 'Arsenal FC', m[0].name
    assert_equal 'England',    m[0].country.name
    assert_equal 'London',     m[0].city

    m = CLUBS.match_by( name: 'Arsenal', country: 'ar' )
    assert_equal 1, m.size
    assert_equal 'Arsenal de Sarandí', m[0].name
    assert_equal 'Argentina',          m[0].country.name
    assert_equal 'Sarandí',            m[0].city

    m = CLUBS.match_by( name: 'Arsenal', country: 'ru' )
    assert_equal 1, m.size
    assert_equal 'Arsenal Tula', m[0].name
    assert_equal 'Russia',       m[0].country.name
    assert_equal 'Tula',         m[0].city


    m = CLUBS.match( 'Arsenal FC' )
    assert_equal 2, m.size

    m = CLUBS.match( 'Arsenal F.C.' )
    assert_equal 2, m.size

    m = CLUBS.match( '...A.r.s.e.n.a.l... F.C...' )
    assert_equal 2, m.size
  end


  def test_wikipedia    ## test wikipedia names and links/urls
    m = CLUBS.match( 'Club Brugge KV' )
    assert_equal 1, m.size
    assert_equal 'Club Brugge KV', m[0].wikipedia
    assert_equal 'https://en.wikipedia.org/wiki/Club_Brugge_KV', m[0].wikipedia_url

    m = CLUBS.match( 'RSC Anderlecht' )
    assert_equal 1, m.size
    assert_equal 'R.S.C. Anderlecht', m[0].wikipedia
    assert_equal 'https://en.wikipedia.org/wiki/R.S.C._Anderlecht', m[0].wikipedia_url
  end

end # class TestClubs
