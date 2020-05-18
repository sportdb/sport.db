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
    assert_equal 'ENG',      eng.code

    at  = countries[:at]
    assert_equal 'at',                at.key
    assert_equal 'Austria',           at.name
    assert_equal 'AUT',               at.code
    assert_equal ['Österreich [de]'], at.alt_names

    assert at == countries['AT']
    assert at == countries['at']
    assert at == countries['AUT']
    assert at == countries['aut']
    assert at == countries[:aut]

    assert at == countries[:austria]
    assert at == countries['...A.u.s.t.r.i.a...']
    assert at == countries['Österreich']   ## Austria in German [de]

    assert at == countries.find_by_code( 'AT' )
    assert at == countries.find_by_code( 'at' )
    assert at == countries.find_by_code( 'AUT' )
    assert at == countries.find_by_code( 'aut' )
    assert at == countries.find_by_code( :aut )

    assert at == countries.find_by_name( :austria )
    assert at == countries.find_by_name( '...A.u.s.t.r.i.a...' )
    assert at == countries.find_by_name( 'Österreich' )   ## Austria in German [de]

    assert at == countries.parse( 'Österreich • Austria (at)' )
    assert at == countries.parse( 'Österreich • Austria' )
    assert at == countries.parse( 'Austria' )
    assert at == countries.parse( 'at' )    ## (iso alpha2) country code
    assert at == countries.parse( 'AUT' )   ## (fifa) country code


    de  = countries[:de]
    assert_equal 'de',                 de.key
    assert_equal 'Germany',            de.name
    assert_equal 'GER',                de.code
    assert_equal ['Deutschland [de]'], de.alt_names

    assert de == countries.parse( 'Deutschland (de) • Germany' )
  end

end # class TestCountryIndex
