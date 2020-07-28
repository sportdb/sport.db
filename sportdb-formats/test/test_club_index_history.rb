# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_club_index_history.rb


require 'helper'

class TestClubHistoryIndex < MiniTest::Test

  def test_eng
    txt =<<TXT
=  England

##  note: use history log by season (instead of by year) - why? why not?
##
##  note/warn/remember !! a line starting with arrow (=>)
##    will get turned into a heading 1!!!
##    as an ascii-alternative to ⇒   use >> or -> or ??? - why? why not?

== 1930/1
MOVE        South Shields FC, South Shields  ⇒  Gateshead FC, Gateshead


== 1929/30
RENAME     The Wednesday FC, Sheffield   ⇒  Sheffield Wednesday

== 1927/8
RENAME     The Arsenal FC, London   ⇒  Arsenal FC


== 1914/5
RENAME     Woolwich Arsenal FC, London   ⇒  The Arsenal FC


== 1911/2
REFORM     Burslem Port Vale FC, Burslem  ⇒  Port Vale FC, Stoke-on-Trent
  ## the towns of Burslem having been merged in 1910 with the towns of Fenton, Hanley,
  ## Longton, Stoke-upon-Trent and Tunstall as the city of Stoke-on-Trent


== 1909/10
RENAME      Chesterfield Town FC, Chesterfield  ⇒  Chesterfield FC


== 1905/6
RENAME      Chesterfield FC, Chesterfield ⇒ Chesterfield Town FC
            Small Heath FC, Birmingham    ⇒ Birmingham FC

== 1902/3
REFORM      Newton Heath FC, Manchester  ⇒  Manchester United

== 1901/2
MERGE       Burton Swifts FC,    Burton-upon-Trent
            Burton Wanderers FC, Burton-upon-Trent
              ⇒ Burton United FC

BANKRUPT    Newton Heath FC, Manchester


== 1899/00
MERGE      Blackpool FC,   Blackpool
           South Shore FC, Blackpool
             ⇒ Blackpool FC

== 1898/9
RENAME     Glossop North End FC, Glossop  ⇒  Glossop FC


== 1895/6
RENAME      Walsall Town Swifts FC, Walsall  ⇒  Walsall FC


== 1894/5
REFORM      Ardwick FC, Manchester  ⇒  Manchester City FC

== 1893/4
BANKRUPT    Ardwick FC, Manchester

MERGE      Newcastle West End FC, Newcastle-upon-Tyne
           Newcastle East End FC, Newcastle-upon-Tyne
            ⇒ Newcastle United FC

== 1892/3
RENAME     Royal Arsenal FC, London  ⇒  Woolwich Arsenal FC
TXT

    recs = SportDb::Import::ClubHistoryReader.parse( txt )

    history = SportDb::Import::ClubHistoryIndex.new
    history.add( recs )

    pp history.errors
    pp history.mappings

    # [[1927/28, ["RENAME", [["The Arsenal FC, London", "eng"], ["Arsenal FC", "eng"]]]],
    #  [1914/15, ["RENAME", [["Woolwich Arsenal FC, London", "eng"], ["The Arsenal FC", "eng"]]]],
    #  [1892/93, ["RENAME", [["Royal Arsenal FC, London", "eng"], ["Woolwich Arsenal FC", "eng"]]]]],
    assert_equal 'Arsenal FC',          history.find_name_by( name: 'Arsenal FC', season: '2000/1' )
    assert_equal 'Arsenal FC',          history.find_name_by( name: 'Arsenal FC', season: '1927/8' )
    assert_equal 'The Arsenal FC',      history.find_name_by( name: 'Arsenal FC', season: '1926/7' )
    assert_equal 'Woolwich Arsenal FC', history.find_name_by( name: 'Arsenal FC', season: '1913/4' )
    assert_equal 'Royal Arsenal FC',    history.find_name_by( name: 'Arsenal FC', season: '1891/2' )
  end

end # class TestClubHistoryIndex
