# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_commands.rb


require 'helper'

class TestCommands < MiniTest::Test

  def test_help
     args = ['help']
     SportDb.main( args )
  end

end # class TestCommands
