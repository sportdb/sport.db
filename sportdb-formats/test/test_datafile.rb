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


  CLUBS_DIR   = '../../../openfootball/clubs'    ## source repo directory path
  LEAGUES_DIR = '../../../openfootball/leagues'

  def test_bundle
    datafiles = SportDb::Package.find_clubs( CLUBS_DIR )
    pp datafiles

    ## todo/fix: turn into Datafile::Bundle.new  and Bundle#write/save -why? why not?
    bundle = Datafile::Bundle.new( './tmp/clubs.txt' )
    bundle.write <<TXT
##########################################
# auto-generated all-in-one single datafile clubs.txt bundle
#    on #{Time.now} from #{datafiles.size} datafile(s)
TXT
    bundle.write datafiles
    bundle.close
  end

  def test_bundle_old
    datafiles = SportDb::Package.find_leagues( LEAGUES_DIR )
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
