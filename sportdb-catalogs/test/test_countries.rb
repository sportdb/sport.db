###
#  to run use
#     ruby test/test_countries.rb


require_relative 'helper'

class TestCountries < Minitest::Test

  COUNTRIES = SportDb::Import.world.countries
  CITIES    = SportDb::Import.world.cities

  def test_cities
     m = CITIES.match_by( name: 'München' )
     pp m
     m = CITIES.match_by( name: 'Munich' )
     pp m

     m = CITIES.match_by( name: 'Wien' )
     pp m
     m = CITIES.match_by( name: 'Vienna' )
     pp m
  end


  def test_countries
    eng = COUNTRIES.find( :eng )
    assert_equal 'eng',      eng.key
    assert_equal 'England',  eng.name
    assert_equal 'ENG',      eng.code

    at  = COUNTRIES.find( :at )
    assert_equal 'at',       at.key
    assert_equal 'Austria',  at.name
    assert_equal 'AUT',      at.code

    assert at == COUNTRIES.find( 'AT' )
    assert at == COUNTRIES.find( 'at' )
    assert at == COUNTRIES.find( 'AUT' )
    assert at == COUNTRIES.find( 'aut' )
    assert at == COUNTRIES.find( :aut )
  end

end # class TestCountries
