# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_countries.rb


require 'helper'

class TestCountries < MiniTest::Test

  def test_countries
    ## pp SportDb::Import.config.countries

    eng = SportDb::Import.config.countries[:eng]
    assert_equal 'eng',      eng.key
    assert_equal 'England',  eng.name
    assert_equal 'ENG',      eng.fifa

    at  = SportDb::Import.config.countries[:at]
    assert_equal 'at',       at.key
    assert_equal 'Austria',  at.name
    assert_equal 'AUT',      at.fifa

    assert at == SportDb::Import.config.countries['AT']
    assert at == SportDb::Import.config.countries['at']
    assert at == SportDb::Import.config.countries['AUT']
    assert at == SportDb::Import.config.countries['aut']
    assert at == SportDb::Import.config.countries[:aut]
  end

end # class TestCountries
