###
#  to run use
#     ruby test/test_date_parse.rb


require_relative 'helper'

## date & time

class TestParseDate < Minitest::Test


  def test_parse
    date = SportDb::Parser.parse_date( 'July 13', start: Date.new( 1930, 1, 1 ) )
    assert_equal Date.new( 1930, 7, 13), date
    date = SportDb::Parser.parse_date( '13 July', start: Date.new( 1930, 1, 1 ) )
    assert_equal Date.new( 1930, 7, 13), date

    date = SportDb::Parser.parse_date( 'Jan 1', start: Date.new( 1930, 1, 1 ) )
    assert_equal Date.new( 1930, 1, 1), date
    date = SportDb::Parser.parse_date( '1 Jan', start: Date.new( 1930, 1, 1 ) )
    assert_equal Date.new( 1930, 1, 1), date

    date = SportDb::Parser.parse_date( 'July 1', start: Date.new( 1930, 7, 1 ) )
    assert_equal Date.new( 1930, 7, 1), date

    date = SportDb::Parser.parse_date( 'Jan 1', start: Date.new( 1930, 7, 1 ) )
    assert_equal Date.new( 1931, 1, 1), date
  end

end # class TestParseDate

