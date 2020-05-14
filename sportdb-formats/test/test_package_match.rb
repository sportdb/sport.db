# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_package_match.rb


require 'helper'

class TestPackageMatch < MiniTest::Test

  CLUBS_DIR       = '../../../openfootball/clubs'    ## source repo directory path
  LEAGUES_DIR     = '../../../openfootball/leagues'
  AUSTRIA_DIR     = '../../../openfootball/austria'

  AUSTRIA_CSV_DIR = '../../../footballcsv/austria'


  def test_find
    datafiles = SportDb::Package.find_clubs( CLUBS_DIR )
    pp datafiles

    datafiles = SportDb::Package.find_clubs_wiki( CLUBS_DIR )
    pp datafiles

    datafiles = SportDb::Package.find_leagues( LEAGUES_DIR )
    pp datafiles

    datafiles = SportDb::Package.find_conf( AUSTRIA_DIR )
    pp datafiles

    datafiles = SportDb::Package.find_match( AUSTRIA_DIR )
    puts
    puts "== find_match (in #{AUSTRIA_DIR}) - found #{datafiles.size}:"
    pp datafiles

    datafiles = SportDb::Package.find_match( AUSTRIA_CSV_DIR )
    puts
    puts "== find_match (in #{AUSTRIA_CSV_DIR}) - found #{datafiles.size}:"
    pp datafiles


    datafiles = SportDb::Package.find_match( AUSTRIA_DIR, format: 'csv' )
    puts
    puts "== find_match+csv (in #{AUSTRIA_DIR}) - found #{datafiles.size}:"
    pp datafiles

    datafiles = SportDb::Package.find_match( AUSTRIA_CSV_DIR, format: 'csv' )
    puts
    puts "== find_match+csv (in #{AUSTRIA_CSV_DIR}) - found #{datafiles.size}:"
    pp datafiles
  end


  CLUBS_TXT = [ ## with country code
               'de.clubs.txt',
               'deutschland/de.clubs.txt',
                ## without country code
               'europe/de-deutschland/clubs.txt',
               'de-deutschland/clubs.txt',
               'deutschland/clubs.txt',
               'clubs.txt' ]

  CLUBS_WIKI_TXT = [ ## with country code
                     'de.clubs.wiki.txt',
                     'deutschland/de.clubs.wiki.txt',
                     ## without country code
                     'europe/de-deutschland/clubs.wiki.txt',
                     'de-deutschland/clubs.wiki.txt',
                     'deutschland/clubs.wiki.txt',
                     'clubs.wiki.txt' ]

  LEAGUES_TXT = [ 'europe/england/leagues.txt',
                  'england/leagues.txt',
                  'leagues.txt' ]

  CONF_TXT = [ 'austria/archives/2000s/2001-02/.conf.txt',
               'austria/2019-20/.conf.txt',
               '.conf.txt' ]


  def test_match_clubs
    CLUBS_TXT.each { |path| assert SportDb::Package.match_clubs?( path ) }

    CLUBS_WIKI_TXT.each { |path| assert !SportDb::Package.match_clubs?( path ) }
  end

  def test_match_clubs_wiki
    CLUBS_WIKI_TXT.each { |path| assert SportDb::Package.match_clubs_wiki?( path ) }

    CLUBS_TXT.each { |path| assert !SportDb::Package.match_clubs_wiki?( path ) }
  end

  def test_match_leagues
    LEAGUES_TXT.each { |path| assert SportDb::Package.match_leagues?( path ) }
  end

  def test_match_conf
    CONF_TXT.each { |path| assert SportDb::Package.match_conf?( path ) }
  end

end # class TestPackageMatch
