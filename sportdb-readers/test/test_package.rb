# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_package.rb


require 'helper'


class TestPackage < MiniTest::Test

  def test_read
    eng = Datafile::DirPackage.new( '../../../openfootball/england' )
    ## eng = Datafile::ZipPackage.new( 'tmp/england-master.zip' )
    assert eng.read_entry( '2015-16/.conf.txt' ).start_with?( '= English Premier League 2015/16' )
    assert eng.read_entry( '2017-18/.conf.txt' ).start_with?( '= English Premier League 2017/18' )
    assert eng.read_entry( '2015-16/1-premierleague-i.txt' ).start_with?( '= English Premier League 2015/16' )

    at  = Datafile::DirPackage.new( '../../../openfootball/austria' )
    ## at  = Datafile::ZipPackage.new( 'tmp/austria-master.zip' )
    assert at.read_entry( '2018-19/.conf.txt' ).start_with?( '= Österr. Bundesliga 2018/19' )
  end  # method test_read

end  # class TestPackage
