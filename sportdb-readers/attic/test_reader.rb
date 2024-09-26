###
#  to run use
#     ruby test/test_reader.rb


require_relative 'helper'


class TestReader < Minitest::Test

  def setup
    SportDb.open_mem
    ## turn on logging to console
    ## ActiveRecord::Base.logger = Logger.new(STDOUT)
  end

  def test_read
    # path = "../../../openfootball/austria/2018-19/.conf.txt"
    path = "../../../openfootball/england/2015-16/.conf.txt"
    # path = "../../../openfootball/england/2017-18/.conf.txt"
    # path = "../../../openfootball/england/2018-19/.conf.txt"
    # path = "../../../openfootball/england/2019-20/.conf.txt"
    recs = SportDb::ConfReader.read( path )
    # path = "../../../openfootball/austria/2018-19/1-bundesliga.txt"
    path = "../../../openfootball/england/2015-16/1-premierleague-i.txt"
    # path = "../../../openfootball/england/2017-18/1-premierleague-i.txt"
    # path = "../../../openfootball/england/2018-19/1-premierleague.txt"
    # path = "../../../openfootball/england/2019-20/1-premierleague.txt"
    recs = SportDb::MatchReader.read( path )
    # path = "../../../openfootball/england/2017-18/1-premierleague-ii.txt"
    #recs = SportDb::MatchReaderV2.read( path )
  end  # method test_read
end  # class TestReader
