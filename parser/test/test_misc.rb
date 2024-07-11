###
#  to run use
#     ruby test/test_misc.rb


require_relative 'helper'

class TestMisc < Minitest::Test


  def test_tokenize

lines = {
 "1. FC Köln - Schalke 04     " =>
 [[:text, "1. FC Köln"], [:vs, "-"], [:text, "Schalke 04"]],

 "Brighton & Hove Albion F.C. vs Arsenal F.C.   " =>
 [[:text, "Brighton & Hove Albion F.C."], [:vs, "vs"], [:text, "Arsenal F.C."]],

 ##  make -1 possible  (e.g. check ukraine dnipro-1)
 "SC Dnipro-1     27+4' 12'  " =>
 [[:text, "SC Dnipro-1"], [:minute, "27+4'"], [:minute, "12'"]],

 "1 FC   " =>             [[:text, "1 FC"]],
 "1. FC   " =>            [[:text, "1. FC"]],
 "1860 Munich      " =>   [[:text, "1860 Munich"]],
"1860 München v München 1860 vs TSV 1860 München    Fri Jun 12 2012 " =>
[[:text, "1860 München"], [:vs, "v"],
 [:text, "München 1860"], [:vs, "vs"],
 [:text, "TSV 1860 München"],
 [:date, "Fri Jun 12 2012"]],

 "America - RS  " =>
 [[:text, "America"], [:vs, "-"], [:text, "RS"]],
 "Team 4-3  " =>
 [[:text, "Team"], [:score, "4-3"]],

 ## note - separate date by two spaces from team!
 "Team Fri Jun 12 2012   " =>
 [[:text, "Team Fri Jun 12 2012"]],
 "Team, Fri Jun 12 2012   " =>
 [[:text, "Team"], [:","], [:date, "Fri Jun 12 2012"]],
  "Team [Fri Jun 12 2012]   " =>
  [[:text, "Team"], [:date, "Fri Jun 12 2012"]],
  "[Fri Jun 12 2012] Team   " =>
  [[:date, "Fri Jun 12 2012"], [:text, "Team"]],
  "Fri Jun 12 2012 Team   " =>
  [[:date, "Fri Jun 12 2012"], [:text, "Team"]],

  "Cote d'Ivoire 12'" =>
  [[:text, "Cote d'Ivoire"], [:minute, "12'"]],

 "1. FC Köln   Köln 2   Fortuna Düsseldorf  -  Rot-Weiss Essen 18:30   11-12    vs   München 1860  3-2  12.30  @ Waldstadion, Frankfurt " =>
   [[:text, "1. FC Köln"],
    [:text, "Köln 2"],
    [:text, "Fortuna Düsseldorf"], [:vs, "-"], [:text, "Rot-Weiss Essen"],
    [:time, "18:30"],
    [:score, "11-12"],
    [:vs, "vs"],
    [:text, "München 1860"],
    [:score, "3-2"],
    [:time, "12.30"],
    [:"@"], [:text, "Waldstadion"], [:","], [:text, "Frankfurt"]],  
 " 18.30   21:30  Brighton & Hove Albion F.C.  0-0  Arsenal F.C.   3-2 (1-0)" =>
  [[:time, "18.30"],
   [:time, "21:30"],
   [:text, "Brighton & Hove Albion F.C."],
   [:score, "0-0"],
   [:text, "Arsenal F.C."],
   [:score, "3-2 (1-0)"]],

   "  [-; Kane 21]" => 
  [[:none, "-"], [:";"], [:text, "Kane 21"]],
  "- ; Kane 21' 27+4'" =>
  [[:none, "-"], [:";"], 
   [:text, "Kane"], [:minute, "21'"], [:minute, "27+4'"]],
  " $$$$   !!!   §§§  " =>
    [],
}

lines.each do |line,exp|
  puts "==> >#{line}<"
  tokens = tokenize( line )
  pp tokens
  assert_equal exp, tokens
end



end  # test_tokenize
end   # class TestMisc

