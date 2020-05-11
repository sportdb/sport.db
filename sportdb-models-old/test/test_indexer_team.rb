# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_indexer_team.rb
#  or better
#     rake -I ./lib test


require 'helper'

class TestTeamIndexerXX < MiniTest::Test    ## note: TestTeamIndexer already exists

  def setup
    WorldDb.delete!
    SportDb.delete!
    SportDb.read_builtin
  end

  def test_bl
    at = Country.create!( key: 'at', name: 'Austria', code: 'AUT', pop: 1, area: 1)

    indexer = TestTeamIndexer.from_file( 'at-austria/teams', country_id: at.id )
    h = indexer.read()

    pp h

    ## indexer = TestTeamIndexer.from_file( 'at-austria/teams_2', country_id: at.id )
    ## indexer.read()
 
    assert true  ## assume everthing ok   
  end

end # class TestTeamIndexerXX
