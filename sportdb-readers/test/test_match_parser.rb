# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_match_parser.rb


require 'helper'



class TestMatchParser < MiniTest::Test

    ## build ActiveRecord-like club records/structs
    Club = Struct.new( :key, :title, :synonyms )
    def Club.read( txt )
      recs = []
      txt.each_line do |line|
        values = line.split( '|' )
        values = values.map { |value| value.strip }

        title    = values[0]
        ## note: quick hack - auto-generate key, that is, remove all non-ascii chars and downcase
        key      = title.downcase.gsub( /[^a-z]/, '' )
        synonyms = values.size > 1 ? values[1..-1].join( '|' ) : nil

        recs << Club.new( key, title, synonyms )
      end
      recs
    end


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

    clubs_txt = <<TXT
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


    clubs = Club.read( clubs_txt )
    pp clubs

    lines = txt.split( /\n+/ )    # note: removes/strips empty lines
    pp lines

    start = Date.new( 2017, 7, 1 )

    DateFormats.lang = 'en'
    parser = SportDb::MatchParserSimpleV2.new( lines, clubs, start )
    rounds, matches = parser.parse
    pp rounds
    pp matches
  end   # method test_parse
end   # class TestMatchParser
