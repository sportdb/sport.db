###
#  to run use
#     ruby test/test_text.rb


require_relative 'helper'




class TestText < Minitest::Test

def test_text

 lines = {
    ## check round names starting with numbers
   ' 1st leg   '             =>  '1st leg',
   ' 2nd leg   '             =>  '2nd leg',
   '  5th place play-off  '  =>  '5th place play-off',
   '  3rd place final  '     =>  '3rd place final',

   ## check clubs starting with numbers
   '   1. FC Köln  '      =>  '1. FC Köln',
   '   1. FC Köln 2  '      =>  '1. FC Köln 2',
   ## try edge case with score (1-1) or hour (18:30)
   '   1. FC Köln 1-1 '   =>  '1. FC Köln',
   '   1. FC Köln 18:30 '   =>  '1. FC Köln',
   '   1. FC Köln 18.30 '   =>  '1. FC Köln',
   '   1. FC Köln 18h30 '   =>  '1. FC Köln',
   '   1. FC Köln v '    =>  '1. FC Köln',
   '   1. FC Köln v. '   =>  '1. FC Köln',
   '   1. FC Köln vs '   =>  '1. FC Köln',
   '   1. FC Köln vs. '   =>  '1. FC Köln',
   '   1. FC Köln - '   =>  '1. FC Köln',
   ## variants with trailing (A) or (YYYY-YYYY)
   
   #########
   ##   todo/fix/check - remove (A) - keep only (U21), (U7) etc. ??
   ##      keep (A) reserved for single letter country codes - why? why not?
   ##         e.g. (D), (F), (E), (I) etc.
   ##     - (A) only seen for now for Austria Wien (A) ??
   ##             change to  Austria Wien A. or such (w/ mod) - why? why not?
   ##     most b teams use 2 or II or Reserve or ???
   ##              no need for special case (A)!!!!!

   '   1. FC Köln (A)  '           =>  '1. FC Köln (A)',
   '   1. FC Köln (U21)  '           =>  '1. FC Köln (U21)',
   '   1. FC Köln (1910-2020)  '   =>  '1. FC Köln (1910-2020)',
   ##  edge case with both 
   '   1. FC Köln (A) (1910-2020)  '   =>  '1. FC Köln (A) (1910-2020)',

   '    Schalke 04   '     =>  'Schalke 04',
   ## try edge case with hour (18:30)
   '    Schalke 04 0:4  '  =>  'Schalke 04',
   '    Schalke 04 0-4  '  =>  'Schalke 04',
   '    Schalke 04 00:04  '  =>  'Schalke 04',
   '    Schalke 04 18:30  '  =>  'Schalke 04',
   ## try -1 edge case
   '  SC Dnipro-1  '     =>  'SC Dnipro-1',
   '  SC Dnipro-1 1-1'   =>  'SC Dnipro-1',
 }


  lines.each do |line,exp|
    m = TEXT_RE.match( line )
    pp m
    pp m[:text]
    pp m.named_captures

    assert_equal exp, m[:text]
  end
end

end # class TestText

  