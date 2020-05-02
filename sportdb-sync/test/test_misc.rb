# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_misc.rb


require 'helper'

class TestMisc < MiniTest::Test

  Season = SportDb::Sync::Season


  def test_season
    rec = Season.search_or_create( '2017-18' )
    assert_equal '2017/18', rec.title    ## fix: add name alias (rename title to name!!)
    assert_equal '2017/18', rec.key

    rec = Season.search_or_create( '2017/2018' )
    assert_equal '2017/18', rec.title    ## fix: add name alias (rename title to name!!)
    assert_equal '2017/18', rec.key

    rec = Season.search_or_create( '2017/8' )
    assert_equal '2017/18', rec.title    ## fix: add name alias (rename title to name!!)
    assert_equal '2017/18', rec.key
  end

end # class TestMisc
