###
#  to run use
#     ruby -I ./lib -I ./test test/test_match_status_parser.rb


require 'helper'


class TestMatchStatusParser < MiniTest::Test

   Status       = SportDb::Status
   StatusParser = SportDb::StatusParser

  def test_find
    [['awarded [cancelled] canceled [ddd]',                        Status::CANCELLED],
     ['awarded [bbb; canceled] canceled [awarded; comments] eeee', Status::AWARDED],
     ['aaa bbb ccc ddd eeee',                                      nil],
    ].each do |rec|
      line       = rec[0]
      status_exp = rec[1]
       puts "line (before): >#{line}<"
       status = StatusParser.find!( line )
       puts "status: >#{status}<"
       puts "line (after): >#{line}<"
       puts

       assert_equal status_exp, status
    end
  end # method test_find

  def test_parse
    [['cancelled ddd',        Status::CANCELLED],
     ['CANCELLED',            Status::CANCELLED],
     ['can.',                 Status::CANCELLED],
     ['awarded; comments',    Status::AWARDED],
     ['awd. - comments',      Status::AWARDED],
     ['aaa bbb ccc ddd eeee', nil],
    ].each do |rec|
      str        = rec[0]
      status_exp = rec[1]
      assert_equal status_exp, StatusParser.parse( str )
    end
  end

end   # class TestMatchStatusParser


