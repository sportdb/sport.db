###
#  to run use
#     ruby -I ./lib -I ./test test/test_split.rb


require 'helper'

class TestSplit < MiniTest::Test

  def test_split
    assert_equal [], Score.split( '' )
    assert_equal [], Score.split( '-' )
    assert_equal [], Score.split( '-:-' )
    assert_equal [], Score.split( '?' )

    assert_equal [0,1], Score.split( '0-1' )
    assert_equal [0,1], Score.split( ' 0 - 1 ' )
    assert_equal [0,1], Score.split( '0:1' )
    assert_equal [0,1], Score.split( ' 0 : 1 ' )
    assert_equal [0,1], Score.split( '0x1' )
    assert_equal [0,1], Score.split( '0X1' )

    assert_equal [10,11], Score.split( '10 - 11' )
    assert_equal [10,11], Score.split( '10 : 11' )
  end

end