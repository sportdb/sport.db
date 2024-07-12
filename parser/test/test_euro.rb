###
#  to run use
#     ruby test/test_euro.rb


require_relative 'helper'

class TestEuro < Minitest::Test

def test_tokenize

euro =<<TXT
Group A  |  Germany   Scotland     Hungary   Switzerland
Group B  |  Spain     Croatia      Italy     Albania
Group C  |  Slovenia  Denmark      Serbia    England
Group D  |  Poland    Netherlands  Austria   France
Group E  |  Belgium   Slovakia     Romania   Ukraine 
Group F  |  Turkey    Georgia      Portugal  Czech Republic


Group A:

 (1) Fri Jun/14 21:00         Germany   5-1 (3-0)  Scotland     @ München Fußball Arena, München
        [Wirtz 10' Musiala 19' Havertz 45+1' (pen.) Füllkrug 68' Can 90+3'; Rüdiger 87' (o.g.)]

 (2) Sat Jun/15 15:00         Hungary   1-3 (0-2)   Switzerland  @ Köln Stadion, Köln
           [Varga 66'; Duah 12' Aebischer 45' Embolo 90+3']



TXT

lines = euro.split( "\n" )
pp lines

tokens = []
lines.each_with_index do |line,i|
  puts
  puts "line #{i+1}/#{lines.size}  >#{line}<"
  next if line.strip.empty?
  t = tokenize( line )
  pp t
  tokens << t
end

pp tokens

exp =  [
[[:text, "Group A"], [:|], [:text, "Germany"], [:text, "Scotland"], [:text, "Hungary"], [:text, "Switzerland"]],
[[:text, "Group B"], [:|], [:text, "Spain"], [:text, "Croatia"], [:text, "Italy"], [:text, "Albania"]],
[[:text, "Group C"], [:|], [:text, "Slovenia"], [:text, "Denmark"], [:text, "Serbia"], [:text, "England"]],
[[:text, "Group D"], [:|], [:text, "Poland"], [:text, "Netherlands"], [:text, "Austria"], [:text, "France"]],
[[:text, "Group E"], [:|], [:text, "Belgium"], [:text, "Slovakia"], [:text, "Romania"], [:text, "Ukraine"]],
[[:text, "Group F"], [:|], [:text, "Turkey"], [:text, "Georgia"], [:text, "Portugal"], [:text, "Czech Republic"]],
[[:text, "Group"]],
[[:num, "(1)"],
 [:date, "Fri Jun/14"],
 [:time, "21:00"],
 [:text, "Germany"],[:score, "5-1 (3-0)"],[:text, "Scotland"],
 [:"@"],
 [:text, "München Fußball Arena"],[:","],[:text, "München"]],
[[:text, "Wirtz"],[:minute, "10'"],
 [:text, "Musiala"],[:minute, "19'"],
 [:text, "Havertz"],[:minute, "45+1'"],[:pen, "(pen.)"],
 [:text, "Füllkrug"],[:minute, "68'"],
 [:text, "Can"],[:minute, "90+3'"],
 [:";"],
 [:text, "Rüdiger"],[:minute, "87'"],[:og, "(o.g.)"]],
[[:num, "(2)"],
 [:date, "Sat Jun/15"],
 [:time, "15:00"],
 [:text, "Hungary"],[:score, "1-3 (0-2)"],[:text, "Switzerland"],
 [:"@"],
 [:text, "Köln Stadion"],[:","],[:text, "Köln"]],
[[:text, "Varga"],[:minute, "66'"],
 [:";"],
 [:text, "Duah"],[:minute, "12'"],
 [:text, "Aebischer"],[:minute, "45'"],
 [:text, "Embolo"],[:minute, "90+3'"]]]

  assert_equal exp, tokens
end
end # class TestEuro