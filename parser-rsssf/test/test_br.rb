###
#  to run use
#     ruby test/test_br.rb


require_relative 'helper'

class TestBr < Minitest::Test

  def test_sample
br =<<TXT

## source
##  - https://rsssf.github.io/

Round 1
[May 25]
Vasco da Gama   1-0 Portuguesa
 [Carlos Tenório 47']
Vitória         2-2 Internacional
 [Maxi Biancucchi 2', Gabriel Paulista 11'; Diego Forlán 29', Fred 63']
Corinthians     1-1 Botafogo
 [Paulinho 73'; Rafael Marques 24']
[May 26]
Grêmio          2-0 Náutico         [played in Caxias do Sul-RS]
 [Zé Roberto 15', Elano 70']
Ponte Preta     0-2 São Paulo
 [Lúcio 9', Jádson 44'p]
Criciúma        3-1 Bahia
 [Matheus Ferraz 45'+1', Lins 46', João Vítor 82'; Diones 72']
Santos          0-0 Flamengo        [played in Brasília-DF]
Fluminense      2-1 Atlético/PR     [played in Macaé-RJ]
 [Rafael Sóbis 15'p, Samuel 53'; Manoel 28']
Cruzeiro        5-0 Goiás
 [Diego Souza 5', Bruno Rodrigo 30', Nílton 40',79', Borges 42']
Coritiba        2-1 Atlético/MG
 [Deivid 53', Arthur 90'+1'; Diego Tardelli 51']
TXT

lines = br.split( "\n" )
pp lines


tree = []
lines.each do |line|
   ## skip blank and comment lines
   next if line.strip.empty? || line.strip.start_with?('#')

   tree <<  parse( line )
end

pp tree


exp = [
[[:round, "Round 1"]],
[[:date, "May 25"]],
[[:team, "Vasco da Gama"], [:score, "1-0"], [:team, "Portuguesa"]],
  [[:player, "Carlos Tenório"], [:minute, "47'"]],
[[:team, "Vitória"], [:score, "2-2"], [:team, "Internacional"]],
  [[:player, "Maxi Biancucchi"],[:minute, "2'"],[:","],
   [:player, "Gabriel Paulista"],[:minute, "11'"],[:";"],
   [:player, "Diego Forlán"],[:minute, "29'"],[:","],
   [:player, "Fred"],[:minute, "63'"]],
[[:team, "Corinthians"], [:score, "1-1"], [:team, "Botafogo"]],
  [[:player, "Paulinho"], [:minute, "73'"], [:";"], 
   [:player, "Rafael Marques"], [:minute, "24'"]],
[[:date, "May 26"]],
[[:team, "Grêmio"], [:score, "2-0"], [:team, "Náutico"], [:note, "played in Caxias do Sul-RS"]],
  [[:player, "Zé Roberto"], [:minute, "15'"], [:","], 
   [:player, "Elano"], [:minute, "70'"]],
[[:team, "Ponte Preta"], [:score, "0-2"], [:team, "São Paulo"]],
  [[:player, "Lúcio"], [:minute, "9'"], [:","], 
   [:player, "Jádson"], [:minute, "44'"], [:pen, "p"]],
[[:team, "Criciúma"], [:score, "3-1"], [:team, "Bahia"]],
  [[:player, "Matheus Ferraz"],[:minute, "45'+1'"],[:","],
   [:player, "Lins"],[:minute, "46'"],[:","],
   [:player, "João Vítor"],[:minute, "82'"],[:";"],
   [:player, "Diones"],[:minute, "72'"]],
[[:team, "Santos"], [:score, "0-0"], [:team, "Flamengo"], [:note, "played in Brasília-DF"]],
[[:team, "Fluminense"], [:score, "2-1"], [:team, "Atlético/PR"], [:note, "played in Macaé-RJ"]],
  [[:player, "Rafael Sóbis"],[:minute, "15'"],[:pen, "p"],[:","],
   [:player, "Samuel"],[:minute, "53'"],[:";"],
   [:player, "Manoel"],[:minute, "28'"]],
[[:team, "Cruzeiro"], [:score, "5-0"], [:team, "Goiás"]],
  [[:player, "Diego Souza"],[:minute, "5'"],[:","],
   [:player, "Bruno Rodrigo"],[:minute, "30'"],[:","],
   [:player, "Nílton"],[:minute, "40'"],[:","],[:minute, "79'"],[:","],
   [:player, "Borges"],[:minute, "42'"]],
[[:team, "Coritiba"], [:score, "2-1"], [:team, "Atlético/MG"]],
  [[:player, "Deivid"],[:minute, "53'"],[:","],
   [:player, "Arthur"],[:minute, "90'+1'"],[:";"],
   [:player, "Diego Tardelli"],[:minute, "51'"]]] 

  assert_equal exp, tree
end


end # class TestBr
