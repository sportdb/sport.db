# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_country.rb


require 'helper'


class TestCountry < MiniTest::Test

  Country = SportDb::Sync::Country

  def test_find  # note: find uses "data" structs
    at  = SportDb::Import::Country.new( key: 'at',  name: 'Austria', fifa: 'AUT' )
    eng = SportDb::Import::Country.new( key: 'eng', name: 'England', fifa: 'ENG' )

    rec  = Country.find_or_create( at )
    rec2 = Country.find_or_create( at )

    rec  = Country.find_or_create( eng )
    rec2 = Country.find_or_create( eng )
  end  # method test_find


  def test_search  # note: search uses query strings
    rec = Country.search_or_create!( 'at' )  ## try (iso-alpha2) key
    assert_equal 'Austria', rec.name
    assert_equal 'at',      rec.key
    assert_equal 'AUT',     rec.fifa

    rec = Country.search_or_create!( 'aut' )  ## try fifa code
    assert_equal 'Austria', rec.name
    assert_equal 'at',      rec.key
    assert_equal 'AUT',     rec.fifa


    rec = Country.search_or_create!( 'eng' )
    assert_equal 'England', rec.name
    assert_equal 'eng',     rec.key
    assert_equal 'ENG',     rec.fifa

    rec = Country.search_or_create!( 'eng' )
    assert_equal 'England', rec.name
    assert_equal 'eng',     rec.key
    assert_equal 'ENG',     rec.fifa
  end

end  # class TestCountry
