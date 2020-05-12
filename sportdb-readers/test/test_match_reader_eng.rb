# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_match_reader_eng.rb


require 'helper'


class TestMatchReaderEng < MiniTest::Test

  def setup
    SportDb.connect( adapter:  'sqlite3',
                     database: ':memory:' )
    SportDb.create_all   ## build schema

    ## turn on logging to console
    ActiveRecord::Base.logger = Logger.new(STDOUT)
  end


  def test_read_eng
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

    SportDb::MatchReader.parse( txt )
  end  # method test_read_eng

  def test_read_eng_2012_13
txt =<<TXT
###
# see https://github.com/openfootball/england/blob/master/2012-13/1-premierleague-ii.txt
#
#  check for Manchester U and Manchester C matching names
#    see issue https://github.com/openfootball/england/issues/32

= English Premier League 2012/13

Matchday 20

[Sat Dec/29]
  Arsenal          7-3  Newcastle
  Aston Villa      0-3  Wigan
  Fulham           1-2  Swansea
  Manchester U.    2-0  West Bromwich
  Norwich          3-4  Manchester C.
  Reading          1-0  West Ham
  Stoke            3-3  Southampton
  Sunderland       1-2  Tottenham
[Sun Dec/30]
  Everton          1-2  Chelsea
  QPR              0-3  Liverpool
TXT

    SportDb::MatchReader.parse( txt )

    puts SportDb::Model::Game.count
  end

end  # class TestMatchReaderEng
