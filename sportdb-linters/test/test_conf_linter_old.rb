# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_conf_linter_old.rb


require 'helper'


class TestConfLinterOld < MiniTest::Test

  ConfLinterOld = SportDb::ConfLinterOld


  def test_conf_parse_at
    headings = ConfLinterOld.parse( <<TXT )
= Österr. Bundesliga 2018/19, Regular Season    ## Grunddurchgang

 1  FC Red Bull Salzburg       22  17   4   1  51:18  +33  55
 2  LASK                       22  13   7   2  40:19  +21  46
 3  SK Sturm Graz              22   7  10   5  26:23   +3  31
 4  Wolfsberger AC             22   7   9   6  32:31   +1  30
 5  FK Austria Wien            22   9   3  10  29:28   +1  30
 6  SKN St. Pölten             22   8   6   8  26:29   -3  30
 7  SV Mattersburg             22   8   5   9  28:36   -8  29
 8  SK Rapid Wien              22   7   6   9  26:29   -3  27
 9  TSV Hartberg               22   7   5  10  35:45  -10  26
10  FC Admira Wacker Mödling   22   5   6  11  26:42  -16  21
11  SCR Altach                 22   4   6  12  30:32   -2  18
12  FC Wacker Innsbruck        22   4   5  13  17:34  -17  17

= Österr. Bundesliga 2018/19, Championship Round    ## Meistergruppe

 1  FC Red Bull Salzburg       32  25   5   2  79:27  +52  52
 2  LASK                       32  18   9   5  59:31  +28  40
 3  Wolfsberger AC             32  12  10  10  47:47   ±0  31
 4  FK Austria Wien            32  12   6  14  45:48   -3  27
 5  SK Sturm Graz              32  10  10  12  37:40   -3  24
 6  SKN St. Pölten             32   9   9  14  32:50  -18  21

= Österr. Bundesliga 2018/19, Relegation Round   ## Qualifikationsgruppe

 7  SK Rapid Wien              32  13   7  12  48:44   +4  32
 8  SV Mattersburg             32  12   7  13  41:48   -7  28
 9  SCR Altach                 32   9  10  13  48:44   +4  28
10  FC Admira Wacker Mödling   32   8   9  15  42:62  -20  22
11  TSV Hartberg               32  10   5  17  48:66  -18  22
12  FC Wacker Innsbruck        32   8   5  19  32:51  -19  20
TXT

    pp headings

   heading = headings[0]
   recs    = heading[1]

   assert_equal 3, headings.size
   assert_equal 'Österr. Bundesliga 2018/19, Regular Season', heading[0]
   assert_equal 12, recs.size
   assert_equal Hash( rank: '1',
                      name: 'FC Red Bull Salzburg',
                      standing: '22  17   4   1  51:18  +33  55' ), recs[0]
   assert_equal Hash( rank: '2',
                      name: 'LASK',
                      standing: '22  13   7   2  40:19  +21  46' ), recs[1]
  end
end # class TestConfLinterOld
