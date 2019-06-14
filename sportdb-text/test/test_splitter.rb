# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_splitter.rb


require 'helper'

class TestSplitter < MiniTest::Test

  ## fix/todo: move testfiles to "local" test data folder inside gem!!!!
  def test_find_seasons
     pp = CsvMatchSplitter.find_seasons( '../dl/at-austria/AUT.csv' )   ## defaults to col: 'Season', col_sep: ','
     pp = CsvMatchSplitter.find_seasons( '../dl/Bundesliga_1963_2014.csv', col: 'Saison', col_sep: ';'  )
     assert true
  end

end # class TestSplitter
