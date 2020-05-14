# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_datafile.rb



require 'helper'

class TestDatafile < MiniTest::Test


  def test_exclude
    assert Datafile::Package.match_exclude?( '.build/' )
    assert Datafile::Package.match_exclude?( '.git/' )
    assert Datafile::Package.exclude?( '.build/' )
    assert Datafile::Package.exclude?( '.git/' )


    assert Datafile::Package.match_exclude?( '/.build/' )
    assert Datafile::Package.match_exclude?( '/.git/' )

    assert Datafile::Package.match_exclude?( '.build/leagues.txt' )
    assert Datafile::Package.match_exclude?( '.git/leagues.txt' )

    assert Datafile::Package.match_exclude?( '/.build/leagues.txt' )
    assert Datafile::Package.match_exclude?( '/.git/leagues.txt' )
  end
end   # class TestDatafile
