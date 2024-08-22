###
#  to run use
#     ruby test/test_country.rb


require_relative 'helper'


class TestCountry < Minitest::Test

  Country = SportDb::Sync::Country

  def test_find  # note: find uses "data" structs
    at  = Sports::Country.new( key: 'at',  name: 'Austria', code: 'AUT' )
    eng = Sports::Country.new( key: 'eng', name: 'England', code: 'ENG' )

    rec  = Country.find_or_create( at )
    rec2 = Country.find_or_create( at )

    rec  = Country.find_or_create( eng )
    rec2 = Country.find_or_create( eng )
  end  # method test_find


  def test_search  # note: search uses query strings
    rec = Country.search_or_create!( 'at' )  ## try (iso-alpha2) key
    assert_equal 'Austria', rec.name
    assert_equal 'at',      rec.key
    assert_equal 'AUT',     rec.code

    rec = Country.search_or_create!( 'aut' )  ## try fifa code
    assert_equal 'Austria', rec.name
    assert_equal 'at',      rec.key
    assert_equal 'AUT',     rec.code


    rec = Country.search_or_create!( 'eng' )
    assert_equal 'England', rec.name
    assert_equal 'eng',     rec.key
    assert_equal 'ENG',     rec.code

    rec = Country.search_or_create!( 'eng' )
    assert_equal 'England', rec.name
    assert_equal 'eng',     rec.key
    assert_equal 'ENG',     rec.code
  end

end  # class TestCountry
