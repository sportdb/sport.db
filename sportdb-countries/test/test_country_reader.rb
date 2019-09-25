# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_country_reader.rb


require 'helper'

class TestCountryReader < MiniTest::Test

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

# Key   Name,  FIFA

af   Afghanistan,  AFG
al   Albania,      ALB
dz   Algeria,      ALG
as   American Samoa (US),  ASA
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
