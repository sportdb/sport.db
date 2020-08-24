###
#  to run use
#     ruby -I ./lib -I ./test test/test_csv_reader.rb


require 'helper'


class TestCsvReader < MiniTest::Test

  def test_parse
    recs = parse_csv( <<TXT )
### World Countries

Key, Code, Name
af,  AFG,  Afghanistan
al,  ALB,  Albania
dz,  ALG,  Algeria
as,  ASA,  American Samoa (US)
TXT

   pp recs
   assert_equal  [{ 'Key' => 'af', 'Code' => 'AFG', 'Name' => 'Afghanistan'},
                  { 'Key' => 'al', 'Code' => 'ALB', 'Name' => 'Albania'},
                  { 'Key' => 'dz', 'Code' => 'ALG', 'Name' => 'Algeria'},
                  { 'Key' => 'as', 'Code' => 'ASA', 'Name' => 'American Samoa (US)'},
                 ], recs[0..3]
  end

end   # class TestCsvReader
