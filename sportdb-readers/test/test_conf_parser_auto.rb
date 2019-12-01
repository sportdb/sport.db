# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_conf_parser_auto.rb


require 'helper'



class TestAutoConfParser < MiniTest::Test

  def test_at
    txt = <<TXT
29. Runde

[Sa 7.4.]
  16.00   RB Salzburg       2:0   Wacker Innsbruck
  18.30   SV Ried           0:1   Austria Wien
          Kapfenberger SV   2:3   Admira Wacker
          Rapid Wien        2:1   Wr. Neustadt
[So 8.4.]
  16.00   SV Mattersburg    0:2   Sturm Graz


30. Runde

[Sa 14.4.]
  16.00   Wr. Neustadt         0:0   Kapfenberger SV
  18.30   Admira Wacker        1:1   Wacker Innsbruck
          Sturm Graz           2:2   RB Salzburg
          SV Ried              2:0   SV Mattersburg
[So 15.4.]
  16.00   Austria Wien         0:0   Rapid Wien

TXT

  clubs = parse( txt, lang: 'de' )

    assert_equal Hash(
    'RB Salzburg' => 2,
    'Wacker Innsbruck' => 2,
    'SV Ried' => 2,
    'Austria Wien' => 2,
    'Kapfenberger SV' => 2,
    'Admira Wacker' => 2,
    'Rapid Wien' => 2,
    'Wr. Neustadt' => 2,
    'SV Mattersburg' => 2,
    'Sturm Graz' => 2 ), clubs
  end

  def test_es
    txt = <<TXT
Jornada 1

18.08.2012   Barcelona  R. Sociedad  5-1
18.08.2012   Levante  Atlético  1-1
18.08.2012   Athletic  Betis  3-5
18.08.2012   Zaragoza  Valladolid  0-1
18.08.2012   R. Madrid  Valencia  1-1
18.08.2012   Celta  Málaga  0-1
18.08.2012   Sevilla  Getafe  2-1
18.08.2012   Mallorca  Espanyol  2-1
18.08.2012   Rayo  Granada  1-0
18.08.2012   Deportivo  Osasuna  2-0


Jornada 2

25.08.2012   Valladolid  Levante  2-0
25.08.2012   Espanyol  Zaragoza  1-2
25.08.2012   Málaga  Mallorca  1-1
25.08.2012   R. Sociedad  Celta  2-1
25.08.2012   Osasuna  Barcelona  1-2
25.08.2012   Valencia  Deportivo  3-3
25.08.2012   Getafe  R. Madrid  2-1
25.08.2012   Granada  Sevilla  1-1
25.08.2012   Betis  Rayo  1-2
25.08.2012   Atlético  Athletic  4-0
TXT

    clubs = parse( txt, lang: 'es' )

    assert_equal Hash(#
 'Barcelona' => 2,
 'R. Sociedad' => 2,
 'Levante' => 2,
 'Atlético' => 2,
 'Athletic' => 2,
 'Betis' => 2,
 'Zaragoza' => 2,
 'Valladolid' => 2,
 'R. Madrid' => 2,
 'Valencia' => 2,
 'Celta' => 2,
 'Málaga' => 2,
 'Sevilla' => 2,
 'Getafe' => 2,
 'Mallorca' => 2,
 'Espanyol' => 2,
 'Rayo' => 2,
 'Granada' => 2,
 'Deportivo' => 2,
 'Osasuna' => 2), clubs
  end


  def test_fr
    txt = <<TXT
Journée 1

[Ven 8. Août]
  20h30  Stade de Reims  2-2  Paris SG
[Sam 9. Août]
  21h00  SC Bastia      3-3  Olympique de Marseille
         Évian TG       0-3  SM Caen
         EA Guingamp    0-2  AS Saint-Étienne
         LOSC Lille     0-0  FC Metz
         Montpellier Hérault SC  0-1  Girondins de Bordeaux
         FC Nantes      1-0  RC Lens
         OGC Nice       3-2  Toulouse FC
[Dim 10. Août]
  17h00  Olympique Lyonnais  2-0  Stade Rennais FC
  21h00  AS Monaco FC  1-2  FC Lorient

Journée 2

[Ven 15. Août]
  20h30  SM Caen 0-1 LOSC Lille
[Sam 16. Août]
  17h00  Paris SG 2-0 SC Bastia
  20h00  RC Lens 0-1 EA Guingamp
         FC Lorient 0-0 OGC Nice
         FC Metz 1-1 FC Nantes
         Stade Rennais FC 6-2 Évian TG
         Toulouse FC 2-1 Olympique Lyonnais
[Dim 17. Août]
  17h00  Olympique de Marseille 0-2 Montpellier Hérault SC
         AS Saint-Étienne 3-1 Stade de Reims
  21h00  Girondins de Bordeaux 4-1 AS Monaco FC
TXT

    clubs = parse( txt, lang: 'fr' )

    assert_equal Hash(
 'Stade de Reims' => 2,
 'Paris SG' => 2,
 'SC Bastia' => 2,
 'Olympique de Marseille' => 2,
 'Évian TG' => 2,
 'SM Caen' => 2,
 'EA Guingamp' => 2,
 'AS Saint-Étienne' => 2,
 'LOSC Lille' => 2,
 'FC Metz' => 2,
 'Montpellier Hérault SC' => 2,
 'Girondins de Bordeaux' => 2,
 'FC Nantes' => 2,
 'RC Lens' => 2,
 'OGC Nice' => 2,
 'Toulouse FC' => 2,
 'Olympique Lyonnais' => 2,
 'Stade Rennais FC' => 2,
 'AS Monaco FC' => 2,
 'FC Lorient' => 2), clubs
  end

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


    txt =<<TXT
Round 38

May/22 Aston Villa 1-0 Liverpool
May/22 Bolton 0-2 Manchester City
May/22 Everton 1-0 Chelsea
May/22 Fulham 2-2 Arsenal
May/22 Manchester United 4-2 Blackpool
May/22 Newcastle Utd 3-3 West Brom
May/22 Stoke City 0-1 Wigan
May/22 Tottenham 2-1 Birmingham
May/22 West Ham 0-3 Sunderland
May/22 Wolves 2-3 Blackburn

Round 37

May/17 Manchester City 3-0 Stoke City
May/15 Arsenal 1-2 Aston Villa
May/15 Birmingham 0-2 Fulham
May/15 Liverpool 0-2 Tottenham
May/15 Wigan 3-2 West Ham
May/15 Chelsea 2-2 Newcastle Utd
May/14 Blackburn 1-1 Manchester United
May/14 Blackpool 4-3 Bolton
May/14 Sunderland 1-3 Wolves
May/14 West Brom 1-0 Everton
TXT
    clubs = parse( txt )

    assert_equal Hash(
  'Aston Villa' => 2,
  'Liverpool' => 2,
  'Bolton' => 2,
  'Manchester City' => 2,
  'Everton' => 2,
  'Chelsea' => 2,
  'Fulham' => 2,
  'Arsenal' => 2,
  'Manchester United' => 2,
  'Blackpool' => 2,
  'Newcastle Utd' => 2,
  'West Brom' => 2,
  'Stoke City'=> 2,
  'Wigan' => 2,
  'Tottenham' => 2,
  'Birmingham' => 2,
  'West Ham' => 2,
  'Sunderland' => 2,
  'Wolves' => 2,
  'Blackburn' => 2), clubs
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
