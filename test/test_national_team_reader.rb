# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_national_team_reader.rb
#  or better
#     rake -I ./lib test


require 'helper'

class TestNationalTeamReader < MiniTest::Unit::TestCase

  def setup
    WorldDb.delete!
    SportDb.delete!
    SportDb.read_builtin
  end

  def test_br
    br  = Country.create!( key: 'br', title: 'Brazil', code: 'BRA', pop: 1, area: 1)
    bra = Team.create!( key: 'bra', title: 'Brazil', code: 'BRA', country_id: br.id )

    reader = NationalTeamReader.new( SportDb.test_data_path )
    reader.read( 'world-cup/squads/br-brazil', country_id: br.id )

    assert true
  end

  def test_de
    de  = Country.create!( key: 'de', title: 'Germany', code: 'GER', pop: 1, area: 1)
    ger = Team.create!( key: 'ger', title: 'Germany', code: 'GER', country_id: de.id )

    reader = NationalTeamReader.new( SportDb.test_data_path )
    reader.read( 'world-cup/squads/de-deutschland', country_id: de.id )

    assert true
  end


end # class TestNationalTeamReader

