# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_conf_parser_auto.rb


require 'helper'



class TestAutoConfParser < MiniTest::Test

  def test_eng
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

    clubs = parse( txt )

    assert_equal Hash(
 'Arsenal FC'     => 2,
 'Leicester City' => 2,
 'Watford FC'     => 2,
 'Liverpool FC'   => 2,
 'Chelsea FC'     => 2,
 'Burnley FC'     => 2,
 'Crystal Palace' => 2,
 'Huddersfield Town' => 2,
 'Everton FC'     => 2,
 'Stoke City'     => 2,
 'Southampton FC' => 2,
 'Swansea City'   => 2,
 'West Bromwich Albion' => 2,
 'AFC Bournemouth' => 2,
 'Brighton & Hove Albion' => 2,
 'Manchester City'   => 2,
 'Newcastle United'  => 2,
 'Tottenham Hotspur' => 2,
 'Manchester United' => 2,
 'West Ham United'   => 2 ), clubs
  end   # method test_parse

  def test_mauritius
    txt = <<TXT
Preliminary Round
[Mon Jun/22]
  Pointe-aux-Sables Mates      3-4  AS Port-Louis 2000              @ St. François Xavier Stadium, Port Louis

Quarterfinals
[Wed Jun/24]
  Rivière du Rempart           3-1 pen (1-1) La Cure Sylvester      @ Auguste Vollaire Stadium, Central Flacq
  Chamarel SC                  3-4           Petite Rivière Noire   @ Germain Comarmond Stadium, Bambous
[Thu Jun/25]
  Pamplemousses                2-0  AS Port-Louis 2000              @ Auguste Vollaire Stadium, Central Flacq
[Sat Jun/27]
  Savanne SC                   3-6  Entente Boulet Rouge            @ Anjalay Stadium, Mapou

Semifinals
[Wed Jul/15]
  Rivière du Rempart           2-3  Petite Rivière Noire            @  New George V Stadium, Curepipe
  Entente Boulet Rouge         0-2  Pamplemousses                   @  Germain Comarmond Stadium, Bambous

Final
[Sun Jul/19]
  Petite Rivière Noire         2-0  Pamplemousses                   @ New George V Stadium, Curepipe
TXT

    clubs = parse( txt )

    assert_equal Hash(
     'Pointe-aux-Sables Mates' => 1,
     'AS Port-Louis 2000'      => 2,
     'Rivière du Rempart'      => 2,
     'La Cure Sylvester'       => 1,
     'Chamarel SC'             => 1,
     'Petite Rivière Noire'    => 3,
     'Pamplemousses'           => 3,
     'Savanne SC'              => 1,
     'Entente Boulet Rouge'    => 2), clubs
  end


################
## helper
def parse( txt, lang: 'en' )
  lines = txt.split( /\n+/ )    # note: removes/strips empty lines
  pp lines

  start = Date.new( 2017, 7, 1 )

  DateFormats.lang = lang  # e.g. 'en'
  parser = SportDb::AutoConfParser.new( lines, start )
  clubs = parser.parse
  pp clubs
  clubs
end
end   # class AutoConfParser
