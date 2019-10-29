# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_season_utils.rb


require 'helper'

class TestSeasonUtils < MiniTest::Test

  def test_directory
    assert_equal '2010-11',       SeasonUtils.directory( '2010-11' )
    assert_equal '2010-11',       SeasonUtils.directory( '2010-2011' )
    assert_equal '2010-11',       SeasonUtils.directory( '2010/11' )
    assert_equal '2010-11',       SeasonUtils.directory( '2010/2011' )
    assert_equal '2010',          SeasonUtils.directory( '2010' )

    assert_equal '2010s/2010-11', SeasonUtils.directory( '2010-11',   format: 'long' )
    assert_equal '2010s/2010-11', SeasonUtils.directory( '2010-2011', format: 'long' )
    assert_equal '2010s/2010',    SeasonUtils.directory( '2010',      format: 'long' )

    assert_equal '1999-00',       SeasonUtils.directory( '1999-00' )
    assert_equal '1999-00',       SeasonUtils.directory( '1999-2000' )
    assert_equal '1990s/1999-00', SeasonUtils.directory( '1999-00',   format: 'long' )
    assert_equal '1990s/1999-00', SeasonUtils.directory( '1999-2000', format: 'long' )
  end  # method test_diretory

end # class TestSeasonlUtils
