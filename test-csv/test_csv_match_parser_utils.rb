###
#  to run use
#     ruby -I . test_csv_match_parser_utils.rb


require 'helper'

class TestCsvMatchParserUtils < Minitest::Test

  def test_find_seasons
     pp = CsvMatchParser.find_seasons( "#{Test.data_dir}/dl/AUT.csv" )  ## defaults to col: 'Season', col_sep: ','
     pp = CsvMatchParser.find_seasons( "#{Test.data_dir}/dl/Bundesliga_1963_2014.csv", col: 'Saison', sep: ';'  )
     assert true
  end

end # class TestCsvMatchParserUtils


