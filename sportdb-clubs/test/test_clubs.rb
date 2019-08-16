# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_clubs.rb


require 'helper'

class TestClubs < MiniTest::Test

  def strip_lang( name ) SportDb::Import::Club.strip_lang( name ); end
  def strip_year( name ) SportDb::Import::Club.strip_year( name ); end


  def test_lang
    assert_equal 'Bayern Munich', strip_lang( 'Bayern Munich [en]' )
  end

  def test_year
    assert_equal 'FC Linz', strip_year( 'FC Linz (1946-2001, 2013-)' )
  end


  def test_duplicats
    club = SportDb::Import::Club.new
    club.name = "Rapid Wien"

    assert_equal false, club.duplicates?
    duplicates = {}
    assert_equal duplicates,  club.duplicates

    club.alt_names_auto += ['Rapid', 'Rapid Wien', 'SK Rapid Wien']

    pp club

    assert_equal true,              club.duplicates?
    duplicates = {'rapidwien'=>['Rapid Wien','Rapid Wien']}
    pp club.duplicates
    assert_equal duplicates, club.duplicates
  end

end # class TestClubs
