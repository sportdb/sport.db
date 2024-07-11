###
#  to run use
#     ruby test/test_date.rb


require_relative 'helper'

class TestDate < Minitest::Test


  def test_re

m=DATE_RE.match( "Jun 12 2013" )
pp m
pp m[:date]
pp m.named_captures

  assert_equal 'Jun 12 2013', m[:date]


m=DATE_RE.match( "Fri Aug/9" )
pp m
pp m[:date]
pp m.named_captures

assert_equal 'Fri Aug/9', m[:date]


m=DATE_RE.match( "[Jul 29]" )
pp m
pp m[:date]
pp m.named_captures

assert_equal 'Jul 29', m[:date]


m=RE.match( "Jul 29" )
pp m
pp m[:date]
pp m.named_captures

assert_equal 'Jul 29', m[:date]


tokens = tokenize( '[Jul 29]' )
pp tokens

assert_equal  [[:date, "Jul 29"]], tokens


end  
end # class TestDate

  