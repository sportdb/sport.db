###
#  to run use
#     ruby -I ./lib -I ./test test/test_wiki_index.rb


require 'helper'

class TestWikiIndex < MiniTest::Test

  Club      = SportDb::Import::Club

  COUNTRIES = SportDb::Import.catalog.countries


  def test_clubs
    ## note: CANNOT run if no "custom" clubs_dir set
    return  if SportDb::Import.config.clubs_dir.nil?

    wiki = SportDb::Import::WikiIndex.build( SportDb::Import.config.clubs_dir )
    ## pp wiki

    ##############################################
    ## test wikipedia names and links/urls
    be = COUNTRIES.find( 'be' )

    club = Club.new
    club.name    = 'Club Brugge KV'
    club.country = be

    rec = wiki.find_by( club: club )
    assert_equal 'Club Brugge KV', rec.name


    club = Club.new
    club.name    = 'RSC Anderlecht'
    club.country = be

    rec = wiki.find_by( club: club )
    assert_equal 'R.S.C. Anderlecht', rec.name
  end

end # class TestWikiIndex
