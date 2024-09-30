###
#  to run use
#     ruby test/test_read.rb


require_relative 'helper'


class TestRead < Minitest::Test

  def test_read
    SportDb.open_mem
    ## turn on logging to console
    ## ActiveRecord::Base.logger = Logger.new(STDOUT)


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
