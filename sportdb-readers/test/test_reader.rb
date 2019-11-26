# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_reader.rb


require 'helper'


class TestReader < MiniTest::Test


  def test_read_mauritius
    SportDb.connect( adapter: 'sqlite3', database: ':memory:' )
    SportDb.create_all   ## build schema

    ## turn on logging to console
    ActiveRecord::Base.logger = Logger.new(STDOUT)

leagues_txt =<<TXT
= Mauritius =

1      Mauritius Premier League
cup    Mauritius Cup
TXT


clubs_txt =<<TXT
= Mauritius =

Cercle de Joachim | Cercle de Joachim SC | Joachim
Chamarel SC | Chamarel | Chamarel Sport Club
Curepipe Starlight | Curepipe Starlight SC
Entente Boulet Rouge | Entente Boulet Rouge SC | Entente Boulet Rouge-Riche Mare Rovers
La Cure Sylvester | La Cure Sylvester SC | La Cure
Pamplemousses | Pamplemousses SC
Petite Rivière Noire | Petite Rivière Noire SC | Petite Rivière
AS Port-Louis 2000 | ASPL 2000 | Port-Louis 2000 |Association Sportive Port-Louis 2000
AS Quatre Bornes | ASQB | Quatre Bornes
Rivière du Rempart | AS Rivière du Rempart
Pointe-aux-Sables Mates
Savanne SC | Savanne Sporting Club
TXT

    recs = SportDb::Import::LeagueReader.parse( leagues_txt )
    SportDb::Import::config.leagues.add( recs )

    recs = SportDb::Import::ClubReader.parse( clubs_txt )
    SportDb::Import::config.clubs.add( recs )

    pp recs

    country = SportDb::Import::config.countries[ 'Mauritius']
    pp country
    clubs = SportDb::Import::config.clubs.match( 'Chamarel SC' )
    pp clubs
    club = SportDb::Import::config.clubs.find_by( name: 'Chamarel SC',
                                                  country: country )
    pp club

txt =<<TXT
= Mauritius Premier League 2014/15 =

Matchday 1
[Wed Nov/5]
  Curepipe Starlight    1-3  Petite Rivière Noire
  AS Quatre Bornes      1-0  La Cure Sylvester
  Pamplemousses         0-1  Rivière du Rempart
  AS Port-Louis 2000    5-1  Entente Boulet Rouge
  Chamarel SC           2-3  Cercle de Joachim

Matchday 2
[Sun Nov/9]
  Curepipe Starlight    2-1  AS Quatre Bornes
  Entente Boulet Rouge  1-2  Chamarel SC
  Rivière du Rempart    1-1  AS Port-Louis 2000
  La Cure Sylvester     1-2  Pamplemousses
  Petite Rivière Noire  2-0  Cercle de Joachim

Matchday 3
[Wed Nov/12]
  AS Quatre Bornes      1-2  Petite Rivière Noire
  Pamplemousses         0-4  Curepipe Starlight
  Chamarel SC           1-1  Rivière du Rempart
  Cercle de Joachim     2-2  Entente Boulet Rouge
  AS Port-Louis 2000    1-0  La Cure Sylvester
TXT

    SportDb::MatchReaderV2.parse( txt )
  end  # method test_read_mauritius


  def xxx_test_read_eng
    SportDb.connect( adapter: 'sqlite3', database: ':memory:' )
    SportDb.create_all   ## build schema

    ## turn on logging to console
    ActiveRecord::Base.logger = Logger.new(STDOUT)

txt =<<TXT
= English Premier League 2017/18

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

    SportDb::MatchReaderV2.parse( txt )
  end  # method test_read_eng


  def xxx_test_read
    SportDb.connect( adapter: 'sqlite3', database: ':memory:' )
    SportDb.create_all   ## build schema

    ## turn on logging to console
    ActiveRecord::Base.logger = Logger.new(STDOUT)


    # path = "../../../openfootball/austria/2018-19/.conf.txt"
    path = "../../../openfootball/england/2015-16/.conf.txt"
    # path = "../../../openfootball/england/2017-18/.conf.txt"
    # path = "../../../openfootball/england/2018-19/.conf.txt"
    # path = "../../../openfootball/england/2019-20/.conf.txt"
    recs = SportDb::ConfReaderV2.read( path )
    # path = "../../../openfootball/austria/2018-19/1-bundesliga.txt"
    path = "../../../openfootball/england/2015-16/1-premierleague-i.txt"
    # path = "../../../openfootball/england/2017-18/1-premierleague-i.txt"
    # path = "../../../openfootball/england/2018-19/1-premierleague.txt"
    # path = "../../../openfootball/england/2019-20/1-premierleague.txt"
    recs = SportDb::MatchReaderV2.read( path )
    # path = "../../../openfootball/england/2017-18/1-premierleague-ii.txt"
    #recs = SportDb::MatchReaderV2.read( path )
  end  # method test_read
end  # class TestReader
