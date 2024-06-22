###
#  to run use
#     ruby  test/test_clubs.rb

require_relative 'helper'


class TestClubs < Minitest::Test

   CLUBS = SportDb::Import.catalog.clubs


  def test_match
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


    ## check canoncial name match (only) - deprecated for now, do not use, sorry
    # c = CLUBS[ 'SK Rapid Wien' ]   
    # assert_equal 'SK Rapid Wien', c.name
    # assert_equal 'Austria',       c.country.name
    # assert_equal 'Wien',          c.city


    m = CLUBS.match( 'Arsenal' )
    assert_equal 3, m.size

    pp m

    m = CLUBS.match( 'ARSENAL' )
    assert_equal 3, m.size


    m = CLUBS.match_by( name: 'ARSENAL', country: ['ENG', 'AR', 'RU'] )
    assert_equal 3, m.size

    m = CLUBS.match_by( name: 'ARSENAL', country: ['AT', 'DE'] )
    assert_equal 0, m.size



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

end # class TestClubs
