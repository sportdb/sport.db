# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_pp.rb
#  or better
#     rake -I ./lib test


require 'helper'

class TestPp < MiniTest::Test
  
  def test_patch

    r = TestPrettyPrinter.from_file( 'at-austria/2014_15/1-bundesliga-ii' )
    new_text, change_log = r.patch

    pp change_log

    assert true ## assume ok if we get here
  end  # method test_patch

end # class TestPp
