# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_clubs.rb


require 'helper'

class TestClubs < MiniTest::Test

  def test_clubs
    ## todo/check: move config.clubs_dir to test/helper for global setting - why? why not?
    SportDb::Import.config.clubs_dir = '../../../openfootball/clubs'

    pp SportDb::Import.config.clubs.errors

    SportDb::Import.config.clubs.dump_duplicates

    m = SportDb::Import.config.clubs.match( 'Rapid Wien' )
    assert_equal 'SK Rapid Wien', m[0].name
    assert_equal 'Austria',       m[0].country.name
    assert_equal 'Wien',          m[0].city

    c = SportDb::Import.config.clubs[ 'SK Rapid Wien' ]   ## check canoncial name match (only)
    assert_equal 'SK Rapid Wien', c.name
    assert_equal 'Austria',       c.country.name
    assert_equal 'Wien',          c.city


    m = SportDb::Import.config.clubs.match( 'Arsenal' )
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
  end

end # class TestClubs
