# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_match.rb


require 'helper'


class TestMatchParser < MiniTest::Test

  def test_parse
    txt = <<TXT
Matchday 1

[Fri Aug/11]
  Arsenal FC               4-3  Leicester City
[Sat Aug/12]
  Watford FC               3-3  Liverpool FC
  Chelsea FC               2-3  Burnley FC
  Crystal Palace           0-3  Huddersfield Town
  Everton FC               1-0  Stoke City
  Southampton FC           0-0  Swansea City
  West Bromwich Albion     1-0  AFC Bournemouth
  Brighton & Hove Albion   0-2  Manchester City
[Sun Aug/13]
  Newcastle United         0-2  Tottenham Hotspur
  Manchester United        4-0  West Ham United


Matchday 2

[Sat Aug/19]
  Swansea City             0-4  Manchester United
  AFC Bournemouth          0-2  Watford FC
  Burnley FC               0-1  West Bromwich Albion
  Leicester City           2-0  Brighton & Hove Albion
  Liverpool FC             1-0  Crystal Palace
  Southampton FC           3-2  West Ham United
  Stoke City               1-0  Arsenal FC
[Sun Aug/20]
  Huddersfield Town        1-0  Newcastle United
  Tottenham Hotspur        1-2  Chelsea FC
[Mon Aug/21]
  Manchester City          1-1  Everton FC
TXT

    clubs = <<TXT
Arsenal FC | Arsenal | FC Arsenal
Leicester City FC | Leicester | Leicester City
Watford FC | Watford | FC Watford
Liverpool FC | Liverpool | FC Liverpool
Chelsea FC | Chelsea | FC Chelsea
Burnley FC | Burnley | FC Burnley
Crystal Palace FC | Crystal Palace | C Palace | Palace | Crystal P
Huddersfield Town AFC | Huddersfield | Huddersfield Town
Everton FC | Everton | FC Everton
Stoke City FC | Stoke | Stoke City
Southampton FC | Southampton | FC Southampton
Swansea City FC | Swansea | Swansea City | Swansea City AFC
West Bromwich Albion FC | West Brom | West Bromwich Albion | West Bromwich | Albion
AFC Bournemouth | Bournemouth | A.F.C. Bournemouth | Bournemouth FC
Brighton & Hove Albion FC | Brighton | Brighton & Hove | Brighton & Hove Albion
Manchester City FC | Man City | Manchester City | Man. City | Manchester C
Newcastle United FC | Newcastle | Newcastle Utd | Newcastle United
Tottenham Hotspur FC | Tottenham | Tottenham Hotspur | Spurs
Manchester United FC | Man Utd | Man. United | Manchester U. | Manchester Utd | Manchester United
West Ham United FC | West Ham | West Ham United
TXT


    start = Date.new( 2017, 7, 1 )

    DateFormats.lang = 'en'
    SportDb.lang.lang = 'en'

    parser = SportDb::MatchParserSimpleV2.new( txt, clubs, start )
    matches, rounds  = parser.parse

    pp rounds
    pp matches
  end   # method test_parse
end   # class TestMatchParser
