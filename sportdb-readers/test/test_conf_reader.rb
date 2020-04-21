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
    recs = SportDb::ConfReaderV2.read( path )
  end  # method test_read
end  # class TestConfReader
