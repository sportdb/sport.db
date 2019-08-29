# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_splitter.rb


require 'helper'

class TestSplitter < MiniTest::Test

  def test_find_seasons
     pp = CsvMatchSplitter.find_seasons( "#{SportDb::Test.data_dir}/dl/AUT.csv" )  ## defaults to col: 'Season', col_sep: ','
     pp = CsvMatchSplitter.find_seasons( "#{SportDb::Test.data_dir}/dl/Bundesliga_1963_2014.csv", col: 'Saison', col_sep: ';'  )
     assert true
  end

end # class TestSplitter
