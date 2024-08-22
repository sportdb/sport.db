###
#  to run use
#     ruby test/test_misc.rb


require_relative 'helper'

class TestMisc < Minitest::Test

  Season = SportDb::Sync::Season


  def test_season
    rec = Season.search_or_create( '2017-18' )
    assert_equal '2017/18', rec.name
    assert_equal '2017/18', rec.key

    rec = Season.search_or_create( '2017/2018' )
    assert_equal '2017/18', rec.name
    assert_equal '2017/18', rec.key

    rec = Season.search_or_create( '2017/8' )
    assert_equal '2017/18', rec.name
    assert_equal '2017/18', rec.key
  end

end # class TestMisc
