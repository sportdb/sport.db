# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_downcase.rb


require 'helper'

class TestDowncase < MiniTest::Test

  def test_downcase_i18n
    assert_equal 'abcdefghijklmnopqrstuvwxyz',  downcase_i18n( 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' )
    assert_equal 'äöü',  downcase_i18n( 'ÄÖÜ' )
    assert_equal 'köln', downcase_i18n( 'KÖLN' )
  end

end # class TestDowncase
