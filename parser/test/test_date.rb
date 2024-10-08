###
#  to run use
#     ruby test/test_date.rb


require_relative 'helper'

## date & time

class TestDate < Minitest::Test

  def test_timezone
    m = TIMEZONE_RE.match( '(CEST/UTC+2)' )
    pp m
    pp m[:timezone]
    pp m.named_captures

    assert_equal '(CEST/UTC+2)', m[:timezone]

    m = TIMEZONE_RE.match( '(UTC+2)' )
    pp m
    pp m[:timezone]
    pp m.named_captures

    assert_equal '(UTC+2)', m[:timezone]

    m = TIMEZONE_RE.match( '(BRT/UTC-3)' )
    pp m
    pp m[:timezone]
    pp m.named_captures

    assert_equal '(BRT/UTC-3)', m[:timezone]
  end


  def test_duration
    m = DURATION_RE.match( 'Sun Jun/23 - Wed Jun/26' )
    pp m
    pp m[:duration]
    pp m.named_captures

    assert_equal 'Sun Jun/23 - Wed Jun/26', m[:duration]


    m = DURATION_RE.match( 'Jun/23 - Jun/26' )
    pp m
    pp m[:duration]
    pp m.named_captures

    assert_equal 'Jun/23 - Jun/26', m[:duration]

=begin
    m = DURATION_RE.match( 'Tue Jun/25 + Wed Jun/26' )
    pp m
    pp m[:duration]
    pp m.named_captures

    assert_equal 'Tue Jun/25 + Wed Jun/26', m[:duration]


    m = DURATION_RE.match( 'Jun/25 + Jun/26' )
    pp m
    pp m[:duration]
    pp m.named_captures

    assert_equal 'Jun/25 + Jun/26', m[:duration]
=end
  end


  def test_date

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

