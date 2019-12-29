# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_datafile.rb



require 'helper'

class TestDatafile < MiniTest::Test

  def test_exclude
    assert Datafile.match_exclude( '.build/' )
    assert Datafile.match_exclude( '.git/' )

    assert Datafile.match_exclude( '/.build/' )
    assert Datafile.match_exclude( '/.git/' )

    assert Datafile.match_exclude( '.build/leagues.txt' )
    assert Datafile.match_exclude( '.git/leagues.txt' )

    assert Datafile.match_exclude( '/.build/leagues.txt' )
    assert Datafile.match_exclude( '/.git/leagues.txt' )
  end



  CLUBS_DIR   = '../../../openfootball/clubs'    ## source repo directory path
  LEAGUES_DIR = '../../../openfootball/leagues'
  AUSTRIA_DIR = '../../../openfootball/austria'

  def test_find
    datafiles = Datafile.find_clubs( CLUBS_DIR )
    pp datafiles

    datafiles = Datafile.find_clubs_wiki( CLUBS_DIR )
    pp datafiles

    datafiles = Datafile.find_leagues( LEAGUES_DIR )
    pp datafiles

    datafiles = Datafile.find_conf( AUSTRIA_DIR )
    pp datafiles
  end


  def test_bundle
    datafiles = Datafile.find_clubs( CLUBS_DIR )
    pp datafiles

    Datafile.write_bundle( './tmp/clubs.txt',
                           datafiles: datafiles,
                           header: <<TXT )
##########################################
# auto-generated all-in-one single datafile clubs.txt bundle
#    on #{Time.now} from #{datafiles.size} datafile(s)
TXT

    datafiles = Datafile.find_leagues( LEAGUES_DIR )
    pp datafiles

    Datafile.write_bundle( './tmp/leagues.txt',
                           datafiles: datafiles,
                           header: <<TXT )
##########################################
# auto-generated all-in-one single datafile leagues.txt bundle
#    on #{Time.now} from #{datafiles.size} datafile(s)
TXT
  end
end   # class TestDatafile
