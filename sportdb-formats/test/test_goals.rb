# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_goals.rb


require 'helper'

class TestGoals < MiniTest::Test


  def test_world_cup_1930
     line = "   [L. Laurent 19' Langiller 40' Maschinot 43', 87'; Carreño 70']"

     assert_equal [
       SportDb::GoalStruct.new(
         name:   'L. Laurent',
         minute:  19,
         offset:  0,
         owngoal: false,
         penalty: false,
         score1:  1,
         score2:  0,
         team:    1),
       SportDb::GoalStruct.new(
         name:   'Langiller',
         minute:  40,
         offset:  0,
         owngoal: false,
         penalty: false,
         score1:  2,
         score2:  0,
         team:    1),
      SportDb::GoalStruct.new(
         name:   'Maschinot',
         minute:  43,
         offset:  0,
         owngoal: false,
         penalty: false,
         score1:  3,
         score2:  0,
         team:    1),
      SportDb::GoalStruct.new(
         name:   'Carreño',
         minute:  70,
         offset:  0,
         owngoal: false,
         penalty: false,
         score1:  3,
         score2:  1,
         team:    2),
      SportDb::GoalStruct.new(
         name:   'Maschinot',
         minute:  87,
         offset:  0,
         owngoal: false,
         penalty: false,
         score1:  4,
         score2:  1,
         team:    1)], parse_goals( line )


     line = "     [Monti 81'] "
     assert_equal [
       SportDb::GoalStruct.new(
         name:   'Monti',
         minute:  81,
         offset:  0,
         owngoal: false,
         penalty: false,
         score1:  1,
         score2:  0,
         team:    1)], parse_goals( line )


    line = "     [Vidal 3', 65' M. Rosas 51' (o.g.)]"
    assert_equal [
      SportDb::GoalStruct.new(
        name:   'Vidal',
        minute:  3,
        offset:  0,
        owngoal: false,
        penalty: false,
        score1:  1,
        score2:  0,
        team:    1),
      SportDb::GoalStruct.new(
        name:   'M. Rosas',
        minute:  51,
        offset:  0,
        owngoal: true,
        penalty: false,
        score1:  2,
        score2:  0,
        team:    1),
      SportDb::GoalStruct.new(
        name:   'Vidal',
        minute:  65,
        offset:  0,
        owngoal: false,
        penalty: false,
        score1:  3,
        score2:  0,
        team:    1)], parse_goals( line )
  end

 private
   def parse_goals( line )
     SportDb::GoalsFinder.new.find!( line )
   end

end # class TestGoals
