# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_reader.rb


require 'helper'


class TestReader < MiniTest::Test

  def test_read_i
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
  end  # method test_read_i


  def xxx_test_read_ii
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
  end  # method test_read_ii
end  # class TestReader
