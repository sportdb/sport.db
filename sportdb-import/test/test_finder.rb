# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_finder.rb


require 'helper'

class TestFinder < MiniTest::Test

  def test_season
    season = SportDb::Importer::Season.find_or_create_builtin( '2017-18' )
    assert_equal '2017/18', season.title    ## fix: add name alias (rename title to name!!)
    assert_equal '2017/18', season.key

    season = SportDb::Importer::Season.find_or_create_builtin( '2017/2018' )
    assert_equal '2017/18', season.title    ## fix: add name alias (rename title to name!!)
    assert_equal '2017/18', season.key
  end


  def test_league
    league = SportDb::Importer::League.find_or_create( 'eng',
                                          name:        'English Premiere League',
                                          country_id:  SportDb::Importer::Country.find_or_create_builtin!( 'eng' ).id,
                                          ## club:       true
                                       )
    assert_equal 'English Premiere League', league.title    ## fix: add name alias (rename title to name!!)
    assert_equal 'eng',              league.key
    assert_equal 'eng',              league.country.key
    assert_equal 'England',          league.country.name
    ## assert_equal true,               league.club

    league = SportDb::Importer::League.find!( 'eng' )
    assert_equal 'English Premiere League', league.title    ## fix: add name alias (rename title to name!!)
    assert_equal 'eng',              league.key
    assert_equal 'eng',              league.country.key
    assert_equal 'England',          league.country.name
    ## assert_equal true,               league.club

    ## try 2nd call (just lookup)
    league = SportDb::Importer::League.find_or_create( 'eng', name: 'English Premiere League' )
    assert_equal 'English Premiere League', league.title    ## fix: add name alias (rename title to name!!)
    assert_equal 'eng',              league.key
    assert_equal 'eng',              league.country.key
    assert_equal 'England',          league.country.name
    ## assert_equal true,               league.club
  end
end # class TestFinder
