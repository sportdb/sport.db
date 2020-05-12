# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_conf_reader.rb


require 'helper'


class TestConfReader < MiniTest::Test

  def setup
    SportDb.connect( adapter:  'sqlite3',
                     database: ':memory:' )
    SportDb.create_all   ## build schema

    ## turn on logging to console
    ActiveRecord::Base.logger = Logger.new(STDOUT)
  end

  def test_read
    # path = "../../../openfootball/austria/2018-19/.conf.txt"
    path = "../../../openfootball/england/2015-16/.conf.txt"
    # path = "../../../openfootball/england/2017-18/.conf.txt"
    # path = "../../../openfootball/england/2018-19/.conf.txt"
    # path = "../../../openfootball/england/2019-20/.conf.txt"
    SportDb::ConfReader.read( path )
  end  # method test_read


  def test_read_champs
txt =<<TXT
= UEFA Champions League 2017/18

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

    SportDb::ConfReader.parse( txt )
  end
end  # class TestConfReader
