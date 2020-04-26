# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_countries.rb


require 'helper'

class TestCountries < MiniTest::Test

  COUNTRIES = SportDb::Import.config.countries


  def test_countries
    ## pp COUNTRIES

    eng = COUNTRIES[:eng]
    assert_equal 'eng',      eng.key
    assert_equal 'England',  eng.name
    assert_equal 'ENG',      eng.fifa

    at  = COUNTRIES[:at]
    assert_equal 'at',       at.key
    assert_equal 'Austria',  at.name
    assert_equal 'AUT',      at.fifa

    assert at == COUNTRIES['AT']
    assert at == COUNTRIES['at']
    assert at == COUNTRIES['AUT']
    assert at == COUNTRIES['aut']
    assert at == COUNTRIES[:aut]
  end

end # class TestCountries
