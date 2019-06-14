# encoding: utf-8


require 'helper'

class TestLevelUtils < MiniTest::Test

  def test_to_i
    assert_equal 0,    'liga2'.to_i   # => 0
    assert_equal 0,    'liga'.to_i    # => 0
    assert_equal 3,    '3a'.to_i      # => 3
    assert_equal 3,    '3b'.to_i      # => 3
    assert_equal 3,    '3a-division'.to_i  # => 3
    assert_equal 3,    '3b-division'.to_i  # => 3
    assert_equal 1,    '01-division'.to_i  # => 1
    assert_equal 1,    '1-division'.to_i   # => 1
    assert_equal 2000, '2000'.to_i        # => 2000
  end  # method test_to_i

  def test_level
    assert_equal 999, LevelUtils.level( 'liga2' )   # => 999
    assert_equal 999, LevelUtils.level( 'liga' )    # => 999
    assert_equal 999, LevelUtils.level( '3' )       # => 999
    assert_equal 999, LevelUtils.level( '3a' )      # => 999
    assert_equal 999, LevelUtils.level( '3b' )      # => 999
    assert_equal 3,   LevelUtils.level( '3-division' )    # => 3
    assert_equal 3,   LevelUtils.level( '3a-division' )   # => 3
    assert_equal 3,   LevelUtils.level( '3b-division' )   # => 3
    assert_equal 1,   LevelUtils.level( '01-division' )   # => 1
    assert_equal 1,   LevelUtils.level( '1-division' )   #  => 1
    assert_equal 999, LevelUtils.level( '2000-division' )   # => 999
  end  # method test_level

end # class TestLevelUtils
