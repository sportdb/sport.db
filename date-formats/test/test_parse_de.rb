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
      [ 'Fr., 26.07.',   '2019-07-26', '[DE_DAY_MM_DD]' ],
      [ 'Fr, 26.7.',     '2019-07-26', '[DE_DAY_MM_DD]' ],
      [ '[Fr. 26.7.]',   '2019-07-26', '[[DE_DAY_MM_DD]]' ],

      [ 'Sa., 16.5., 18.00 Uhr',    '2019-05-16 18:00', '[DE_DAY_MM_DD_hh_mm]' ],
      [ 'Sa 16.5. 18.00',           '2019-05-16 18:00', '[DE_DAY_MM_DD_hh_mm]' ],
      [ '[Sa., 16.5., 18.00 Uhr]',  '2019-05-16 18:00', '[[DE_DAY_MM_DD_hh_mm]]' ],
      [ '[Sa 16.5. 18.00]',         '2019-05-16 18:00', '[[DE_DAY_MM_DD_hh_mm]]' ],

      [ 'Mo., 18.5., 20.30 Uhr',    '2019-05-18 20:30', '[DE_DAY_MM_DD_hh_mm]' ],
      [ 'Mo 18.5. 20.30',           '2019-05-18 20:30', '[DE_DAY_MM_DD_hh_mm]' ],
    ]

    assert_dates( data, start: Date.new( 2019, 1, 1 ), lang: 'de' )
  end

end # class TestParseDe
