# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_models.rb
#  or better
#     rake -I ./lib test


require 'helper'

class TestModels < MiniTest::Unit::TestCase

  def setup
    WorldDb.delete!
    SportDb.delete!
    FootballDb.delete!
    PersonDb.delete!
  end

  def test_stats
    assert_equal 0, Person.count
    assert_equal 0, PlayerStat.count

    ## now add some persons
    p1 = Person.create!( key: 'seanjohnson',    name: 'Sean Johnson' )
    p2 = Person.create!( key: 'gregcochrane',   name: 'Greg Cochrane' )
    p3 = Person.create!( key: 'quincyamarikwa', name: 'Quincy Amarikwa' )

    assert_equal 3, Person.count
    assert_equal 0, Person.first.stats.count    ## check stats assoc

    PlayerStat.create!( person_id: p1.id,
                        starts: 11,
                        sub_ins: 12,
                        sub_outs: 13 )
 
    assert_equal 1, PlayerStat.count
    assert_equal 1, p1.stats.count    ## check stats assoc
    
    assert_equal 11, p1.stats.first.starts
    assert_equal 12, p1.stats.first.sub_ins
    assert_equal 13, p1.stats.first.sub_outs

    PlayerStat.create!( person_id: p2.id,
                        starts: 14,
                        sub_ins: 15,
                        sub_outs: 16 )

    assert_equal 2, PlayerStat.count
    assert_equal 1, p2.stats.count    ## check stats assoc

    assert_equal 14, p2.stats.first.starts
    assert_equal 15, p2.stats.first.sub_ins
    assert_equal 16, p2.stats.first.sub_outs

    assert_equal 0, p3.stats.count    ## check stats assoc
  end

end # class TestModels

