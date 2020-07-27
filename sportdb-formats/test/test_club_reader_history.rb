# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_club_reader_history.rb


require 'helper'


class TestClubHistoryReader < MiniTest::Test

  def test_parse_eng
    txt =<<TXT
=  England

##  note: use history log by season (instead of by year) - why? why not?
##
##  note/warn/remember !! a line starting with arrow (=>)
##    will get turned into a heading 1!!!
##    as an ascii-alternative to ⇒   use >> or -> or ??? - why? why not?



== 1958/9
RENAME      Scunthorpe & Lindsey United FC, Scunthorpe  ⇒  Scunthorpe United FC

== 1946/7
RENAME      Clapton Orient FC, London  ⇒  Leyton Orient FC

== 1945/6
RENAME      Birmingham FC, Birmingham  ⇒  Birmingham City FC

== 1930/1
MOVE        South Shields FC, South Shields  ⇒  Gateshead FC, Gateshead



== 1929/30
RENAME     The Wednesday FC, Sheffield   ⇒  Sheffield Wednesday

== 1927/8
RENAME     The Arsenal FC, London   ⇒  Arsenal FC

== 1925/6
RENAME      Millwall Athletic FC, London   ⇒  Millwall FC
            Stoke FC, Stoke-on-Trent       ⇒  Stoke City FC

MERGE       Rotherham County FC, Rotherham
            Rotherham Town FC,   Rotherham
              ⇒ Rotherham United FC

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
RENAME     Barnsley St. Peter's FC, Barnsley  ⇒  Barnsley FC

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

    pp recs

    exp = [["RENAME", "1958/59",
             ["Scunthorpe & Lindsey United FC, Scunthorpe", "eng"],
             ["Scunthorpe United FC", "eng"]],
          ["RENAME", "1946/47",
            ["Clapton Orient FC, London", "eng"],
            ["Leyton Orient FC", "eng"]],
         ["RENAME", "1945/46",
            ["Birmingham FC, Birmingham", "eng"],
            ["Birmingham City FC", "eng"]],
         ["MOVE", "1930/31",
            ["South Shields FC, South Shields", "eng"],
            ["Gateshead FC, Gateshead", "eng"]],
   ["RENAME",
    "1929/30",
    ["The Wednesday FC, Sheffield", "eng"],
    ["Sheffield Wednesday", "eng"]],
   ["RENAME",
    "1927/28",
    ["The Arsenal FC, London", "eng"],
    ["Arsenal FC", "eng"]],
   ["RENAME",
    "1925/26",
    ["Millwall Athletic FC, London", "eng"],
    ["Millwall FC", "eng"]],
   ["RENAME",
    "1925/26",
    ["Stoke FC, Stoke-on-Trent", "eng"],
    ["Stoke City FC", "eng"]],
   ["MERGE",
    "1925/26",
    [["Rotherham County FC, Rotherham", "eng"],
     ["Rotherham Town FC, Rotherham", "eng"]],
    ["Rotherham United FC", "eng"]],
   ["RENAME",
    "1914/15",
    ["Woolwich Arsenal FC, London", "eng"],
    ["The Arsenal FC", "eng"]],
   ["REFORM",
    "1911/12",
    ["Burslem Port Vale FC, Burslem", "eng"],
    ["Port Vale FC, Stoke-on-Trent", "eng"]],
   ["RENAME",
    "1909/10",
    ["Chesterfield Town FC, Chesterfield", "eng"],
    ["Chesterfield FC", "eng"]],
   ["RENAME",
    "1905/06",
    ["Chesterfield FC, Chesterfield", "eng"],
    ["Chesterfield Town FC", "eng"]],
   ["RENAME",
    "1905/06",
    ["Small Heath FC, Birmingham", "eng"],
    ["Birmingham FC", "eng"]],
   ["REFORM",
    "1902/03",
    ["Newton Heath FC, Manchester", "eng"],
    ["Manchester United", "eng"]],
   ["MERGE",
    "1901/02",
    [["Burton Swifts FC, Burton-upon-Trent", "eng"],
     ["Burton Wanderers FC, Burton-upon-Trent", "eng"]],
    ["Burton United FC", "eng"]],
   ["BANKRUPT", "1901/02", ["Newton Heath FC, Manchester", "eng"]],
   ["RENAME",
    "1899/00",
    ["Barnsley St. Peter's FC, Barnsley", "eng"],
    ["Barnsley FC", "eng"]],
   ["MERGE",
    "1899/00",
    [["Blackpool FC, Blackpool", "eng"], ["South Shore FC, Blackpool", "eng"]],
    ["Blackpool FC", "eng"]],
   ["RENAME",
    "1898/99",
    ["Glossop North End FC, Glossop", "eng"],
    ["Glossop FC", "eng"]],
   ["RENAME",
    "1895/96",
    ["Walsall Town Swifts FC, Walsall", "eng"],
    ["Walsall FC", "eng"]],
   ["REFORM",
    "1894/95",
    ["Ardwick FC, Manchester", "eng"],
    ["Manchester City FC", "eng"]],
   ["BANKRUPT", "1893/94", ["Ardwick FC, Manchester", "eng"]],
   ["MERGE",
    "1893/94",
    [["Newcastle West End FC, Newcastle-upon-Tyne", "eng"],
     ["Newcastle East End FC, Newcastle-upon-Tyne", "eng"]],
    ["Newcastle United FC", "eng"]],
   ["RENAME",
    "1892/93",
    ["Royal Arsenal FC, London", "eng"],
    ["Woolwich Arsenal FC", "eng"]]]

  assert_equal exp, recs
  end

end # class TestClubHistoryReader
