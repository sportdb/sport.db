# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_level_utils.rb


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

  def test_div   # divsion
    assert_equal '?',    LevelUtils.division( 'liga2' )
    assert_equal '?',    LevelUtils.division( 'liga' )
    assert_equal '?',    LevelUtils.division( '3' )
    assert_equal '?',    LevelUtils.division( '3a' )
    assert_equal '?',    LevelUtils.division( '2000-division' )

    assert_equal '3',    LevelUtils.division( '3-division' )
    assert_equal '3a',   LevelUtils.division( '3a-division' )
    assert_equal '3b',   LevelUtils.division( '3b-division' )
    assert_equal '1',    LevelUtils.division( '1-division' )
    assert_equal '01',   LevelUtils.division( '01-division' )

    assert_equal '1',    LevelUtils.division( 'eng.1' )
    assert_equal '1',    LevelUtils.division( 'eng.1.' )
    assert_equal '1',    LevelUtils.division( 'eng.1.csv' )
    assert_equal '1',    LevelUtils.division( 'eng.1.txt' )

    assert_equal '3a',   LevelUtils.division( 'eng.3a' )
    assert_equal '3a',   LevelUtils.division( 'eng.3a.' )
    assert_equal '3a',   LevelUtils.division( 'eng.3a.csv' )
    assert_equal '3a',   LevelUtils.division( 'eng.3a.txt' )
  end

end # class TestLevelUtils
