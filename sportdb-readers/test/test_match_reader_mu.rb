# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_match_reader_mu.rb


require 'helper'


class TestMatchReaderMu < MiniTest::Test

  def setup
    SportDb.connect( adapter:  'sqlite3',
                     database: ':memory:' )
    SportDb.create_all   ## build schema

    ## turn on logging to console
    ActiveRecord::Base.logger = Logger.new(STDOUT)
  end


  def test_read_mauritius
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
    SportDb::Import.catalog.leagues.add( recs )

    recs = SportDb::Import::ClubReader.parse( clubs_txt )
    SportDb::Import.catalog.clubs.add( recs )

    pp recs

    country = SportDb::Import.catalog.countries.find( 'Mauritius' )
    pp country

    clubs = SportDb::Import.catalog.clubs.match( 'Chamarel SC' )
    pp clubs
    club = SportDb::Import.catalog.clubs.find_by( name: 'Chamarel SC',
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

    SportDb::MatchReader.parse( txt )
  end  # method test_read_mauritius

end  # class TestMatchReaderMu
