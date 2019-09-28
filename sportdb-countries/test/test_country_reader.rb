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

    assert_equal 'Albania',        recs[0].name
    assert_equal 'ALB',            recs[0].fifa
    assert_equal 'al',             recs[0].key
    assert_equal ['fifa', 'uefa'], recs[0].tags

    assert_equal 'Andorra',        recs[1].name
    assert_equal 'AND',            recs[1].fifa
    assert_equal 'ad',             recs[1].key
    assert_equal ['fifa', 'uefa'], recs[1].tags
  end

  def test_parse
    recs = SportDb::Import::CountryReader.parse( <<TXT )
#####
# FIFA countries and codes

# Key   Name,  FIFA

af   Afghanistan,          AFG,   fifa › afc
al   Albania,              ALB,   fifa › uefa
dz   Algeria,              ALG,   fifa › caf
as   American Samoa › US,  ASA,
      | Am. Samoa
TXT

    pp recs

    assert_equal 4, recs.size
    assert_equal 'Afghanistan',    recs[0].name
    assert_equal 'AFG',            recs[0].fifa
    assert_equal 'af',             recs[0].key
    assert_equal [],               recs[0].alt_names
    assert_equal ['fifa', 'afc'],  recs[0].tags

    assert_equal 'American Samoa', recs[3].name
    assert_equal 'ASA',            recs[3].fifa
    assert_equal 'as',             recs[3].key
    assert_equal ['Am. Samoa'],    recs[3].alt_names
    assert_equal [],               recs[3].tags
  end

end # class TestCountryReader
