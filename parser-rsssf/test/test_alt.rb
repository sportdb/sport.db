###
#  to run use
#     ruby test/test_alt.rb


require_relative 'helper'




class TestAlt < Minitest::Test

  def test_de
    ## goals with score_at
    txt =<<TXT

    [0-1 Zkitischwili 45, 1-1 Löbe 90, 2-1 Cartus 102, 2-2 Mohamad 111]
           
    [1-0 Andrei 08, 1-1 Rydlewicz 24, 1-2 Prica 85, 2-2 Bella 88,
       2-3 Arvidsson 102]

      [0-1 Küntzel 1, 0-2 Buckley 2, 0-3 Buckley 39, 1-3 Schlösser 66,
   2-3 Federico 68, 2-4 Vata 71]

   [1-0 Klimowicz 31, 2-0, 3-0 Brdaric 42, 50]

     [0-1 Neuendorf 86]

     [0-1 Cacau 54, 0-2 Hleb 57]
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
  [[:score_at, "0-1"],[:player, "Zkitischwili"],[:minute, "45"],[:","],
   [:score_at, "1-1"],[:player, "Löbe"],[:minute, "90"],[:","],
   [:score_at, "2-1"],[:player, "Cartus"],[:minute, "102"],[:","],
   [:score_at, "2-2"],[:player, "Mohamad"],[:minute, "111"]],
  [[:score_at, "1-0"],[:player, "Andrei"],[:minute, "08"],[:","],
   [:score_at, "1-1"],[:player, "Rydlewicz"],[:minute, "24"],[:","],
   [:score_at, "1-2"],[:player, "Prica"],[:minute, "85"],[:","],
   [:score_at, "2-2"],[:player, "Bella"],[:minute, "88"],[:","]],
  [[:score_at, "2-3"], [:player, "Arvidsson"], [:minute, "102"]],
  [[:score_at, "0-1"],[:player, "Küntzel"],[:minute, "1"],[:","],
   [:score_at, "0-2"],[:player, "Buckley"],[:minute, "2"],[:","],
   [:score_at, "0-3"],[:player, "Buckley"],[:minute, "39"],[:","],
   [:score_at, "1-3"],[:player, "Schlösser"],[:minute, "66"],[:","]],
  [[:score_at, "2-3"],[:player, "Federico"],[:minute, "68"],[:","],
   [:score_at, "2-4"],[:player, "Vata"],[:minute, "71"]],
  [[:score_at, "1-0"],[:player, "Klimowicz"],[:minute, "31"],[:","],
   [:score_at, "2-0"],[:","],
   [:score_at, "3-0"],[:player, "Brdaric"],[:minute, "42"],[:","],[:minute, "50"]],
  [[:score_at, "0-1"], [:player, "Neuendorf"], [:minute, "86"]],
  [[:score_at, "0-1"],[:player, "Cacau"],[:minute, "54"],[:","],
   [:score_at, "0-2"],[:player, "Hleb"],[:minute, "57"]]]

   assert_equal exp, tree  
  end



  def test_de_ii
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

TSV 1860 3-0 Karlsruher (Küppers 2, 60, Bründl 84)

Karlsruher 1-1 1. FC Köln (C.Müller 87 - Löhr 35)

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
  [[:minute, "32"], [:","], [:minute, "62"]],

  [[:team, "TSV 1860"],[:score, "3-0"],[:team, "Karlsruher"],
   [:player, "Küppers"],[:minute, "2"],[:","],[:minute, "60"],[:","],
   [:player, "Bründl"],[:minute, "84"]],

  [[:team, "Karlsruher"],[:score, "1-1"],[:team, "1. FC Köln"],
   [:player, "C.Müller"],[:minute, "87"],[:-],
   [:player, "Löhr"],[:minute, "35"]],
]  

assert_equal exp, tree
end

end # class TestAlt
