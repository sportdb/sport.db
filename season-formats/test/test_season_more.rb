###
#  to run use
#     ruby -I ./lib -I ./test test/test_season_more.rb


require_relative 'helper'

class TestSeasonMote < Minitest::Test

  def test_range
     assert_equal Season('2021')..Season('2024'),       Season.parse_range( '2021..2024' )
     assert_equal Season('2021/22')..Season('2024/25'), Season.parse_range( '2021/22..2024/25' )

     pp Season.parse_range( '2021..2024' )
     pp Season.parse_range( '2021/22..2024/25' )
  end

  def test_line
    assert_equal [Season('2020')], Season.parse_line( '2020' )
    assert_equal [Season('2020')]+(Season('2021/22')..Season('2024/25')).to_a,
                 Season.parse_line( '2020 2021/22..2024/25' )
    
    pp Season.parse_line( '2020 2021/22..2024/25' )

    ## bonus - check sort too
    pp Season.parse_line( '2021/22..2024/25 2030 2025 2024 2020' ).sort
    assert_equal [Season('2020'), Season('2021/22'), Season('2022/23'), 
                  Season('2023/24'), Season('2024'), Season('2024/25'), 
                  Season('2025'), Season('2030')], 
                  Season.parse_line( '2021/22..2024/25 2030 2025 2024 2020' ).sort
  end
end # class TestSeasonMore
