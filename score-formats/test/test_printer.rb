###
#  to run use
#     ruby -I ./lib -I ./test test/test_printer.rb


require 'helper'

class TestPrinter < Minitest::Test

  def test_en
     [['0-0',                   [nil,nil, 0, 0]],
      ['0-0',                   [0, 0, 0, 0]],
      ['1-0',                   [nil,nil, 1, 0]],
      ['3-2 (1-0)',             [1, 0, 3, 2]],
      ['2-0 (0-0)',             [0, 0, 2, 0]],
      ['5-4 a.e.t.',            [nil,nil,nil,nil, 5, 4]],
      ['5-4 a.e.t. (3-2, 1-0)', [1, 0, 3, 2, 5, 4]],
      ['5-4 a.e.t. (3-2)',      [nil,nil, 3, 2, 5, 4]],
      ['6-3 pen. (3-2, 1-0)',   [1, 0, 3, 2, nil, nil, 6, 3]],
      ['6-3 pen. (3-2)',        [nil,nil, 3, 2, nil, nil, 6, 3]],
      ['6-3 pen. 5-4 a.e.t. (3-2, 1-0)',  [1, 0, 3, 2, 5, 4, 6, 3]],
     ].each do |rec|
       exp    = rec[0]
       values = rec[1]

       assert_equal exp, Score.new( *values ).to_s( lang: 'en' )
     end
  end

  def test_de
    [['0:0',                   [nil,nil, 0, 0]],
     ['0:0',                   [0, 0, 0, 0]],
     ['1:0',                   [nil,nil, 1, 0]],
     ['3:2 (1:0)',             [1, 0, 3, 2]],
     ['2:0 (0:0)',             [0, 0, 2, 0]],
     ['5:4 n.V.',              [nil,nil,nil,nil, 5, 4]],
     ['5:4 (3:2, 1:0) n.V.',   [1, 0, 3, 2, 5, 4]],
     ['5:4 (3:2) n.V.',        [nil,nil, 3, 2, 5, 4]],
     ['3:2 (1:0) 6:3 i.E.',    [1, 0, 3, 2, nil, nil, 6, 3]],
     ['3:2 6:3 i.E.',          [nil,nil, 3, 2, nil, nil, 6, 3]],
     ['5:4 (3:2, 1:0) n.V. 6:3 i.E.',  [1, 0, 3, 2, 5, 4, 6, 3]],
    ].each do |rec|
      exp    = rec[0]
      values = rec[1]

      assert_equal exp, Score.new( *values ).to_s( lang: 'de' )
    end
  end

end  # class TestPrinter

