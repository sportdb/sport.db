###
#  to run use
#     ruby test/test_mx.rb


require_relative 'helper'

class TestMx < Minitest::Test


  def test_tokenize

mx =<<TXT
Round 2
[Jul 28]
  Puebla             1-1  Morelia        [Brayan Angulo 8'; Brayan Angulo 45'(og)]
  Atlas              2-1  Pumas          [Jaine Barreiro 12', Gustavo Matías Alustiza 70';
                                          Abraham González 1']
[Jul 29]
  Cruz Azul          1-1  Guadalajara    [Rafael Baca 30'; Rodolfo Pizarro 63']
  Querétaro          0-4  Lobos BUAP     [-; Julián Quiñónes 27', Francisco Javier Rodríguez 58', Juan Carlos Medina 65', 
                                             Diego Rafael Jiménez 94']
TXT


lines = mx.split( "\n" )
pp lines


tokens = []
lines.each do |line|
   tokens <<  tokenize( line )
end

pp tokens

exp = [
  [[:text, "Round 2"]],
  [[:date, "Jul 28"]],
  [[:text, "Puebla"],[:score, "1-1"],[:text, "Morelia"],
   [:text, "Brayan Angulo"],[:minute, "8'"],
   [:";"],
   [:text, "Brayan Angulo"],[:minute, "45'"],[:og, "(og)"]],
  [[:text, "Atlas"],[:score, "2-1"],[:text, "Pumas"],
   [:text, "Jaine Barreiro"],[:minute, "12'"],[:","],
   [:text, "Gustavo Matías Alustiza"],[:minute, "70'"],
   [:";"]],
  [[:text, "Abraham González"], [:minute, "1'"]],
  [[:date, "Jul 29"]],
  [[:text, "Cruz Azul"],
   [:score, "1-1"],
   [:text, "Guadalajara"],
   [:text, "Rafael Baca"],
   [:minute, "30'"],
   [:";"],
   [:text, "Rodolfo Pizarro"],
   [:minute, "63'"]],
  [[:text, "Querétaro"],
   [:score, "0-4"],
   [:text, "Lobos BUAP"],
   [:none, "-"],
   [:";"],
   [:text, "Julián Quiñónes"],[:minute, "27'"],[:","],
   [:text, "Francisco Javier Rodríguez"],[:minute, "58'"],[:","],
   [:text, "Juan Carlos Medina"],[:minute, "65'"],[:","]],
  [[:text, "Diego Rafael Jiménez"], [:minute, "94'"]] 
]

  assert_equal exp, tokens

  end  
end # class TestMx
