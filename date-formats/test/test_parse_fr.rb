# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_parse_fr.rb


require 'helper'

class TestParseFr < MiniTest::Test

  def test_date
    data = [
      [ '[Ven 08. Août]', '2014-08-08', '[[FR_DAY_DD_MONTH]]' ],
      [ 'Ven 08. Août',   '2014-08-08', '[FR_DAY_DD_MONTH]' ],
      [ 'Ven 8. Août',    '2014-08-08', '[FR_DAY_DD_MONTH]' ],
      [ '[Sam 9. Août]',  '2014-08-09', '[[FR_DAY_DD_MONTH]]' ],
      [ '[Dim 10. Août]', '2014-08-10', '[[FR_DAY_DD_MONTH]]' ],
      [ '[Sam 31. Janv]', '2015-01-31', '[[FR_DAY_DD_MONTH]]' ],
      [ '[Sam 7. Févr]',  '2015-02-07', '[[FR_DAY_DD_MONTH]]' ],
      [ '[Sam 31. Jan]',  '2015-01-31', '[[FR_DAY_DD_MONTH]]' ],
      [ '[Sam 7. Fév]',   '2015-02-07', '[[FR_DAY_DD_MONTH]]' ],
    ]

    assert_dates( data, start: Date.new( 2014, 8, 1 ), lang: 'fr' )
  end

end # class TestParseFr
