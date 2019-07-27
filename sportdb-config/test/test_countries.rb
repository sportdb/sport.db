# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_countries.rb


require 'helper'

class TestCountries < MiniTest::Test

  def test_read_countries
    recs = read_csv( "#{SportDb::Boot.data_dir}/world/countries.txt" )
    ## pp recs

    assert_equal  [{ key:'af', fifa:'AFG', name:'Afghanistan'},
                   { key:'al', fifa:'ALB', name:'Albania'}], recs[0..1]
  end


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

    aut  = SportDb::Import.config.countries[:aut]
    assert_equal 'at',       aut.key
    assert_equal 'Austria',  aut.name
    assert_equal 'AUT',      aut.fifa

    assert aut == at
  end

end # class TestCountries
