# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_find_datafiles.rb


require 'helper'

class TestFindDatafiles < MiniTest::Test

  def match_clubs( txt )      SportDb::Import::Configuration::CLUBS_REGEX.match( txt ); end
  def match_clubs_wiki( txt ) SportDb::Import::Configuration::CLUBS_WIKI_REGEX.match( txt ); end

  def match_leagues( txt )    SportDb::Import::Configuration::LEAGUES_REGEX.match( txt ); end

  def test_find_clubs
      assert match_clubs( 'de.clubs.txt' )
      assert match_clubs( 'deutschland/de.clubs.txt' )
      assert match_clubs( 'europe/de-deutschland/clubs.txt' )
      assert match_clubs( 'de-deutschland/clubs.txt' )
      assert match_clubs( 'clubs.txt' )
      assert match_clubs( 'deutschland/clubs.txt' )

      assert !match_clubs( 'de.clubs.wiki.txt' )
      assert !match_clubs( 'deutschland/de.clubs.wiki.txt' )
      assert !match_clubs( 'europe/de-deutschland/clubs.wiki.txt' )
      assert !match_clubs( 'de-deutschland/clubs.wiki.txt' )
      assert !match_clubs( 'clubs.wiki.txt' )
      assert !match_clubs( 'deutschland/clubs.wiki.txt' )
  end

  def test_find_clubs_wiki
      assert !match_clubs_wiki( 'de.clubs.txt' )
      assert !match_clubs_wiki( 'deutschland/de.clubs.txt' )
      assert !match_clubs_wiki( 'europe/de-deutschland/clubs.txt' )
      assert !match_clubs_wiki( 'de-deutschland/clubs.txt' )
      assert !match_clubs_wiki( 'clubs.txt' )
      assert !match_clubs_wiki( 'deutschland/clubs.txt' )

      assert match_clubs_wiki( 'de.clubs.wiki.txt' )
      assert match_clubs_wiki( 'deutschland/de.clubs.wiki.txt' )
      assert match_clubs_wiki( 'europe/de-deutschland/clubs.wiki.txt' )
      assert match_clubs_wiki( 'de-deutschland/clubs.wiki.txt' )
      assert match_clubs_wiki( 'clubs.wiki.txt' )
      assert match_clubs_wiki( 'deutschland/clubs.wiki.txt' )
  end

  def test_find_leagues
      assert match_leagues( 'eng.leagues.txt' )
      assert match_leagues( 'england/eng.leagues.txt' )
      assert match_leagues( 'europe/england/leagues.txt' )
      assert match_leagues( 'england/leagues.txt' )
      assert match_leagues( 'leagues.txt' )
  end

end # class TestFindDatafiles
