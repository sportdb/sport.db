# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_country_index.rb


require 'helper'

class TestCountryIndex < MiniTest::Test

  def test_countries
    recs      = SportDb::Import::CountryReader.read( "#{SportDb::Test.data_dir}/world/countries.txt" )
    countries = SportDb::Import::CountryIndex.new( recs )

    eng = countries[:eng]
    assert_equal 'eng',      eng.key
    assert_equal 'England',  eng.name
    assert_equal 'ENG',      eng.fifa

    at  = countries[:at]
    assert_equal 'at',       at.key
    assert_equal 'Austria',  at.name
    assert_equal 'AUT',      at.fifa

    assert at == countries['AT']
    assert at == countries['at']
    assert at == countries['AUT']
    assert at == countries['aut']
    assert at == countries[:aut]
  end

end # class TestCountryIndex
