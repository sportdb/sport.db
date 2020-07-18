# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_match_status_parser.rb


require 'helper'


class TestMatchStatusParser < MiniTest::Test

  def test_status

    ['awarded [cancelled] canceled [ddd]',
     'awarded [bbb; canceled] canceled [awarded; comments] eeee',
     'aaa bbb ccc ddd eeee'
    ].each do |line|
       puts "line (before): >#{line}<"
       status = SportDb::StatusParser.find!( line )
       puts "status: >#{status}<"
       puts "line (after): >#{line}<"
       puts
    end

  end # method test_status

end   # class TestMatchStatusParser


