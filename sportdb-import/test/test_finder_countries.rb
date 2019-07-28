# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_finder_countries.rb


require 'helper'

class TestFinderCountries < MiniTest::Test

  def test_england
    country = SportDb::Importer::Country.find_or_create_builtin!( 'eng' )
    assert_equal 'England', country.name
    assert_equal 'eng',     country.key
    assert_equal 'ENG',     country.fifa

    country = SportDb::Importer::Country.find_or_create_builtin!( 'eng' )
    assert_equal 'England', country.name
    assert_equal 'eng',     country.key
    assert_equal 'ENG',     country.fifa
  end

  def test_austria
    country = SportDb::Importer::Country.find_or_create_builtin!( 'at' )  ## try (iso-alpha2) key
    assert_equal 'Austria', country.name
    assert_equal 'at',      country.key
    assert_equal 'AUT',     country.fifa

    country = SportDb::Importer::Country.find_or_create_builtin!( 'aut' )  ## try fifa code
    assert_equal 'Austria', country.name
    assert_equal 'at',      country.key
    assert_equal 'AUT',     country.fifa
  end
end # class TestFinderCountries
