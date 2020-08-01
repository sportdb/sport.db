# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_league_reader.rb


require 'helper'

class TestLeagueReader < MiniTest::Test

  def test_parse_eng

    hash = SportDb::Import::LeagueReader.parse( <<TXT )
1  =>  premierleague,   English Premier League
2  =>  championship,    English Championship League
3  =>  league1,         English League 1
4  =>  league2,         English League 2
5  =>  conference,      English Conference

#########################################
# until (including) 2003-04 season

[2003-04]    # or just use 2003-04: or similar - why? why not?
             # or use 2003/04 - 1992/93 - why? why not?

1 => premierleague,   English Premier League
2 => division1,       English Division 1
3 => division2,       English Division 2
4 => division3,       English Division 3


#############################################
# note: in season 1992/93 the premier league starts
#        until (including) 1991-92} season

[1991-92]
1  => division1,   English Division 1
2  => division2,   English Division 2
3  => division3,   English Division 3
3a => division3n,  English Division 3 (North)
3b => division3s,  English Division 3 (South)
4  => division4,   English Division 4      ## check if real?
TXT


   assert_equal 'premierleague', hash['*']['1']
   assert_equal 'championship',  hash['*']['2']
   assert_equal 'league1',       hash['*']['3']

   assert_equal 'division1',     hash['1991-92']['1']
   assert_equal 'division2',     hash['1991-92']['2']
 end  # method test_parse_eng
end # class TestLeagueUtils
