# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_club.rb


require 'helper'

class TestClub < MiniTest::Test

  def test_match

    m = Club.match( 'Rapid Wien' )
    assert_equal 'SK Rapid Wien', m[0].name
    assert_equal 'Austria',       m[0].country.name
    assert_equal 'Wien',          m[0].city

    m = Club.match( 'rapid wien' )
    assert_equal 'SK Rapid Wien', m[0].name
    assert_equal 'Austria',       m[0].country.name
    assert_equal 'Wien',          m[0].city

    ## note: all dots (.) get always removed
    m = Club.match( '...r.a.p.i.d w.i.e.n...' )
    assert_equal 'SK Rapid Wien', m[0].name
    assert_equal 'Austria',       m[0].country.name
    assert_equal 'Wien',          m[0].city

    ## note: all spaces and dashes (-) get always removed
    m = Club.match( '--- r a p i d  w i e n ---' )
    assert_equal 'SK Rapid Wien', m[0].name
    assert_equal 'Austria',       m[0].country.name
    assert_equal 'Wien',          m[0].city

    m = Club.match( 'RAPID WIEN' )
    assert_equal 'SK Rapid Wien', m[0].name
    assert_equal 'Austria',       m[0].country.name
    assert_equal 'Wien',          m[0].city


    c = Club[ 'SK Rapid Wien' ]   ## check canoncial name match (only)
    assert_equal 'SK Rapid Wien', c.name
    assert_equal 'Austria',       c.country.name
    assert_equal 'Wien',          c.city


    m = Club.match( 'Arsenal' )
    assert_equal 3, m.size

    m = Club.match( 'ARSENAL' )
    assert_equal 3, m.size

    m = Club.match_by( name: 'Arsenal', country: 'eng' )
    assert_equal 1, m.size
    assert_equal 'Arsenal FC', m[0].name
    assert_equal 'England',    m[0].country.name
    assert_equal 'London',     m[0].city

    m = Club.match_by( name: 'Arsenal', country: 'ar' )
    assert_equal 1, m.size
    assert_equal 'Arsenal de Sarandí', m[0].name
    assert_equal 'Argentina',          m[0].country.name
    assert_equal 'Sarandí',            m[0].city

    m = Club.match_by( name: 'Arsenal', country: 'ru' )
    assert_equal 1, m.size
    assert_equal 'Arsenal Tula', m[0].name
    assert_equal 'Russia',       m[0].country.name
    assert_equal 'Tula',         m[0].city


    m = Club.match( 'Arsenal FC' )
    assert_equal 2, m.size

    m = Club.match( 'Arsenal F.C.' )
    assert_equal 2, m.size

    m = Club.match( '...A.r.s.e.n.a.l... F.C...' )
    assert_equal 2, m.size
end


def test_wikipedia    # test wikipedia names and links/urls

    m = Club.match( 'Club Brugge KV' )
    assert_equal 1, m.size
    assert_equal 'Club Brugge KV', m[0].wikipedia
    assert_equal 'https://en.wikipedia.org/wiki/Club_Brugge_KV', m[0].wikipedia_url

    m = Club.match( 'RSC Anderlecht' )
    assert_equal 1, m.size
    assert_equal 'R.S.C. Anderlecht', m[0].wikipedia
    assert_equal 'https://en.wikipedia.org/wiki/R.S.C._Anderlecht', m[0].wikipedia_url
  end

end # class TestClub
