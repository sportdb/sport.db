###
#  to run use
#     ruby test/test_outline_reader.rb


require_relative  'helper'

class TestOutlineReader < Minitest::Test

  SAMPLE1 =<<TXT
=============================
= ÖFB Cup 2011/12
=============================

FC Red Bull Salzburg      ## Bundesliga
FK Austria Wien
TXT

=begin
[[:h1, "ÖFB Cup 2011/12"], 
 [:p, ["FC Red Bull Salzburg", "FK Austria Wien"]]]
=end

  SAMPLE2 =<<TXT
= Österr. Bundesliga 2023/24

Matchday 1
[Fri Jul/28]
  20.30  LASK                     1-1 (0-1)  Rapid Wien
[Sat Jul/29]
  17.00  TSV Hartberg             2-2 (1-0)  Austria Lustenau
         WSG Tirol                1-3 (0-1)  SK Austria Klagenfurt
  19.30  SCR Altach               0-2 (0-1)  RB Salzburg
  17.00  Wolfsberger AC           2-1 (1-0)  FC Blau Weiß Linz
[Sun Jul/30]
  17.00  Austria Wien             0-3 (0-2)  Sturm Graz


Matchday 2
[Sat Aug/5]
  17.00  Rapid Wien               4-0 (2-0)  SCR Altach
  19.30  Sturm Graz               2-0 (1-0)  LASK
[Sun Aug/6]
  17.00  RB Salzburg              3-0 (0-0)  WSG Tirol
         FC Blau Weiß Linz        3-3 (1-2)  TSV Hartberg
         Austria Lustenau         0-2 (0-1)  Austria Wien
[Wed Aug/9]
  20.30  SK Austria Klagenfurt    2-2 (1-0)  Wolfsberger AC

...

== Playoffs - Championship

Matchday 23
[Fri Mar/15]
  19.30  Rapid Wien               0-0  LASK
[Sun Mar/17]
  17.00  RB Salzburg              5-1 (2-0)  TSV Hartberg
  14.30  SK Austria Klagenfurt    0-4 (0-4)  Sturm Graz

...

== Playoffs - Relegation

Matchday 23
[Sat Mar/16]
  17.00  WSG Tirol                1-1 (0-0)  Wolfsberger AC
         SCR Altach               1-1 (0-1)  Austria Wien
         FC Blau Weiß Linz        0-0  Austria Lustenau

... 

== Europa League Finals

Semifinals
[Tue May/21]
  19.00  Wolfsberger AC           1-2 (0-1)  Austria Wien


Final
[Fri May/24]
  19.30  Austria Wien             2-1 (0-0)  TSV Hartberg
[Tue May/28]
  19.00  TSV Hartberg             0-1 (0-1)  Austria Wien
TXT

=begin
[[:h1, "Österr. Bundesliga 2023/24"],
 [:p, ["Matchday 1",
       "[Fri Jul/28]",
       "20.30  LASK                     1-1 (0-1)  Rapid Wien",
       "[Sat Jul/29]",
       "17.00  TSV Hartberg             2-2 (1-0)  Austria Lustenau",
       "WSG Tirol                1-3 (0-1)  SK Austria Klagenfurt",
       "19.30  SCR Altach               0-2 (0-1)  RB Salzburg",
       "17.00  Wolfsberger AC           2-1 (1-0)  FC Blau Weiß Linz",
       "[Sun Jul/30]",
       "17.00  Austria Wien             0-3 (0-2)  Sturm Graz"]],
 [:p, ["Matchday 2",
       "[Sat Aug/5]",
       "17.00  Rapid Wien               4-0 (2-0)  SCR Altach",
       "19.30  Sturm Graz               2-0 (1-0)  LASK",
       "[Sun Aug/6]",
       "17.00  RB Salzburg              3-0 (0-0)  WSG Tirol",
       "FC Blau Weiß Linz        3-3 (1-2)  TSV Hartberg",
       "Austria Lustenau         0-2 (0-1)  Austria Wien",
       "[Wed Aug/9]",
       "20.30  SK Austria Klagenfurt    2-2 (1-0)  Wolfsberger AC"]],
 [:p, ["..."]],
 [:h2, "Playoffs - Championship"],
 [:p, ["Matchday 23",
       "[Fri Mar/15]",
       "19.30  Rapid Wien               0-0  LASK",
       "[Sun Mar/17]",
       "17.00  RB Salzburg              5-1 (2-0)  TSV Hartberg",
       "14.30  SK Austria Klagenfurt    0-4 (0-4)  Sturm Graz"]],
 [:p, ["..."]],
 [:h2, "Playoffs - Relegation"],
 [:p, ["Matchday 23",
       "[Sat Mar/16]",
       "17.00  WSG Tirol                1-1 (0-0)  Wolfsberger AC",
       "SCR Altach               1-1 (0-1)  Austria Wien",
       "FC Blau Weiß Linz        0-0  Austria Lustenau"]],
 [:p, ["..."]],
 [:h2, "Europa League Finals"],
 [:p, ["Semifinals", 
       "[Tue May/21]", 
       "19.00  Wolfsberger AC           1-2 (0-1)  Austria Wien"]],
 [:p, ["Final",
       "[Fri May/24]",
       "19.30  Austria Wien             2-1 (0-0)  TSV Hartberg",
       "[Tue May/28]",
       "19.00  TSV Hartberg             0-1 (0-1)  Austria Wien"]]]
=end

  SAMPLES = [SAMPLE1, 
             SAMPLE2]

  def test_parse
    outline = SportDb::OutlineReader.parse( SAMPLE1 )
    pp outline

    assert_equal 2, outline.size

    assert_equal [:h1, 'ÖFB Cup 2011/12'],       outline[0]
    assert_equal [:p,  ['FC Red Bull Salzburg',
                        'FK Austria Wien']],     outline[1]
  end

  def test_parse_more
    outline = SportDb::OutlineReader.parse( SAMPLE2 )
    pp outline
  end


  def test_doc
     SAMPLES.each do |sample|
       outline = SportDb::Outline.parse( sample )
     
       outline.each_para do |lines|
          puts "lines:"
          pp lines
       end

       puts "---"
       outline.each_para_text do |text|
          puts "text:"
          pp text
       end
     end
  end

end # class TestOutlineReader
