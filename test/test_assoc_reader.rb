# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_assoc_reader.rb
#  or better
#     rake -I ./lib test


require 'helper'

class TestAssocReader < MiniTest::Test

  def setup
    WorldDb.delete!
    SportDb.delete!
    PersonDb.delete!
  end

  def test_models
    assert_equal 0, Assoc.count
    assert_equal 0, Team.count
    assert_equal 0, AssocAssoc.count

    uefa = Assoc.create!( key: 'uefa', title: 'UEFA' )
    assert_equal 1, Assoc.count

    at       = Country.create!( key: 'at', name: 'Austria', code: 'AUT', pop: 1, area: 1)
    assocaut = Assoc.create!( key: 'assocaut', title: 'Assoc Austria',
                              national: true, country_id: at.id )

    aut      = Team.create!( key: 'aut', title: 'Austria', code: 'AUT',
                             country_id: at.id,
                             assoc_id: assocaut.id )

    assert_equal 1, Team.count
    assert_equal 'Assoc Austria', aut.assoc.title   # team.assoc belongs_to ref
    assert_equal 'Assoc Austria', at.assoc.title    # country.assoc has_one ref

    assert_equal 0, AssocAssoc.count

    AssocAssoc.create!( assoc1_id: uefa.id, assoc2_id: assocaut.id )

    assert_equal 1, AssocAssoc.count
    assert_equal 1, uefa.member_assoc_assocs.count
    assert_equal 1, uefa.all_assocs.count
    assert_equal 0, uefa.sub_assocs.count
    assert_equal 1, uefa.national_assocs.count
    assert_equal 0, uefa.parent_assoc_assocs.count
    assert_equal 0, uefa.parent_assocs.count
    assert_equal 1, assocaut.parent_assoc_assocs.count
    assert_equal 1, assocaut.parent_assocs.count
    assert_equal 0, assocaut.member_assoc_assocs.count
    assert_equal 0, assocaut.all_assocs.count


    it       = Country.create!( key: 'it', name: 'Italy', code: 'ITA', pop: 1, area: 1)
    associta = Assoc.create!( key: 'associta', title: 'Assoc Italy',
                              national: true, country_id: it.id )

    ita      = Team.create!( key: 'ita', title: 'Italy', code: 'ITA',
                             country_id: it.id,
                             assoc_id: associta.id )

    assert_equal 2, Team.count
    assert_equal 'Assoc Italy', ita.assoc.title   # team.assoc belongs_to ref
    assert_equal 'Assoc Italy', it.assoc.title    # country.assoc has_one ref

    AssocAssoc.create!( assoc1_id: uefa.id, assoc2_id: associta.id )

    assert_equal 2, AssocAssoc.count
    assert_equal 2, uefa.member_assoc_assocs.count
    assert_equal 2, uefa.national_assocs.count
    assert_equal 0, uefa.sub_assocs.count
    assert_equal 0, uefa.parent_assoc_assocs.count
    assert_equal 1, associta.parent_assoc_assocs.count
    assert_equal 0, associta.member_assoc_assocs.count
  end


  def test_assocs
    reader = AssocReader.new( SportDb.test_data_path )
    reader.read( 'national-teams/assocs' )

    assert_equal 20, Assoc.count

    fifa = Assoc.find_by_key!( 'fifa' )

    assert_equal 'Fédération Internationale de Football Association (FIFA)', fifa.title
    assert_equal 1904, fifa.since
    assert_equal 'www.fifa.com', fifa.web
    assert_equal 0, fifa.parent_assoc_assocs.count
    assert_equal 6, fifa.member_assoc_assocs.count
    assert_equal 6, fifa.all_assocs.count
    assert_equal 6, fifa.sub_assocs.count
    assert_equal 0, fifa.national_assocs.count
    assert_equal 0, fifa.parent_assocs.count

    uefa = Assoc.find_by_key!( 'uefa' )

    assert_equal 'Union of European Football Associations (UEFA)', uefa.title
    assert_equal 1954, uefa.since
    assert_equal 'www.uefa.com', uefa.web
    assert_equal 1, uefa.parent_assoc_assocs.count
    assert_equal 0, uefa.member_assoc_assocs.count
    assert_equal 0, uefa.all_assocs.count
    assert_equal 0, uefa.sub_assocs.count
    assert_equal 0, uefa.national_assocs.count
    assert_equal 1, uefa.parent_assocs.count

    concacaf = Assoc.find_by_key!( 'concacaf' )

    assert_equal 'Confederation of North, Central American and Caribbean Association Football (CONCACAF)', concacaf.title
    assert_equal 1961, concacaf.since
    assert_equal 1, concacaf.parent_assoc_assocs.count
    assert_equal 3, concacaf.member_assoc_assocs.count
    assert_equal 3, concacaf.all_assocs.count
    assert_equal 3, concacaf.sub_assocs.count
    assert_equal 0, concacaf.national_assocs.count
    assert_equal 1, concacaf.parent_assocs.count


    mx = Country.create!( key: 'mx', name: 'Mexico', code: 'MEX', pop: 1, area: 1)
    ca = Country.create!( key: 'ca', name: 'Canada', code: 'CAN', pop: 1, area: 1)
    us = Country.create!( key: 'us', name: 'United States', code: 'USA', pop: 1, area: 1)

    reader.read( 'national-teams/north-america/assocs' )

    assert_equal 23, Assoc.count

    assert_equal 6+3, fifa.all_assocs.count
    assert_equal 6,   fifa.sub_assocs.count
    assert_equal 0+3, fifa.national_assocs.count

    assert_equal 3+3, concacaf.all_assocs.count
    assert_equal 3,   concacaf.sub_assocs.count
    assert_equal 0+3, concacaf.national_assocs.count
    assert_equal 1,   concacaf.parent_assocs.count

    assocusa = Assoc.find_by_key!( 'assocusa' )
    assert_equal 'United States Soccer Federation', assocusa.title
    assert_equal 3, assocusa.parent_assocs.count
    assert_equal 0, assocusa.all_assocs.count
    assert_equal 0, assocusa.sub_assocs.count
    assert_equal 0, assocusa.national_assocs.count

  end  # method test_assocs


  def test_teams
    assocreader = AssocReader.new( SportDb.test_data_path )
    assocreader.read( 'national-teams/assocs' )

    assert_equal 20, Assoc.count
    
    ## add countries
    countries = [['mx', 'Mexico', 'MEX'],
                 ['us', 'United States', 'USA'],
                 ['ca', 'Canada', 'CAN'],
                 ['dz', 'Algeria', 'ALG'],
                 ['eg', 'Egypt', 'EGY'],
                 ['au', 'Australia', 'AUS'],
                 ['nz', 'New Zealand', 'NZL'],
                 ['ki', 'Kiribati', 'KIR'],
                 ['tv', 'Tuvalu',  'TUV']]

    countries.each do |country|
      Country.create!( key:  country[0],
                       name: country[1],
                       code: country[2],
                       pop: 1,
                       area: 1)
    end

    teamreader = TeamReader.new( SportDb.test_data_path )
    teamreader.read( 'national-teams/teams' )
    teamreader.read( 'national-teams/north-america/teams' )

    assert_equal 9, Team.count
    
    ## fifa = Assoc.find_by_key!( 'fifa' )
    ## assert_equal 7, fifa.teams.count

    ## ofc = Assoc.find_by_key!( 'ofc' )
    ## assert_equal 3, ofc.teams.count

    ## mex = Team.find_by_key!( 'mex' )
    ## assert_equal 3, mex.assocs.count

    ## tuv = Team.find_by_key!( 'tuv' )
    ## assert_equal 1, tuv.assocs.count

    ### fix/todo: run teamreader again!! (2nd run)
    ##   assert no new assocs (just update existing)

  end  # method test_teams


end # class TestAssocReader
