# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_parse_de.rb


require 'helper'

class TestParseDe < MiniTest::Test

  def test_date
    data = [
      [ 'Fr. 26.7.',     '2019-07-26', '[DE_DAY_MM_DD]' ],
      [ 'Fr. 26.07.',    '2019-07-26', '[DE_DAY_MM_DD]' ],
      [ 'Fr 26.7.',      '2019-07-26', '[DE_DAY_MM_DD]' ],
      [ '[Fr. 26.7.]',   '2019-07-26', '[[DE_DAY_MM_DD]]' ],
    ]

    assert_dates( data, start: Date.new( 2019, 7, 1 ), lang: 'de' )
  end

end # class TestParseDe
