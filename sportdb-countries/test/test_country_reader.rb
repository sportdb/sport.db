# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_country_reader.rb


require 'helper'

class TestCountryReader < MiniTest::Test

  def test_read_csv
    recs = read_csv( "#{SportDb::Test.data_dir}/world/countries.txt" )
    ## pp recs

    assert_equal  [{ key:'af', fifa:'AFG', name:'Afghanistan'},
                   { key:'al', fifa:'ALB', name:'Albania'},
                   { key:'dz', fifa:'ALG', name:'Algeria'},
                   { key:'as', fifa:'ASA', name:'American Samoa (US)'},
                  ], recs[0..3]
  end

  def test_read
    recs = SportDb::Import::CountryReader.read( "#{SportDb::Test.data_dir}/world/countries.txt" )
    pp recs

    assert_equal 227, recs.size
    assert_equal 'Afghanistan',    recs[0].name
    assert_equal 'AFG',            recs[0].fifa
    assert_equal 'af',             recs[0].key

    assert_equal 'American Samoa', recs[3].name
    assert_equal 'ASA',            recs[3].fifa
    assert_equal 'as',             recs[3].key
  end

  def test_parse
    recs = SportDb::Import::CountryReader.parse( <<TXT )
#####
# FIFA countries and codes

Key,  FIFA,  Name

af,  AFG, Afghanistan
al,  ALB, Albania
dz,  ALG, Algeria
as,  ASA, American Samoa (US)
TXT

    pp recs

    assert_equal 4, recs.size
    assert_equal 'Afghanistan',    recs[0].name
    assert_equal 'AFG',            recs[0].fifa
    assert_equal 'af',             recs[0].key

    assert_equal 'American Samoa', recs[3].name
    assert_equal 'ASA',            recs[3].fifa
    assert_equal 'as',             recs[3].key
  end

end # class TestCountryReader
