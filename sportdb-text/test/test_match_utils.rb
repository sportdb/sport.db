# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_match_utils.rb


require 'helper'

class TestMatchUtils < MiniTest::Test

  def test_find_seasons
     pp = CsvMatchReader.find_seasons( "#{SportDb::Test.data_dir}/dl/AUT.csv" )  ## defaults to col: 'Season', col_sep: ','
     pp = CsvMatchReader.find_seasons( "#{SportDb::Test.data_dir}/dl/Bundesliga_1963_2014.csv", col: 'Saison', sep: ';'  )
     assert true
  end

end # class TestMatchUtils


