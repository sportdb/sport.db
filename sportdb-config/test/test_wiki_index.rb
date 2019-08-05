# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_wiki_index.rb


require 'helper'

class TestWikiIndex < MiniTest::Test

  def test_clubs
    wiki = SportDb::Import::WikiIndex.build( SportDb::Import.config.clubs_dir )
    ## pp wiki

    ##############################################
    ## test wikipedia names and links/urls
    be = SportDb::Import.config.countries[ 'be' ]

    club = SportDb::Import::Club.new
    club.name    = 'Club Brugge KV'
    club.country = be

    rec = wiki.find_by( club: club )
    assert_equal 'Club Brugge KV', rec.name


    club = SportDb::Import::Club.new
    club.name    = 'RSC Anderlecht'
    club.country = be

    rec = wiki.find_by( club: club )
    assert_equal 'R.S.C. Anderlecht', rec.name
  end

end # class TestWikiIndex
