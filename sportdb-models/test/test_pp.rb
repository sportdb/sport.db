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

    puts new_text

    pp change_log


    p = SportDb::Patcher.new( "#{SportDb.test_data_path}/at-austria",
                               path: '/\d{4}_\d{2}/$',
                               names: 'bundesliga|el'
                            )
    change_logs = p.patch   # note: defaults to save=false (for now)

    pp change_logs

    assert true ## assume ok if we get here
  end  # method test_patch

end # class TestPp
