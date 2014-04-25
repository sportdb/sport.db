# encoding: utf-8

require 'helper'

class TestScores < MiniTest::Unit::TestCase


  def test_scores
    data = [
     [ '10:0',  [10,0]],
     [ '1:22',  [1,22]],
     [ '1-22',  [1,22]],

     ## do not support three digits
     [ '1-222', []],  
     [ '111-0', []],
     [ '1:222', []],
     [ '111:0', []],

     ## penality only
     [ '3-4iE',    [nil,nil,nil,nil,3,4]],
     [ '3:4iE',    [nil,nil,nil,nil,3,4]],
     [ '3:4 iE',   [nil,nil,nil,nil,3,4]],
     [ '3:4 i.E.', [nil,nil,nil,nil,3,4]],
     [ '3-4 pen',  [nil,nil,nil,nil,3,4]],
     [ '3-4 PSO',  [nil,nil,nil,nil,3,4]],   # PSO  => penalty shotout
     [ '3-4p',     [nil,nil,nil,nil,3,4]],
     [ '3-4 p',    [nil,nil,nil,nil,3,4]],

     ## extra time only - allow ?? why not ?? only allow penalty w/ missing extra time?
     ## todo/fix: issue warning or error in parser!!!
     [ '3-4nV',      [nil,nil,3,4]],
     [ '3:4nV',      [nil,nil,3,4]],
     [ '3-4 aet',    [nil,nil,3,4]],
     [ '3-4 a.e.t.', [nil,nil,3,4]],

     [ '3:4nV 1:1',    [1,1,3,4]],
     [ '1:1 3:4nV',    [1,1,3,4]],
     [ '3:4 nV 1:1',   [1,1,3,4]],
     [ '3:4 n.V. 1:1', [1,1,3,4]],

     [ '3:4iE 1:1', [1,1,nil,nil,3,4]],
     [ '1:1 3:4iE', [1,1,nil,nil,3,4]],

     [ '1:1 2:2nV 3:4iE',       [1,1,2,2,3,4]],
     [ '3:4iE 2:2nV 1:1',       [1,1,2,2,3,4]],
     [ '3:4 i.E. 2:2 n.V. 1:1', [1,1,2,2,3,4]],
     [ '3-4p 2-2aet 1-1',       [1,1,2,2,3,4]],
     [ '3-4 pen 2-2 aet 1-1',   [1,1,2,2,3,4]]
    ]

    assert_scores( data )
  end

private
  def assert_scores( data )
    data.each do |rec|
      line = rec[0]
      exp  = rec[1]

      assert_equal exp, parse_scores( line )
    end  
  end

  def parse_scores( line )
     finder = SportDb::ScoresFinder.new
     finder.find!( line )
  end

end # class TestScores
