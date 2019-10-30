# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_read.rb


require 'helper'


class TestRead < MiniTest::Test

  def test_read

    SportDb.connect( adapter: 'sqlite3', database: ':memory:' )
    SportDb.create_all   ## build schema

    ## turn on logging to console
    ActiveRecord::Base.logger = Logger.new(STDOUT)


    path = "../../../openfootball/england/2015-16/.conf.txt"
    # path = "../../../openfootball/england/2017-18/.conf.txt"
    # path = "../../../openfootball/england/2018-19/.conf.txt"
    # path = "../../../openfootball/england/2019-20/.conf.txt"
    SportDb.read( path )
    path = "../../../openfootball/england/2015-16/1-premierleague-i.txt"
    # path = "../../../openfootball/england/2017-18/1-premierleague-i.txt"
    # path = "../../../openfootball/england/2018-19/1-premierleague.txt"
    # path = "../../../openfootball/england/2019-20/1-premierleague.txt"
    SportDb.read( path )
    # path = "../../../openfootball/england/2017-18/1-premierleague-ii.txt"
    # SportDb.read( path )
  end  # method test_read
end  # class TestReader
