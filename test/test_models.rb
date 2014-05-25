# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_models.rb
#  or better
#     rake -I ./lib test


require 'helper'

class TestModels < MiniTest::Unit::TestCase

  def setup
    WorldDb.delete!
    SportDb.delete!
    SportDb.read_builtin
  end

  def test_alltime_standings
    st = AlltimeStanding.create!( key: 'worldcup', title: 'All Time World Cup' )

    assert_equal 1, AlltimeStanding.count
    assert_equal 0, st.entries.count


  end

end # class TestModels
