###
#  to run use
#     ruby test/test_match_reader_euro.rb


require_relative 'helper'


class TestMatchReaderEuro < Minitest::Test

  def setup
    SportDb.open_mem
    ## turn on logging to console
    ## ActiveRecord::Base.logger = Logger.new(STDOUT)
  end


  def test_read
txt = <<TXT
= Euro 2016       # in France


Group A | France    Romania         Albania  Switzerland
Group B | England   Russia          Wales    Slovakia
Group C | Germany   Ukraine         Poland   Northern Ireland
Group D | Spain     Czech Republic  Turkey   Croatia
Group E | Belgium   Italy           Ireland  Sweden
Group F | Portugal  Iceland         Austria  Hungary


#############################################
# Group phase

Matchday 1 | Jun/10 - Jun/14
Matchday 2 | Jun/15 - Jun/18
Matchday 3 | Jun/19 - Jun/22


Group A

(1) Jun/10  21:00   France            2-1  Romania           @ Stade de France, Saint-Denis
(2) Jun/11  15:00   Albania           0-1  Switzerland       @ Stade Bollaert-Delelis, Lens

(14) Jun/15 18:00   Romania           1-1  Switzerland       @ Parc des Princes, Paris
(15) Jun/15 21:00   France            2-0  Albania           @ Stade Vélodrome, Marseille

(25) Jun/19 21:00   Romania           0-1  Albania           @ Stade Pierre-Mauroy, Lille
(26) Jun/19 21:00   Switzerland       0-0  France            @ Parc Olympique Lyonnais, Lyon


Group B

(3) Jun/11 18:00    Wales             2-1  Slovakia          @ Nouveau Stade de Bordeaux, Bordeaux
(4) Jun/11 21:00    England           1-1  Russia            @ Stade Vélodrome, Marseille

(13) Jun/15 15:00   Russia            1-2  Slovakia          @ Stade Pierre-Mauroy, Lille
(16) Jun/16 15:00   England           2-1  Wales             @ Stade Bollaert-Delelis, Lens

(27) Jun/20 21:00   Russia            0-3  Wales             @ Stadium Municipal, Toulouse
(28) Jun/20 21:00   Slovakia          0-0  England           @ Stade Geoffroy-Guichard, Saint-Étienne


Group C

(6) Jun/12 18:00    Poland            1-0  Northern Ireland  @ Allianz Riviera, Nice
(7) Jun/12 21:00    Germany           2-0  Ukraine           @ Stade Pierre-Mauroy, Lille

(17) Jun/16 18:00   Ukraine           0-2  Northern Ireland  @ Parc Olympique Lyonnais, Lyon
(18) Jun/16 21:00   Germany           0-0  Poland            @ Stade de France, Saint-Denis

(29) Jun/21 18:00   Northern Ireland  0-1  Germany           @ Parc des Princes, Paris
(30) Jun/21 18:00   Ukraine           0-1  Poland            @ Stade Vélodrome, Marseille


Group D

(5) Jun/12 15:00    Turkey            0-1  Croatia           @ Parc des Princes, Paris
(8) Jun/13 15:00    Spain             1-0  Czech Republic    @ Stadium Municipal, Toulouse

(20) Jun/17 18:00   Czech Republic    2-2  Croatia           @ Stade Geoffroy-Guichard, Saint-Étienne
(21) Jun/17 21:00   Spain             3-0  Turkey            @ Allianz Riviera, Nice

(31) Jun/21 21:00   Croatia           2-1  Spain             @ Nouveau Stade de Bordeaux, Bordeaux
(32) Jun/21 21:00   Czech Republic    0-2  Turkey            @ Stade Bollaert-Delelis, Lens


Group E

(10) Jun/13 21:00   Belgium           0-2  Italy             @ Parc Olympique Lyonnais, Lyon
 (9) Jun/13 18:00   Ireland           1-1  Sweden            @ Stade de France, Saint-Denis

(19) Jun/17 15:00   Italy             1-0  Sweden            @ Stadium Municipal, Toulouse
(22) Jun/18 15:00   Belgium           3-0  Ireland           @ Nouveau Stade de Bordeaux, Bordeaux

(35) Jun/21 21:00   Italy             0-1  Ireland           @ Stade Pierre-Mauroy, Lille
(36) Jun/21 21:00   Sweden            0-1  Belgium           @ Allianz Riviera, Nice


Group F

(11) Jun/14 18:00   Austria           0-2  Hungary           @ Nouveau Stade de Bordeaux, Bordeaux
(12) Jun/14 21:00   Portugal          1-1  Iceland           @ Stade Geoffroy-Guichard, Saint-Étienne

(23) Jun/18 18:00   Iceland           1-1  Hungary           @ Stade Vélodrome, Marseille
(24) Jun/18 21:00   Portugal          0-0  Austria           @ Parc des Princes, Paris

(33) Jun/22 18:00   Hungary           3-3  Portugal          @ Parc Olympique Lyonnais, Lyon
(34) Jun/21 18:00   Iceland           2-1  Austria           @ Stade de France, Saint-Denis


#############################
# Knockout phase

Round of 16

(37) Jun/25 15:00   Switzerland  4-5 pen. 1-1 a.e.t. (0-0,) Poland            @ Stade Geoffroy-Guichard, Saint-Étienne
(38) Jun/25 18:00   Wales        1-0              Northern Ireland  @ Parc des Princes, Paris
(39) Jun/25 21:00   Croatia      0-1 a.e.t. (0-0,)    Portugal          @ Stade Bollaert-Delelis, Lens

(40) Jun/26 15:00   France       2-1              Ireland           @ Parc Olympique Lyonnais, Lyon
(41) Jun/26 18:00   Germany      3-0              Slovakia          @ Stade Pierre-Mauroy, Lille
(42) Jun/26 21:00   Hungary      0-4              Belgium           @ Stadium Municipal, Toulouse

(43) Jun/27 18:00   Italy        2-0              Spain             @ Stade de France, Saint-Denis
(44) Jun/27 21:00   England      1-2              Iceland           @ Allianz Riviera, Nice


Quarter-finals

(45) Jun/30 21:00   Poland       3-5 pen. 1-1 a.e.t. (0-0,)   Portugal          @ Stade Vélodrome, Marseille
(46) Jul/1  21:00   Wales        3-1              Belgium           @ Stade Pierre-Mauroy, Lille
(47) Jul/2  21:00   Germany      6-5 pen. 1-1 a.e.t. (0-0,)   Italy             @ Nouveau Stade de Bordeaux, Bordeaux
(48) Jul/3  21:00   France       5-2              Iceland           @ Stade de France, Saint-Denis


Semi-finals

(49) Jul/6  21:00   Portugal     2-0              Wales             @ Parc Olympique Lyonnais, Lyon
(50) Jul/7  21:00   Germany      0-2              France            @ Stade Vélodrome, Marseille


Final
(51) Jul/10 21:00   Portugal     1-0 a.e.t. (0-0,)     France            @ Stade de France, Saint-Denis
TXT


    SportDb::MatchReader.parse( txt )
  end
end  # class TestMatchReaderEuro


