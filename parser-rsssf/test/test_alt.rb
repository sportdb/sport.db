###
#  to run use
#     ruby test/test_alt.rb


require_relative 'helper'




class TestAlt < Minitest::Test

  def test_de
    txt =<<TXT

K'lautern 2-4 S'brücken (Reitgaßl 2, Neumann 56 - Schönwälder 17, 57,
                            Krafczyk 38, Gawletta 82 o)

Münster 4-2 Hertha (Pohlschmidt 6, 75, Lulka 40, Eder 70 o -
                            Faeder 24, Steinert 27)

Hamburger 2-1 Hannover (B.Dörfel 39, U.Seeler 42 - Gräber 10)

Bayern 4-3 M'gladbach (Olk 15, Brenninger 39, G.Müller 63, 68 - Heynckes
                          31, Wimmer 41, Laumen 47)

1. FC Köln 2-4 Bayern (Magnusson 19, Pott 68 - G.Müller 3, 89, Ohlhauser
                          32, 62)


TXT
    
lines = txt.split( "\n" )
pp lines


tree = []
lines.each do |line|
   ## skip blank and comment lines
   next if line.strip.empty? || line.strip.start_with?('#')

   tree <<  parse( line )
end

pp tree

exp = [
  [[:team, "K'lautern"],[:score, "2-4"],[:team, "S'brücken"],
   [:player, "Reitgaßl"],[:minute, "2"],[:","],
   [:player, "Neumann"],[:minute, "56"],[:-],
   [:player, "Schönwälder"],[:minute, "17"],[:","],[:minute, "57"],[:","]],
  [[:player, "Krafczyk"], [:minute, "38"], [:","], 
   [:player, "Gawletta"], [:minute, "82"], [:og, "o"]],
 
  [[:team, "Münster"],[:score, "4-2"],[:team, "Hertha"],
   [:player, "Pohlschmidt"],[:minute, "6"],[:","],[:minute, "75"],[:","],
   [:player, "Lulka"],[:minute, "40"],[:","],
   [:player, "Eder"],[:minute, "70"],[:og, "o"],[:-]],
  [[:player, "Faeder"], [:minute, "24"], [:","], 
   [:player, "Steinert"], [:minute, "27"]],

  [[:team, "Hamburger"],[:score, "2-1"],[:team, "Hannover"],
   [:player, "B.Dörfel"],[:minute, "39"],[:","],
   [:player, "U.Seeler"],[:minute, "42"],[:-],
   [:player, "Gräber"],[:minute, "10"]],

   [[:team, "Bayern"],[:score, "4-3"],[:team, "M'gladbach"],
   [:player, "Olk"],[:minute, "15"],[:","],
   [:player, "Brenninger"],[:minute, "39"],[:","],
   [:player, "G.Müller"],[:minute, "63"],[:","],[:minute, "68"],[:-],
   [:text, "Heynckes"]],   ### note - minute in next line!!! (keep text here (NOT player??)
  [[:minute, "31"], [:","], 
   [:player, "Wimmer"], [:minute, "41"], [:","], 
   [:player, "Laumen"], [:minute, "47"]],
   
  [[:team, "1. FC Köln"],[:score, "2-4"],[:team, "Bayern"],
   [:player, "Magnusson"],[:minute, "19"],[:","],
   [:player, "Pott"],[:minute, "68"],[:-],
   [:player, "G.Müller"],[:minute, "3"],[:","],[:minute, "89"],[:","],
   [:text, "Ohlhauser"]],   ### note - minute in next line!!! (keep text here (NOT player??)
  [[:minute, "32"], [:","], [:minute, "62"]]
]

assert_equal exp, tree
end

end # class TestAlt
