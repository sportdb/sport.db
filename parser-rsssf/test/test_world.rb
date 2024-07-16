###
#  to run use
#     ruby test/test_world.rb


##
# note -
#   TWO SPACES REQUIRED between text (runs) e.g.
#
#  3- 6-21 Santiago del E. Argentina     1-1 Chile
#  9- 9-21 São Lourenço M. Brazil        2-0 Peru
#
#  MUST change to =>
#  3- 6-21 Santiago del E.  Argentina     1-1 Chile
#  9- 9-21 São Lourenço M.  Brazil        2-0 Peru


require_relative 'helper'


class TestWorld < Minitest::Test

  def test_quali2022
world =<<TXT
# source @  https://www.rsssf.org/tables/2022q.html
#

##  World Cup 2022 Quali

## Europe

Group A
24- 3-21 Torino          Portugal      1-0 Azerbaijan
24- 3-21 Beograd         Serbia        3-2 Ireland
27- 3-21 Dublin          Ireland       0-1 Luxembourg
27- 3-21 Beograd         Serbia        2-2 Portugal
30- 3-21 Baku            Azerbaijan    1-2 Serbia
30- 3-21 Luxembourg      Luxembourg    1-3 Portugal
 1- 9-21 Luxembourg      Luxembourg    2-1 Azerbaijan
 1- 9-21 Faro/Loulé      Portugal      2-1 Ireland
 4- 9-21 Dublin          Ireland       1-1 Azerbaijan
 4- 9-21 Beograd         Serbia        4-1 Luxembourg
 7- 9-21 Baku            Azerbaijan    0-3 Portugal
 7- 9-21 Dublin          Ireland       1-1 Serbia
 9-10-21 Baku            Azerbaijan    0-3 Ireland
 9-10-21 Luxembourg      Luxembourg    0-1 Serbia
12-10-21 Faro/Loulé      Portugal      5-0 Luxembourg
12-10-21 Beograd         Serbia        3-1 Azerbaijan

# ...

## Playoff Stage

## Path A

Semifinals
24- 3-22 Cardiff         Wales         2-1 Austria
 1- 6-22 Glasgow         Scotland      1-3 Ukrain

Final
 5- 6-22 Cardiff         Wales         1-0 Ukraine

## Path B

Semifinals
24- 3-22 Moskva          Russia awd Poland        [awarded 0-3 because of suspension Russia]
24- 3-22 Solna           Sweden 1-0 Czech Rep.    [aet]

Final
29- 3-22 Chorzów         Poland        2-0 Sweden


### South America

 3- 6-21 La Paz           Bolivia       3-1 Venezuela
 3- 6-21 Montevideo       Uruguay       0-0 Paraguay
 3- 6-21 Santiago del E.  Argentina     1-1 Chile
 3- 6-21 Lima             Peru          0-3 Colombia
 4- 6-21 Porto Alegre     Brazil        2-0 Ecuador
 8- 6-21 Quito            Ecuador       1-2 Peru
 8- 6-21 Caracas          Venezuela     0-0 Uruguay
 8- 6-21 Barranquilla     Colombia      2-2 Argentina
 8- 6-21 Asunción         Paraguay      0-2 Brazil
 8- 6-21 Santiago         Chile         1-1 Bolivia
 2- 9-21 La Paz           Bolivia       1-1 Colombia
 2- 9-21 Quito            Ecuador       2-0 Paraguay
 2- 9-21 Caracas          Venezuela     1-3 Argentina
 2- 9-21 Lima             Peru          1-1 Uruguay
 2- 9-21 Santiago         Chile         0-1 Brazil
 5- 9-21 Quito            Ecuador       0-0 Chile
 5- 9-21 Montevideo       Uruguay       4-2 Bolivia
 5- 9-21 Asunción         Paraguay      1-1 Colombia
 5- 9-21 Lima             Peru          1-0 Venezuela
 9- 9-21 Montevideo       Uruguay       1-0 Ecuador
 9- 9-21 Asunción         Paraguay      2-1 Venezuela
 9- 9-21 Barranquilla     Colombia      3-1 Chile
 9- 9-21 Buenos Aires     Argentina     3-0 Bolivia
 9- 9-21 São Lourenço M.  Brazil        2-0 Peru
## ...
21- 9-22 São Paulo       Brazil n/p Argentina     [declared void]

# AFC/CONMEBOL Playoff

13- 6-22 Al-Rayyan       Australia 0-0 Peru          [aet, 5-4 pen.]

# Africa
# First Round

 8- 9-19 Maseru           Lesotho 1-1 Ethiopia
 8- 9-19 Dar es Salaam   Tanzania 1-1 Burundi       [aet, 3-0 pen.]
# ... 
10- 9-19 Bissau          Guinea-Bissau 2-1 São Tomé & Príncipe

# ...
 7- 9-21 Malabo          Equatorial G. 1-0 Mauritania
 7-10-21 Malabo          Equatorial G. 2-0 Zambia
 7-10-21 Tunis           Tunisia       3-0 Mauritania
10-10-21 Lusaka          Zambia        1-1 Equatorial Guinea
# ...
 7-10-21 Lagos           Nigeria       0-1 Central African Republic
10-10-21 Douala          Centr.Afr. R. 0-2 Nigeria

# ...
29- 3-22 Dakar           Senegal       1-0 Egypt         [aet, 3-1 pen.]
29- 3-22 Blida           Algeria       1-2 Cameroon      [aet]



## try awd with single space before team name
#  Asia
11- 6-19 Bandar Seri B.  Brunei 2-1 Mongolia
11- 6-19 Colombo         Sri Lanka awd Macao         [awarded 3-0]

# ...
30- 3-20 Chiba           Mongolia     0-14 Japan
28- 5-20 Chiba           Japan        10-0 Myanmar

# ...
 5- 9-19 Pyongyang       North Korea   2-0 Lebanon       [annulled]
10- 9-19 Ashgabat        Turkmenistan  0-2 South Korea
10- 9-19 Colombo         Sri Lanka     0-1 North Korea   [annulled]
10-10-19 Hwaseong        South Korea   8-0 Sri Lanka
10-10-19 Beirut          Lebanon       2-1 Turkmenistan
15-10-19 Pyongyang       North Korea   0-0 South Korea   [annulled]

# Oceania

##
##  try  n/p  with single space before team name

17- 3-22 Doha            Cook Islands 0-2 Solomon I.    [annulled]
17- 3-22 Doha            Tahiti n/p Vanuatu       
20- 3-22 Doha            Cook Islands n/p Tahiti        
20- 3-22 Doha            Solomon I. n/p Vanuatu       
24- 3-22 Doha            Vanuatu n/p Cook Islands  
24- 3-22 Doha            Solomon I. 3-1 Tahiti        


TXT



lines = world.split( "\n" )
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
[[:date, "24- 3-21"], [:text, "Torino"], [:team, "Portugal"], [:score, "1-0"], [:team, "Azerbaijan"]],
[[:date, "24- 3-21"], [:text, "Beograd"], [:team, "Serbia"], [:score, "3-2"], [:team, "Ireland"]],
[[:date, "27- 3-21"], [:text, "Dublin"], [:team, "Ireland"], [:score, "0-1"], [:team, "Luxembourg"]],
[[:date, "27- 3-21"], [:text, "Beograd"], [:team, "Serbia"], [:score, "2-2"], [:team, "Portugal"]],
[[:date, "30- 3-21"], [:text, "Baku"], [:team, "Azerbaijan"], [:score, "1-2"], [:team, "Serbia"]],
[[:date, "30- 3-21"], [:text, "Luxembourg"], [:team, "Luxembourg"], [:score, "1-3"], [:team, "Portugal"]],
[[:date, "1- 9-21"], [:text, "Luxembourg"], [:team, "Luxembourg"], [:score, "2-1"], [:team, "Azerbaijan"]],
[[:date, "1- 9-21"], [:text, "Faro/Loulé"], [:team, "Portugal"], [:score, "2-1"], [:team, "Ireland"]],
[[:date, "4- 9-21"], [:text, "Dublin"], [:team, "Ireland"], [:score, "1-1"], [:team, "Azerbaijan"]],
[[:date, "4- 9-21"], [:text, "Beograd"], [:team, "Serbia"], [:score, "4-1"], [:team, "Luxembourg"]],
[[:date, "7- 9-21"], [:text, "Baku"], [:team, "Azerbaijan"], [:score, "0-3"], [:team, "Portugal"]],
[[:date, "7- 9-21"], [:text, "Dublin"], [:team, "Ireland"], [:score, "1-1"], [:team, "Serbia"]],
[[:date, "9-10-21"], [:text, "Baku"], [:team, "Azerbaijan"], [:score, "0-3"], [:team, "Ireland"]],
[[:date, "9-10-21"], [:text, "Luxembourg"], [:team, "Luxembourg"], [:score, "0-1"], [:team, "Serbia"]],
[[:date, "12-10-21"], [:text, "Faro/Loulé"], [:team, "Portugal"], [:score, "5-0"], [:team, "Luxembourg"]],
[[:date, "12-10-21"], [:text, "Beograd"], [:team, "Serbia"], [:score, "3-1"], [:team, "Azerbaijan"]],
[[:round, "Semifinals"]],
[[:date, "24- 3-22"], [:text, "Cardiff"], [:team, "Wales"], [:score, "2-1"], [:team, "Austria"]],
[[:date, "1- 6-22"], [:text, "Glasgow"], [:team, "Scotland"], [:score, "1-3"], [:team, "Ukrain"]],
[[:round, "Final"]],
[[:date, "5- 6-22"], [:text, "Cardiff"], [:team, "Wales"], [:score, "1-0"], [:team, "Ukraine"]],
[[:round, "Semifinals"]],
[[:date, "24- 3-22"],[:text, "Moskva"],[:team, "Russia"],[:score_awd, "awd"],[:team, "Poland"],
   [:note, "awarded 0-3 because of suspension Russia"]],
[[:date, "24- 3-22"],[:text, "Solna"],[:team, "Sweden"],[:score, "1-0"],[:team, "Czech Rep."],[:score_ext, "aet"]],
[[:round, "Final"]],
[[:date, "29- 3-22"], [:text, "Chorzów"], [:team, "Poland"], [:score, "2-0"], [:team, "Sweden"]],
[[:date, "3- 6-21"], [:text, "La Paz"], [:team, "Bolivia"], [:score, "3-1"], [:team, "Venezuela"]],
[[:date, "3- 6-21"], [:text, "Montevideo"], [:team, "Uruguay"], [:score, "0-0"], [:team, "Paraguay"]],
[[:date, "3- 6-21"], [:text, "Santiago del E."], [:team, "Argentina"], [:score, "1-1"], [:team, "Chile"]],
[[:date, "3- 6-21"], [:text, "Lima"], [:team, "Peru"], [:score, "0-3"], [:team, "Colombia"]],
[[:date, "4- 6-21"], [:text, "Porto Alegre"], [:team, "Brazil"], [:score, "2-0"], [:team, "Ecuador"]],
[[:date, "8- 6-21"], [:text, "Quito"], [:team, "Ecuador"], [:score, "1-2"], [:team, "Peru"]],
[[:date, "8- 6-21"], [:text, "Caracas"], [:team, "Venezuela"], [:score, "0-0"], [:team, "Uruguay"]],
[[:date, "8- 6-21"], [:text, "Barranquilla"], [:team, "Colombia"], [:score, "2-2"], [:team, "Argentina"]],
[[:date, "8- 6-21"], [:text, "Asunción"], [:team, "Paraguay"], [:score, "0-2"], [:team, "Brazil"]],
[[:date, "8- 6-21"], [:text, "Santiago"], [:team, "Chile"], [:score, "1-1"], [:team, "Bolivia"]],
[[:date, "2- 9-21"], [:text, "La Paz"], [:team, "Bolivia"], [:score, "1-1"], [:team, "Colombia"]],
[[:date, "2- 9-21"], [:text, "Quito"], [:team, "Ecuador"], [:score, "2-0"], [:team, "Paraguay"]],
[[:date, "2- 9-21"], [:text, "Caracas"], [:team, "Venezuela"], [:score, "1-3"], [:team, "Argentina"]],
[[:date, "2- 9-21"], [:text, "Lima"], [:team, "Peru"], [:score, "1-1"], [:team, "Uruguay"]],
[[:date, "2- 9-21"], [:text, "Santiago"], [:team, "Chile"], [:score, "0-1"], [:team, "Brazil"]],
[[:date, "5- 9-21"], [:text, "Quito"], [:team, "Ecuador"], [:score, "0-0"], [:team, "Chile"]],
[[:date, "5- 9-21"], [:text, "Montevideo"], [:team, "Uruguay"], [:score, "4-2"], [:team, "Bolivia"]],
[[:date, "5- 9-21"], [:text, "Asunción"], [:team, "Paraguay"], [:score, "1-1"], [:team, "Colombia"]],
[[:date, "5- 9-21"], [:text, "Lima"], [:team, "Peru"], [:score, "1-0"], [:team, "Venezuela"]],
[[:date, "9- 9-21"], [:text, "Montevideo"], [:team, "Uruguay"], [:score, "1-0"], [:team, "Ecuador"]],
[[:date, "9- 9-21"], [:text, "Asunción"], [:team, "Paraguay"], [:score, "2-1"], [:team, "Venezuela"]],
[[:date, "9- 9-21"], [:text, "Barranquilla"], [:team, "Colombia"], [:score, "3-1"], [:team, "Chile"]],
[[:date, "9- 9-21"], [:text, "Buenos Aires"], [:team, "Argentina"], [:score, "3-0"], [:team, "Bolivia"]],
[[:date, "9- 9-21"], [:text, "São Lourenço M."], [:team, "Brazil"], [:score, "2-0"], [:team, "Peru"]],
[[:date, "21- 9-22"],[:text, "São Paulo"],[:team, "Brazil"],[:score_np, "n/p"],[:team, "Argentina"],
   [:note, "declared void"]],
[[:date, "13- 6-22"],[:text, "Al-Rayyan"],[:team, "Australia"],[:score, "0-0"],[:team, "Peru"],[:score_ext, "aet, 5-4 pen."]],
[[:date, "8- 9-19"], [:text, "Maseru"], [:team, "Lesotho"], [:score, "1-1"], [:team, "Ethiopia"]],
[[:date, "8- 9-19"],[:text, "Dar es Salaam"],[:team, "Tanzania"],[:score, "1-1"],[:team, "Burundi"],[:score_ext, "aet, 3-0 pen."]],
[[:date, "10- 9-19"], [:text, "Bissau"], [:team, "Guinea-Bissau"], [:score, "2-1"], [:team, "São Tomé & Príncipe"]],
[[:date, "7- 9-21"], [:text, "Malabo"], [:team, "Equatorial G."], [:score, "1-0"], [:team, "Mauritania"]],
[[:date, "7-10-21"], [:text, "Malabo"], [:team, "Equatorial G."], [:score, "2-0"], [:team, "Zambia"]],
[[:date, "7-10-21"], [:text, "Tunis"], [:team, "Tunisia"], [:score, "3-0"], [:team, "Mauritania"]],
[[:date, "10-10-21"], [:text, "Lusaka"], [:team, "Zambia"], [:score, "1-1"], [:team, "Equatorial Guinea"]],
[[:date, "7-10-21"], [:text, "Lagos"], [:team, "Nigeria"], [:score, "0-1"], [:team, "Central African Republic"]],
[[:date, "10-10-21"], [:text, "Douala"], [:team, "Centr.Afr. R."], [:score, "0-2"], [:team, "Nigeria"]],
[[:date, "29- 3-22"],
 [:text, "Dakar"],
 [:team, "Senegal"],
 [:score, "1-0"],
 [:team, "Egypt"],
 [:score_ext, "aet, 3-1 pen."]],
[[:date, "29- 3-22"],
 [:text, "Blida"],
 [:team, "Algeria"],
 [:score, "1-2"],
 [:team, "Cameroon"],
 [:score_ext, "aet"]],
[[:date, "11- 6-19"], [:text, "Bandar Seri B."], [:team, "Brunei"], [:score, "2-1"], [:team, "Mongolia"]],
[[:date, "11- 6-19"],[:text, "Colombo"],[:team, "Sri Lanka"],[:score_awd, "awd"],[:team, "Macao"],
   [:note, "awarded 3-0"]],
[[:date, "30- 3-20"], [:text, "Chiba"], [:team, "Mongolia"], [:score, "0-14"], [:team, "Japan"]],
[[:date, "28- 5-20"], [:text, "Chiba"], [:team, "Japan"], [:score, "10-0"], [:team, "Myanmar"]],
[[:date, "5- 9-19"],[:text, "Pyongyang"],[:team, "North Korea"],[:score, "2-0"],[:team, "Lebanon"],
   [:note, "annulled"]],
[[:date, "10- 9-19"], [:text, "Ashgabat"], [:team, "Turkmenistan"], [:score, "0-2"], [:team, "South Korea"]],
[[:date, "10- 9-19"],
 [:text, "Colombo"],
 [:team, "Sri Lanka"],
 [:score, "0-1"],
 [:team, "North Korea"],
 [:note, "annulled"]],
[[:date, "10-10-19"], [:text, "Hwaseong"], [:team, "South Korea"], [:score, "8-0"], [:team, "Sri Lanka"]],
[[:date, "10-10-19"], [:text, "Beirut"], [:team, "Lebanon"], [:score, "2-1"], [:team, "Turkmenistan"]],
[[:date, "15-10-19"],[:text, "Pyongyang"],[:team, "North Korea"],[:score, "0-0"],[:team, "South Korea"],
   [:note, "annulled"]],
[[:date, "17- 3-22"],[:text, "Doha"],[:team, "Cook Islands"],[:score, "0-2"],[:team, "Solomon I."],
   [:note, "annulled"]],
[[:date, "17- 3-22"], [:text, "Doha"], [:team, "Tahiti"], [:score_np, "n/p"], [:team, "Vanuatu"]],
[[:date, "20- 3-22"], [:text, "Doha"], [:team, "Cook Islands"], [:score_np, "n/p"], [:team, "Tahiti"]],
[[:date, "20- 3-22"], [:text, "Doha"], [:team, "Solomon I."], [:score_np, "n/p"], [:team, "Vanuatu"]],
[[:date, "24- 3-22"], [:text, "Doha"], [:team, "Vanuatu"], [:score_np, "n/p"], [:team, "Cook Islands"]],
[[:date, "24- 3-22"], [:text, "Doha"], [:team, "Solomon I."], [:score, "3-1"], [:team, "Tahiti"]]]

   assert_equal exp, tree
end
end
