# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_club_linter.rb


require 'helper'


class TestClubLinter < MiniTest::Test

  ClubLinter = SportDb::ClubLinter


  def test_parse_at
    headings = ClubLinter.parse( <<TXT )
= Austrian Bundesliga =

 1  FC Salzburg               |  Salzburg
 2  LASK
 3  Wolfsberger AC            |  Wolfsberg
 4  SK Sturm Graz             |  Sturm
 5  TSV Sparkasse Hartberg    |  TSV
 6  SK Rapid Wien             |  Rapid Wien
 7  SV Mattersburg            |  Mattersburg
 8  FK Austria Wien           |  Austria Wien
 9  WSG Wattens               |  Wattens
10  SKN St Pölten             |  St Pölten
11  SCR Altach                |  Altach
12  FC Admira Wacker Mödling  |  Admira
TXT

    pp headings

    heading = headings[0]
    recs    = heading[1]

    assert_equal 1, headings.size
    assert_equal 'Austrian Bundesliga', heading[0]
    assert_equal 12, recs.size
    assert_equal Hash( names: ['FC Salzburg', 'Salzburg'],
                       geos:[] ), recs[0]
    assert_equal Hash( names: ['LASK'],
                       geos: [] ),recs[1]
  end
end # class TestClubLinter
