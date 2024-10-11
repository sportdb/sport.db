###
#  to run use
#     ruby -I ./lib -I ./test test/test_score.rb


require 'helper'

class TestScore < Minitest::Test

  def test_split
    assert_equal [], Score.split( '' )
    assert_equal [], Score.split( '-' )
    assert_equal [], Score.split( '-:-' )
    assert_equal [], Score.split( '?' )

    assert_equal [0,1], Score.split( '0-1' )
    assert_equal [0,1], Score.split( ' 0 - 1 ' )
    assert_equal [0,1], Score.split( '0:1' )
    assert_equal [0,1], Score.split( ' 0 : 1 ' )
    assert_equal [0,1], Score.split( '0x1' )
    assert_equal [0,1], Score.split( '0X1' )

    assert_equal [10,11], Score.split( '10 - 11' )
    assert_equal [10,11], Score.split( '10 : 11' )
  end

  def test_to_h
    assert_equal  Hash( ft: [1,0] ), Score.parse( '1-0' ).to_h
    assert_equal  Hash( ht: [1,0],
                        ft: [3,2] ), Score.parse( '3-2 (1-0)' ).to_h
  end


  def test_new_et_al
    score = Score.new
    assert_equal [],        score.to_a
    assert_equal [],        score.values
    assert_equal [nil,nil], score.ft
    assert_equal [nil,nil], score.ht
    assert_equal Hash({}),  score.to_h    ## e.g. {} - empty hash
    assert_equal Hash( score1i:  nil, score2i:  nil,
                       score1:   nil, score2:   nil,
                       score1et: nil, score2et: nil,
                       score1p:  nil, score2p:  nil ), score.to_h( :db )


    [
     Score.new( 0, 1 ),
     Score.new( nil, nil, 0, 1 ),
    ].each do |score|
      assert_equal [0,1],           score.to_a
      assert_equal [nil,nil,0,1],   score.values
      assert_equal [nil,nil],       score.ht
      assert_equal [0,1],           score.ft
      assert_equal Hash(ft: [0,1]), score.to_h
      assert_equal Hash( score1i:  nil, score2i:  nil,
                         score1:   0,   score2:   1,
                         score1et: nil, score2et: nil,
                         score1p:  nil, score2p:  nil ), score.to_h( :db )
    end


    score = Score.new( 0, 1, 2, 3 )
    assert_equal [[0,1],[2,3]],   score.to_a
    assert_equal [0,1,2,3],       score.values
    assert_equal [0,1],           score.ht
    assert_equal [2,3],           score.ft
    assert_equal Hash(ht: [0,1],
                      ft: [2,3]), score.to_h
    assert_equal Hash( score1i:  0,   score2i: 1,
                       score1:   2,   score2:  3,
                       score1et: nil, score2et: nil,
                       score1p:  nil, score2p:  nil ), score.to_h( :db )
  end

end