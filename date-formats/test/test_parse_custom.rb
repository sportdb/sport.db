# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_parse_custom.rb


require 'helper'

class TestParseCustom < MiniTest::Test

  def parse( line, start: )
    @@parser ||= DateFormats::RsssfDateParser.new
    @@parser.parse( line, start: start )
  end

  def test_rsssf
    year  = Date.today.year
    start = Date.new( year, 1, 1 )

    assert_equal Date.new( year, 4, 12 ), parse( '[Apr 12]',   start: start )
    assert_equal Date.new( year, 4, 12 ), parse( '[April 12]', start: start )
  end

end # class TestParseCustom
