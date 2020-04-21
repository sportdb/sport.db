# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_conf.rb


require 'helper'


class TestConf < MiniTest::Test

  COUNTRY_RE = SportDb::ConfParser::COUNTRY_RE

  def test_re
    m=COUNTRY_RE.match( 'Manchester United › ENG' )
    pp m
    pp m[0]
    assert_equal  'ENG', m[:country]

    m=COUNTRY_RE.match( 'Manchester United›ENG' )
    pp m
    pp m[0]
    assert_equal  'ENG', m[:country]
  end


  def test_at
    txt= <<TXT
FC Red Bull Salzburg      ## Bundesliga
FK Austria Wien
SK Rapid Wien
SK Sturm Graz
SC Wiener Neustadt
SV Mattersburg
SV Ried
Kapfenberger SV
FC Wacker Innsbruck
FC Admira Wacker Mödling

TSV Hartberg              ## Erste Liga
SV Grödig
SC Austria Lustenau

FC Red Bull Salzburg II   ## Landes-Cup-Sieger
TXT

  clubs = parse_conf( txt )

  assert_equal Hash(
   'FC Red Bull Salzburg'     =>{:count=>1},
   'FK Austria Wien'          =>{:count=>1},
   'SK Rapid Wien'            =>{:count=>1},
   'SK Sturm Graz'            =>{:count=>1},
   'SC Wiener Neustadt'       =>{:count=>1},
   'SV Mattersburg'           =>{:count=>1},
   'SV Ried'                  =>{:count=>1},
   'Kapfenberger SV'          =>{:count=>1},
   'FC Wacker Innsbruck'      =>{:count=>1},
   'FC Admira Wacker Mödling' =>{:count=>1},
   'TSV Hartberg'             =>{:count=>1},
   'SV Grödig'                =>{:count=>1},
   'SC Austria Lustenau'      =>{:count=>1},
   'FC Red Bull Salzburg II'  =>{:count=>1}  ), clubs
  end


  def test_eng
    txt= <<TXT
1  Manchester City         38  32  4  2 106-27 100
2  Manchester United       38  25  6  7  68-28  81
3  Tottenham Hotspur       38  23  8  7  74-36  77
4  Liverpool               38  21 12  5  84-38  75
5  Chelsea                 38  21  7 10  62-38  70
6  Arsenal                 38  19  6 13  74-51  63
7  Burnley                 38  14 12 12  36-39  54
8  Everton                 38  13 10 15  44-58  49
9  Leicester City          38  12 11 15  56-60  47
10  Newcastle United        38  12  8 18  39-47  44
11  Crystal Palace          38  11 11 16  45-55  44
12  AFC Bournemouth         38  11 11 16  45-61  44
13  West Ham United         38  10 12 16  48-68  42
14  Watford                 38  11  8 19  44-64  41
15  Brighton & Hove Albion  38   9 13 16  34-54  40
16  Huddersfield Town       38   9 10 19  28-58  37
17  Southampton             38   7 15 16  37-56  36
---------------------------------------------------
18  Swansea City            38   8  9 21  28-56  33
19  Stoke City              38   7 12 19  35-68  33
20  West Bromwich Albion    38   6 13 19  31-56  31
TXT

  clubs = parse_conf( txt )

  assert_equal Hash(
  'Manchester City'        =>{:count=>1, :rank=>'1',  :standing=>'38  32  4  2 106-27 100'},
  'Manchester United'      =>{:count=>1, :rank=>'2',  :standing=>'38  25  6  7  68-28  81'},
  'Tottenham Hotspur'      =>{:count=>1, :rank=>'3',  :standing=>'38  23  8  7  74-36  77'},
  'Liverpool'              =>{:count=>1, :rank=>'4',  :standing=>'38  21 12  5  84-38  75'},
  'Chelsea'                =>{:count=>1, :rank=>'5',  :standing=>'38  21  7 10  62-38  70'},
  'Arsenal'                =>{:count=>1, :rank=>'6',  :standing=>'38  19  6 13  74-51  63'},
  'Burnley'                =>{:count=>1, :rank=>'7',  :standing=>'38  14 12 12  36-39  54'},
  'Everton'                =>{:count=>1, :rank=>'8',  :standing=>'38  13 10 15  44-58  49'},
  'Leicester City'         =>{:count=>1, :rank=>'9',  :standing=>'38  12 11 15  56-60  47'},
  'Newcastle United'       =>{:count=>1, :rank=>'10', :standing=>'38  12  8 18  39-47  44'},
  'Crystal Palace'         =>{:count=>1, :rank=>'11', :standing=>'38  11 11 16  45-55  44'},
  'AFC Bournemouth'        =>{:count=>1, :rank=>'12', :standing=>'38  11 11 16  45-61  44'},
  'West Ham United'        =>{:count=>1, :rank=>'13', :standing=>'38  10 12 16  48-68  42'},
  'Watford'                =>{:count=>1, :rank=>'14', :standing=>'38  11  8 19  44-64  41'},
  'Brighton & Hove Albion' =>{:count=>1, :rank=>'15', :standing=>'38   9 13 16  34-54  40'},
  'Huddersfield Town'      =>{:count=>1, :rank=>'16', :standing=>'38   9 10 19  28-58  37'},
  'Southampton'            =>{:count=>1, :rank=>'17', :standing=>'38   7 15 16  37-56  36'},
  'Swansea City'           =>{:count=>1, :rank=>'18', :standing=>'38   8  9 21  28-56  33'},
  'Stoke City'             =>{:count=>1, :rank=>'19', :standing=>'38   7 12 19  35-68  33'},
  'West Bromwich Albion'   =>{:count=>1, :rank=>'20', :standing=>'38   6 13 19  31-56  31'}), clubs
  end


  def test_champs
    txt= <<TXT
Manchester United › ENG
Liverpool         › ENG
Chelsea           › ENG
Manchester City   › ENG
Tottenham Hotspur › ENG

Atlético Madrid › ESP
Barcelona       › ESP
Sevilla         › ESP
Real Madrid     › ESP

Roma     › ITA
Juventus › ITA
Napoli   › ITA

Bayern München    › GER
Borussia Dortmund › GER
RB Leipzig        › GER

Benfica     › POR
Sporting CP › POR
Porto       › POR

CSKA Moscow    › RUS
Spartak Moscow › RUS

Paris Saint-Germain › FRA
Basel › SUI
Celtic › SCO
Anderlecht › BEL
Qarabağ › AZE
Olympiacos › GRE
Maribor › SVN
Shakhtar Donetsk › UKR
Feyenoord › NED
Beşiktaş › TUR
Monaco › MCO
APOEL › CYP
TXT

    clubs = parse_conf( txt )

    assert_equal Hash(
      'Manchester United'   =>{:count=>1, :country=>'ENG'},
      'Liverpool'           =>{:count=>1, :country=>'ENG'},
      'Chelsea'             =>{:count=>1, :country=>'ENG'},
      'Manchester City'     =>{:count=>1, :country=>'ENG'},
      'Tottenham Hotspur'   =>{:count=>1, :country=>'ENG'},
      'Atlético Madrid'     =>{:count=>1, :country=>'ESP'},
      'Barcelona'           =>{:count=>1, :country=>'ESP'},
      'Sevilla'             =>{:count=>1, :country=>'ESP'},
      'Real Madrid'         =>{:count=>1, :country=>'ESP'},
      'Roma'                =>{:count=>1, :country=>'ITA'},
      'Juventus'            =>{:count=>1, :country=>'ITA'},
      'Napoli'              =>{:count=>1, :country=>'ITA'},
      'Bayern München'      =>{:count=>1, :country=>'GER'},
      'Borussia Dortmund'   =>{:count=>1, :country=>'GER'},
      'RB Leipzig'          =>{:count=>1, :country=>'GER'},
      'Benfica'             =>{:count=>1, :country=>'POR'},
      'Sporting CP'         =>{:count=>1, :country=>'POR'},
      'Porto'               =>{:count=>1, :country=>'POR'},
      'CSKA Moscow'         =>{:count=>1, :country=>'RUS'},
      'Spartak Moscow'      =>{:count=>1, :country=>'RUS'},
      'Paris Saint-Germain' =>{:count=>1, :country=>'FRA'},
      'Basel'               =>{:count=>1, :country=>'SUI'},
      'Celtic'              =>{:count=>1, :country=>'SCO'},
      'Anderlecht'          =>{:count=>1, :country=>'BEL'},
      'Qarabağ'             =>{:count=>1, :country=>'AZE'},
      'Olympiacos'          =>{:count=>1, :country=>'GRE'},
      'Maribor'             =>{:count=>1, :country=>'SVN'},
      'Shakhtar Donetsk'    =>{:count=>1, :country=>'UKR'},
      'Feyenoord'           =>{:count=>1, :country=>'NED'},
      'Beşiktaş'            =>{:count=>1, :country=>'TUR'},
      'Monaco'              =>{:count=>1, :country=>'MCO'},
      'APOEL'               =>{:count=>1, :country=>'CYP'}), clubs
  end
end   # class TestConf
