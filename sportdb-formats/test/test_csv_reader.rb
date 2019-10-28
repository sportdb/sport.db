# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_csv_reader.rb


require 'helper'

class TestCsvReader < MiniTest::Test

  def test_parse
    recs = parse_csv( <<TXT )
### World Countries

key, fifa, name
af,  AFG,  Afghanistan
al,  ALB,  Albania
dz,  ALG,  Algeria
as,  ASA,  American Samoa (US)
TXT

   pp recs
   assert_equal  [{ key:'af', fifa:'AFG', name:'Afghanistan'},
                  { key:'al', fifa:'ALB', name:'Albania'},
                  { key:'dz', fifa:'ALG', name:'Algeria'},
                  { key:'as', fifa:'ASA', name:'American Samoa (US)'},
                 ], recs[0..3]
  end

end   # class TestCsvReader
