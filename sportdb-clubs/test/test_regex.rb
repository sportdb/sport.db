# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_regex.rb


require 'helper'

class TestRegex < MiniTest::Test

  ADDR_MARKER_RE   = SportDb::Import::ClubReader::ADDR_MARKER_RE
  B_TEAM_MARKER_RE = SportDb::Import::ClubReader::B_TEAM_MARKER_RE
  
  def test_addr
    assert  '~ Wien' =~ ADDR_MARKER_RE
    assert  'Wien ~' =~ ADDR_MARKER_RE
    assert 'Fischhofgasse 12 ~ 1100 Wien'   =~ ADDR_MARKER_RE
    assert 'Fischhofgasse 12 ++ 1100 Wien'  =~ ADDR_MARKER_RE
    assert 'Fischhofgasse 12 +++ 1100 Wien' =~ ADDR_MARKER_RE
    assert 'Fischhofgasse 12 // 1100 Wien'  =~ ADDR_MARKER_RE
    assert 'Fischhofgasse 12 /// 1100 Wien' =~ ADDR_MARKER_RE

    assert_nil 'Fischhofgasse 12 + 1100 Wien' =~ ADDR_MARKER_RE
    assert_nil 'Fischhofgasse 12++1100 Wien' =~ ADDR_MARKER_RE
    assert_nil 'Fischhofgasse 12 / 1100 Wien' =~ ADDR_MARKER_RE
    assert_nil 'Fischhofgasse 12//1100 Wien' =~ ADDR_MARKER_RE
    
    assert_nil 'Atlanta United FC, 2017,  Atlanta   › Georgia' =~ ADDR_MARKER_RE
  end
  
  def test_b_team
    assert 'b)    Rapid Wien II' =~ B_TEAM_MARKER_RE
    assert '(b)   Rapid Wien II' =~ B_TEAM_MARKER_RE
    assert '(b.)  Rapid Wien II' =~ B_TEAM_MARKER_RE
    assert 'ii)   Rapid Wien II' =~ B_TEAM_MARKER_RE
    assert 'II)   Rapid Wien II' =~ B_TEAM_MARKER_RE
    assert '(ii.) Rapid Wien II' =~ B_TEAM_MARKER_RE
    assert '2)    Rapid Wien II' =~ B_TEAM_MARKER_RE
    assert '(2)   Rapid Wien II' =~ B_TEAM_MARKER_RE
 
    assert_nil '(3)   Rapid Wien II' =~ B_TEAM_MARKER_RE
    assert_nil '(iii) Rapid Wien II' =~ B_TEAM_MARKER_RE
    assert_nil 'iii)  Rapid Wien II' =~ B_TEAM_MARKER_RE
    assert_nil 'c)    Rapid Wien II' =~ B_TEAM_MARKER_RE
    assert_nil '(c)   Rapid Wien II' =~ B_TEAM_MARKER_RE
  end
  
end # class TestRegex
