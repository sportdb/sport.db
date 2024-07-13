###
#  to run use
#     ruby test/test_score.rb


require_relative 'helper'


class TestScore < Minitest::Test

  def test_re
    lines = [
        '3-4 pen. 2-2 a.e.t.',   
        '3-4 pen.   2-2 a.e.t.',
        '3-4 p. 2-2 a.e.t.',
        '3-4p 2-2aet',
        '2-2 a.e.t.',
        '3-4 pen. (1-1)',
        '3-4p (1-1)',
        '4-2 (2-1)',
        '4-2   (2-1)',
        '2-1',
    ]

    lines.each do |line|
        m = SCORE_RE.match( line )
        pp m
        pp m[:score]
        pp m.named_captures
    
        ## assert_equal exp, m[:text]
      end
  end

  def test_scores
lines = {
  '3-4 pen. 2-2 a.e.t.'   =>  [[:score, "3-4 pen. 2-2 a.e.t."]],
  '3-4 pen.   2-2 a.e.t.' =>  [[:score, "3-4 pen.   2-2 a.e.t."]],
  '3-4 p. 2-2 a.e.t.'     =>  [[:score, "3-4 p. 2-2 a.e.t."]],
  '3-4p 2-2aet'           =>  [[:score, "3-4p 2-2aet"]],
  '2-2 a.e.t.'            =>  [[:score, "2-2 a.e.t."]],

  '3-4 pen. 2-2 a.e.t. (1-1, 1-1)'   => [[:score, "3-4 pen. 2-2 a.e.t. (1-1, 1-1)"]],
  '3-4 pen. 2-2 a.e.t. (1-1,1-1)'    => [[:score, "3-4 pen. 2-2 a.e.t. (1-1,1-1)"]],
  '3-4 pen. 2-2 a.e.t. (1-1,   1-1)' => [[:score, "3-4 pen. 2-2 a.e.t. (1-1,   1-1)"]],
  '3-4 pen. 2-2 a.e.t. (1-1, )'  => [[:score, "3-4 pen. 2-2 a.e.t. (1-1, )"]],
  '3-4 pen. 2-2 a.e.t. (1-1)'  => [[:score, "3-4 pen. 2-2 a.e.t. (1-1)"]],
  '2-2 a.e.t. (1-1, 1-1)'  => [[:score, "2-2 a.e.t. (1-1, 1-1)"]],
  '2-2 a.e.t. (1-1, )'  => [[:score, "2-2 a.e.t. (1-1, )"]],
  '2-2 a.e.t. (1-1)'  => [[:score, "2-2 a.e.t. (1-1)"]],

  '3-4 pen. (1-1, 1-1)' => [[:score, "3-4 pen. (1-1, 1-1)"]],
  '3-4 pen. (1-1, )'    => [[:score, "3-4 pen. (1-1, )"]],
  '3-4 pen. (1-1)'      => [[:score, "3-4 pen. (1-1)"]], 
  '3-4p (1-1)'          => [[:score, "3-4p (1-1)"]], 

  '4-2 (2-1)' => [[:score, "4-2 (2-1)"]],
  '4-2   (2-1)' => [[:score, "4-2   (2-1)"]],
  '2-1'       => [[:score, "2-1"]],
}

  assert_lines( lines )
end

end   # class TestScore