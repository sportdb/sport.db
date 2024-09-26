###
#  to run use
#     ruby test/test_match_reader_mu.rb




require_relative 'helper'


class TestMatchReaderMu < Minitest::Test

  def setup
    SportDb.open_mem
    ## turn on logging to console
    ## ActiveRecord::Base.logger = Logger.new(STDOUT)
  end


  def test_read_mauritius
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
