###
#  to run use
#     ruby test/test_countries.rb


require_relative 'helper'

class TestCountries < Minitest::Test

  Country      = CatalogDb::Metal::Country
  City         = CatalogDb::Metal::City

  def test_cities
     m = City.match_by( name: 'München' )
     pp m
     m = City.match_by( name: 'Munich' )
     pp m

     m = City.match_by( name: 'Wien' )
     pp m
     m = City.match_by( name: 'Vienna' )
     pp m
  end


  def test_countries
    eng = Country.find_by_code( :eng )
    assert_equal 'eng',      eng.key
    assert_equal 'England',  eng.name
    assert_equal 'ENG',      eng.code

    at  = Country.find_by_code( :at )
    assert_equal 'at',       at.key
    assert_equal 'Austria',  at.name
    assert_equal 'AUT',      at.code

    assert at == Country.find_by_code( 'AT' )
    assert at == Country.find_by_code( 'at' )
    assert at == Country.find_by_code( 'AUT' )
    assert at == Country.find_by_code( 'aut' )
    assert at == Country.find_by_code( :aut )
  end

end # class TestCountries
