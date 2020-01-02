# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_regex.rb


require 'helper'

class TestRegex < MiniTest::Test

  ## note: [ ^] will NOT work as expected; will NOT match beginning of line
  ADDR_RE = %r{  (^|[ ])                     ## space or beginning of line
                    (~ | /{2,} | \+{2,})
                  ([ ]|$)                    ## space or end of line
              }x

  def test_addr
    assert  '~ Wien' =~ ADDR_RE
    assert  'Wien ~' =~ ADDR_RE
    assert 'Fischhofgasse 12 ~ 1100 Wien' =~ ADDR_RE
    assert 'Fischhofgasse 12 ++ 1100 Wien' =~ ADDR_RE
    assert 'Fischhofgasse 12 ++ 1100 Wien' =~ ADDR_RE
    assert 'Fischhofgasse 12 // 1100 Wien' =~ ADDR_RE
    assert 'Fischhofgasse 12 /// 1100 Wien' =~ ADDR_RE

    assert_nil 'Atlanta United FC, 2017,  Atlanta   › Georgia' =~ ADDR_RE
  end
end # class TestRegex
