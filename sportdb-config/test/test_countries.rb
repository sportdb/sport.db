# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_countries.rb


require 'helper'

class TestCountries < MiniTest::Test

  def test_read_countries
    recs = read_csv( "#{SportDb::Boot.data_dir}/world/countries.txt" )
    pp recs

    ## todo/fix:
=begin
end of line comments included!!! remove - see
{:key=>"ba",
 :fifa=>"BIH",
 :name=>"Bosnia and Herzegovina      ## or use Bosnia-Herzegovina ?"},
{:key=>"zan",
 :fifa=>"ZAN",
 :name=>
  "Zanzibar (TZ)       # CAF     -- note:  is a semi-autonomous region of Tanzania"},
{:key=>"tv", :fifa=>"TUV", :name=>"Tuvalu         # OFC"}, ...
=end
  end


  def xxx_test_countries
    pp SportDb::Import.config.countries

    eng = SportDb::Import.config.countries[:eng]
    assert_equal 'eng',      eng.key
    assert_equal 'England',  eng.name
    assert_equal 'ENG',      eng.code

    at  = SportDb::Import.config.countries[:at]
    assert_equal 'at',       at.key
    assert_equal 'Austria',  at.name
    assert_equal 'AUT',      at.code
  end

end # class TestCountries
