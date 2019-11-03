# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_datafile_match.rb


require 'helper'

class TestDatafileMatch < MiniTest::Test

  def match_clubs( txt )      Datafile.match_clubs( txt ); end
  def match_clubs_wiki( txt ) Datafile.match_clubs_wiki( txt ); end
  def match_leagues( txt )    Datafile.match_leagues( txt ); end
  def match_conf( txt )       Datafile.match_conf( txt ); end


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
    CLUBS_TXT.each { |txt| assert match_clubs( txt ) }

    CLUBS_WIKI_TXT.each { |txt| assert !match_clubs( txt ) }
  end

  def test_match_clubs_wiki
    CLUBS_WIKI_TXT.each { |txt| assert match_clubs_wiki( txt ) }

    CLUBS_TXT.each { |txt| assert !match_clubs_wiki( txt ) }
  end

  def test_match_leagues
    LEAGUES_TXT.each { |txt| assert match_leagues( txt ) }
  end

  def test_match_conf
    CONF_TXT.each { |txt| assert match_conf( txt ) }
  end

end # class TestFindDatafileMatch
