# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_conf_ii.rb


require 'helper'


class TestConfII < MiniTest::Test


  def test_at_reg
    txt= <<TXT
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
TXT

  clubs = parse_conf( txt )

  assert_equal Hash(
    'FC Red Bull Salzburg'=> {:count=>1, :rank=>'1',
     :standing=> {:pld=>'22', :w=>'17', :d=>'4', :l=>'1', :gf=>'51', :ga=>'18', :gd=>'+33', :pts=>'55'}},
    'LASK'=> {:count=>1, :rank=>'2',
     :standing=> {:pld=>'22', :w=>'13', :d=>'7', :l=>'2', :gf=>'40', :ga=>'19', :gd=>'+21', :pts=>'46'}},
   'SK Sturm Graz'=>
    {:count=>1,
     :rank=>'3',
     :standing=>
      {:pld=>'22',
       :w=>'7',
       :d=>'10',
       :l=>'5',
       :gf=>'26',
       :ga=>'23',
       :gd=>'+3',
       :pts=>'31'}},
   'Wolfsberger AC'=>
    {:count=>1,
     :rank=>'4',
     :standing=>
      {:pld=>'22',
       :w=>'7',
       :d=>'9',
       :l=>'6',
       :gf=>'32',
       :ga=>'31',
       :gd=>'+1',
       :pts=>'30'}},
   'FK Austria Wien'=>
    {:count=>1,
     :rank=>'5',
     :standing=>
      {:pld=>'22',
       :w=>'9',
       :d=>'3',
       :l=>'10',
       :gf=>'29',
       :ga=>'28',
       :gd=>'+1',
       :pts=>'30'}},
   'SKN St. Pölten'=>
    {:count=>1,
     :rank=>'6',
     :standing=>
      {:pld=>'22',
       :w=>'8',
       :d=>'6',
       :l=>'8',
       :gf=>'26',
       :ga=>'29',
       :gd=>'-3',
       :pts=>'30'}},
   'SV Mattersburg'=>
    {:count=>1,
     :rank=>'7',
     :standing=>
      {:pld=>'22',
       :w=>'8',
       :d=>'5',
       :l=>'9',
       :gf=>'28',
       :ga=>'36',
       :gd=>'-8',
       :pts=>'29'}},
   'SK Rapid Wien'=>
    {:count=>1,
     :rank=>'8',
     :standing=>
      {:pld=>'22',
       :w=>'7',
       :d=>'6',
       :l=>'9',
       :gf=>'26',
       :ga=>'29',
       :gd=>'-3',
       :pts=>'27'}},
   'TSV Hartberg'=>
    {:count=>1,
     :rank=>'9',
     :standing=>
      {:pld=>'22',
       :w=>'7',
       :d=>'5',
       :l=>'10',
       :gf=>'35',
       :ga=>'45',
       :gd=>'-10',
       :pts=>'26'}},
   'FC Admira Wacker Mödling'=>
    {:count=>1,
     :rank=>'10',
     :standing=>
      {:pld=>'22',
       :w=>'5',
       :d=>'6',
       :l=>'11',
       :gf=>'26',
       :ga=>'42',
       :gd=>'-16',
       :pts=>'21'}},
   'SCR Altach'=>
    {:count=>1,
     :rank=>'11',
     :standing=>
      {:pld=>'22',
       :w=>'4',
       :d=>'6',
       :l=>'12',
       :gf=>'30',
       :ga=>'32',
       :gd=>'-2',
       :pts=>'18'}},
   'FC Wacker Innsbruck'=>
    {:count=>1,
     :rank=>'12',
     :standing=>
      {:pld=>'22',
       :w=>'4',
       :d=>'5',
       :l=>'13',
       :gf=>'17',
       :ga=>'34',
       :gd=>'-17',
       :pts=>'17'}}), clubs
  end

  def test_at_champs
    txt= <<TXT
1  FC Red Bull Salzburg       32  25   5   2  79:27  +52  52
2  LASK                       32  18   9   5  59:31  +28  40
3  Wolfsberger AC             32  12  10  10  47:47   ±0  31
4  FK Austria Wien            32  12   6  14  45:48   -3  27
5  SK Sturm Graz              32  10  10  12  37:40   -3  24
6  SKN St. Pölten             32   9   9  14  32:50  -18  21
TXT

    clubs = parse_conf( txt )

    assert_equal Hash(
      'FC Red Bull Salzburg'=> {:count=>1, :rank=>'1',
       :standing=> {:pld=>'32', :w=>'25', :d=>'5', :l=>'2', :gf=>'79', :ga=>'27', :gd=>'+52', :pts=>'52'}},
     'LASK'=> {:count=>1, :rank=>'2',
       :standing=> {:pld=>'32', :w=>'18', :d=>'9', :l=>'5', :gf=>'59', :ga=>'31', :gd=>'+28', :pts=>'40'}},
     'Wolfsberger AC'=>
      {:count=>1,
       :rank=>'3',
       :standing=>
        {:pld=>'32',
         :w=>'12',
         :d=>'10',
         :l=>'10',
         :gf=>'47',
         :ga=>'47',
         :gd=>'±0',
         :pts=>'31'}},
     'FK Austria Wien'=>
      {:count=>1,
       :rank=>'4',
       :standing=>
        {:pld=>'32',
         :w=>'12',
         :d=>'6',
         :l=>'14',
         :gf=>'45',
         :ga=>'48',
         :gd=>'-3',
         :pts=>'27'}},
     'SK Sturm Graz'=>
      {:count=>1,
       :rank=>'5',
       :standing=>
        {:pld=>'32',
         :w=>'10',
         :d=>'10',
         :l=>'12',
         :gf=>'37',
         :ga=>'40',
         :gd=>'-3',
         :pts=>'24'}},
     'SKN St. Pölten'=>
      {:count=>1,
       :rank=>'6',
       :standing=>
        {:pld=>'32',
         :w=>'9',
         :d=>'9',
         :l=>'14',
         :gf=>'32',
         :ga=>'50',
         :gd=>'-18',
         :pts=>'21'}}), clubs

  end
end   # class TestConfII
