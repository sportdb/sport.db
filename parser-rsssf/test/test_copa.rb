###
#  to run use
#     ruby test/test_copa.rb


require_relative 'helper'


class TestCopa < Minitest::Test

  def test_2021
txt =<<TXT
# source @  https://www.rsssf.org/tables/2021sa.html
#

# Copa América 2021
#  Held in Brazil, June 13-July 10, 2021

Group A
Jun 14 Argentina       1-1 Chile                        Rio de Janeiro
        [Messi 33; Vargas 57]
Jun 14 Paraguay        3-1 Bolivia                      Goiânia
        [Romero Gamarra 62, Angel Romero 65, 80; Saavedra 10pen]
Jun 18 Chile           1-0 Bolivia                      Cuiabá
        [Brereton 10]
Jun 18 Argentina       1-0 Uruguay                      Brasília
        [Rodriguez 13]
Jun 21 Uruguay         1-1 Chile                        Cuiabá
        [Suarez 66; Vargas 26]
Jun 21 Argentina       1-0 Paraguay                     Brasília
        [A. Gomez 10]
Jun 24 Bolivia         0-2 Uruguay                      Cuiabá
        [Quinteros 40og, Cavani 79]
Jun 24 Chile           0-2 Paraguay                     Brasília
        [Samudio 33, Almiron 58pen]
Jun 28 Bolivia         1-4 Argentina                    Cuiabá
        [Saavedra 60; A. Gomez 6, Messi 33pen, 42, Lautaro Martinez 65]
Jun 28 Uruguay         1-0 Paraguay                     Rio de Janeiro 
        [Cavani 21pen]


Group B
Jun 13 Brazil          3-0 Venezuela                    Brasília
        [Marquinhos 23, Neymar 64pen, Gabriel Barbosa 89]
Jun 13 Colombia        1-0 Ecuador                      Cuiabá
        [Cardona 42]
Jun 17 Colombia        0-0 Venezuela                    Goiânia
Jun 17 Brazil          4-0 Peru                         Rio de Janeiro 
        [Alex Sandro 12, Neymar 68, Everton Ribeiro 89, Richarlison 90+3]
Jun 20 Venezuela       2-2 Ecuador                      Rio de Janeiro
        [Castillo 51, Hernandez 90+1; Ayrton Preciado 39, Plata 71]
Jun 20 Colombia        1-2 Peru                         Goiânia
        [Borja 53pen; Pena 17, Mina 64og]
Jun 23 Ecuador         2-2 Peru                         Goiânia
        [Tapia 23og, Ayrton Preciado 45+3; Lapadula 49, Carrillo 54]
Jun 23 Brazil          2-1 Colombia                     Rio de Janeiro
        [Firmino 78, Casemiro 90+10; Diaz 10]
Jun 27 Brazil          1-1 Ecuador                      Goiânia
        [Militao 37; Mena 53]
Jun 27 Venezuela       0-1 Peru                         Brasília
        [Carrillo 48]


Quarterfinals    # NB: no extra time played after draw
Jul  2 Peru            3-3 Paraguay           [4-3 pen] Goiânia
        [Gustavo Gomez 21og, Lapadula 40, Yotun 80; Gustavo Gomez 11, 
         Alonso 54, Avalos 90]
Jul  2 Brazil          1-0 Chile                        Rio de Janeiro
        [Paqueta 46]
Jul  3 Uruguay         0-0 Colombia           [2-4 pen] Brasília
Jul  3 Argentina       3-0 Ecuador                      Goiânia
        [De Paul 40, Lautaro Martinez 84, Messi 90+3]

Semifinals      # NB: no extra time played after draw
Jul  5 Brazil          1-0 Peru                         Rio de Janeiro
        [Paqueta 35]
Jul  6 Argentina       1-1 Colombia           [3-2 pen] Brasília 
        [Lautaro Martinez 7; Diaz 61]

Third Place Match
Jul  9 Peru            2-3 Colombia                     Brasília 
        [Yotun 45, Lapadula 82; Cuadrado 49, Diaz 66, 90+4]

Final
Jul 10 Brazil          0-1 Argentina                    Rio de Janeiro
        [Di Maria 22]


TXT


lines = txt.split( "\n" )
pp lines


parser = Rsssf::Parser.new

tree = []
lines.each do |line|
 
    ## skip blank and comment lines
    next if line.strip.empty? || line.strip.start_with?('#')

    ## strip inline (end-of-line) comments
    line = line.sub( /#.+$/, '' )

   puts
   puts "line #{line.inspect}"   # note - use inspect (will show \t etc.)
   # t = parser.tokenize( line )
   t = parser.parse( line )
   pp t
   tree << t
end

puts
puts "tree:"
pp tree

exp = [
[[:group, "Group A"]],
[[:date, "Jun 14"], [:team, "Argentina"], [:score, "1-1"], [:team, "Chile"], [:text, "Rio de Janeiro"]],
   [[:player, "Messi"], [:minute, "33"], [:";"], 
    [:player, "Vargas"], [:minute, "57"]],
[[:date, "Jun 14"], [:team, "Paraguay"], [:score, "3-1"], [:team, "Bolivia"], [:text, "Goiânia"]],
   [[:player, "Romero Gamarra"],[:minute, "62"],[:","],
    [:player, "Angel Romero"],[:minute, "65"],[:","],[:minute, "80"],[:";"],
    [:player, "Saavedra"],[:minute, "10"],[:pen, "pen"]],
[[:date, "Jun 18"], [:team, "Chile"], [:score, "1-0"], [:team, "Bolivia"], [:text, "Cuiabá"]],
    [[:player, "Brereton"], [:minute, "10"]],
[[:date, "Jun 18"], [:team, "Argentina"], [:score, "1-0"], [:team, "Uruguay"], [:text, "Brasília"]],
    [[:player, "Rodriguez"], [:minute, "13"]],
[[:date, "Jun 21"], [:team, "Uruguay"], [:score, "1-1"], [:team, "Chile"], [:text, "Cuiabá"]],
    [[:player, "Suarez"], [:minute, "66"], [:";"], 
     [:player, "Vargas"], [:minute, "26"]],
[[:date, "Jun 21"], [:team, "Argentina"], [:score, "1-0"], [:team, "Paraguay"], [:text, "Brasília"]],
    [[:player, "A. Gomez"], [:minute, "10"]],
[[:date, "Jun 24"], [:team, "Bolivia"], [:score, "0-2"], [:team, "Uruguay"], [:text, "Cuiabá"]],
    [[:player, "Quinteros"], [:minute, "40"], [:og, "og"], [:","], 
     [:player, "Cavani"], [:minute, "79"]],
[[:date, "Jun 24"], [:team, "Chile"], [:score, "0-2"], [:team, "Paraguay"], [:text, "Brasília"]],
    [[:player, "Samudio"], [:minute, "33"], [:","], 
     [:player, "Almiron"], [:minute, "58"], [:pen, "pen"]],
[[:date, "Jun 28"], [:team, "Bolivia"], [:score, "1-4"], [:team, "Argentina"], [:text, "Cuiabá"]],
    [[:player, "Saavedra"],[:minute, "60"],[:";"],
     [:player, "A. Gomez"],[:minute, "6"],[:","],
     [:player, "Messi"],[:minute, "33"],[:pen, "pen"],[:","],[:minute, "42"],[:","],
     [:player, "Lautaro Martinez"],[:minute, "65"]],
[[:date, "Jun 28"], [:team, "Uruguay"], [:score, "1-0"], [:team, "Paraguay"], [:text, "Rio de Janeiro"]],
    [[:player, "Cavani"], [:minute, "21"], [:pen, "pen"]],

[[:group, "Group B"]],
[[:date, "Jun 13"], [:team, "Brazil"], [:score, "3-0"], [:team, "Venezuela"], [:text, "Brasília"]],
   [[:player, "Marquinhos"],[:minute, "23"],[:","],
    [:player, "Neymar"],[:minute, "64"],[:pen, "pen"],[:","],
    [:player, "Gabriel Barbosa"],[:minute, "89"]],
[[:date, "Jun 13"], [:team, "Colombia"], [:score, "1-0"], [:team, "Ecuador"], [:text, "Cuiabá"]],
   [[:player, "Cardona"], [:minute, "42"]],
[[:date, "Jun 17"], [:team, "Colombia"], [:score, "0-0"], [:team, "Venezuela"], [:text, "Goiânia"]],
[[:date, "Jun 17"], [:team, "Brazil"], [:score, "4-0"], [:team, "Peru"], [:text, "Rio de Janeiro"]],
   [[:player, "Alex Sandro"],[:minute, "12"],[:","],
    [:player, "Neymar"],[:minute, "68"],[:","],
    [:player, "Everton Ribeiro"],[:minute, "89"],[:","],
    [:player, "Richarlison"],[:minute, "90+3"]],
[[:date, "Jun 20"], [:team, "Venezuela"], [:score, "2-2"], [:team, "Ecuador"], [:text, "Rio de Janeiro"]],
   [[:player, "Castillo"],[:minute, "51"],[:","],
    [:player, "Hernandez"],[:minute, "90+1"],[:";"],
    [:player, "Ayrton Preciado"],[:minute, "39"],[:","],
    [:player, "Plata"],[:minute, "71"]],
[[:date, "Jun 20"], [:team, "Colombia"], [:score, "1-2"], [:team, "Peru"], [:text, "Goiânia"]],
   [[:player, "Borja"],[:minute, "53"],[:pen, "pen"],[:";"],
    [:player, "Pena"],[:minute, "17"],[:","],
    [:player, "Mina"],[:minute, "64"],[:og, "og"]],
[[:date, "Jun 23"], [:team, "Ecuador"], [:score, "2-2"], [:team, "Peru"], [:text, "Goiânia"]],
   [[:player, "Tapia"],[:minute, "23"],[:og, "og"],[:","],
    [:player, "Ayrton Preciado"],[:minute, "45+3"],[:";"],
    [:player, "Lapadula"],[:minute, "49"],[:","],
    [:player, "Carrillo"],[:minute, "54"]],
[[:date, "Jun 23"], [:team, "Brazil"], [:score, "2-1"], [:team, "Colombia"], [:text, "Rio de Janeiro"]],
   [[:player, "Firmino"],[:minute, "78"],[:","],
    [:player, "Casemiro"],[:minute, "90+10"],[:";"],
    [:player, "Diaz"],[:minute, "10"]],
[[:date, "Jun 27"], [:team, "Brazil"], [:score, "1-1"], [:team, "Ecuador"], [:text, "Goiânia"]],
   [[:player, "Militao"], [:minute, "37"], [:";"], 
    [:player, "Mena"], [:minute, "53"]],
[[:date, "Jun 27"], [:team, "Venezuela"], [:score, "0-1"], [:team, "Peru"], [:text, "Brasília"]],
   [[:player, "Carrillo"], [:minute, "48"]],

[[:round, "Quarterfinals"]],
[[:date, "Jul  2"],
 [:team, "Peru"],
 [:score, "3-3"],
 [:team, "Paraguay"],
 [:score_ext, "4-3 pen"],
 [:text, "Goiânia"]],
  [[:player, "Gustavo Gomez"],[:minute, "21"],[:og, "og"],[:","],
   [:player, "Lapadula"],[:minute, "40"],[:","],
   [:player, "Yotun"],[:minute, "80"],[:";"],
   [:player, "Gustavo Gomez"],[:minute, "11"],[:","]],
  [[:player, "Alonso"], [:minute, "54"], [:","], 
   [:player, "Avalos"], [:minute, "90"]],
[[:date, "Jul  2"], [:team, "Brazil"], [:score, "1-0"], [:team, "Chile"], [:text, "Rio de Janeiro"]],
   [[:player, "Paqueta"], [:minute, "46"]],
[[:date, "Jul  3"],
 [:team, "Uruguay"],
 [:score, "0-0"],
 [:team, "Colombia"],
 [:score_ext, "2-4 pen"],
 [:text, "Brasília"]],
[[:date, "Jul  3"], [:team, "Argentina"], [:score, "3-0"], [:team, "Ecuador"], [:text, "Goiânia"]],
  [[:player, "De Paul"],[:minute, "40"],[:","],
   [:player, "Lautaro Martinez"],[:minute, "84"],[:","],
   [:player, "Messi"],[:minute, "90+3"]],

[[:round, "Semifinals"]],
[[:date, "Jul  5"], [:team, "Brazil"], [:score, "1-0"], [:team, "Peru"], [:text, "Rio de Janeiro"]],
  [[:player, "Paqueta"], [:minute, "35"]],
[[:date, "Jul  6"],
 [:team, "Argentina"],
 [:score, "1-1"],
 [:team, "Colombia"],
 [:score_ext, "3-2 pen"],
 [:text, "Brasília"]],
  [[:player, "Lautaro Martinez"], [:minute, "7"], [:";"], 
   [:player, "Diaz"], [:minute, "61"]],

[[:round, "Third Place Match"]],
[[:date, "Jul  9"], [:team, "Peru"], [:score, "2-3"], [:team, "Colombia"], [:text, "Brasília"]],
  [[:player, "Yotun"],[:minute, "45"],[:","],
   [:player, "Lapadula"],[:minute, "82"],[:";"],
   [:player, "Cuadrado"],[:minute, "49"],[:","],
   [:player, "Diaz"],[:minute, "66"],[:","],[:minute, "90+4"]],
   
[[:round, "Final"]],
[[:date, "Jul 10"], [:team, "Brazil"], [:score, "0-1"], [:team, "Argentina"], [:text, "Rio de Janeiro"]],
[[:player, "Di Maria"], [:minute, "22"]]
]

    assert_equal exp, tree
  end
end