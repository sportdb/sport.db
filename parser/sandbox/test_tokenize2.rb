####
#  to run use:
#    $ ruby sandbox/test_tokenize2.rb


$LOAD_PATH.unshift( './lib' )
require 'sportdb/parser'



txt = <<TXT

Group A

 (1) Fri Jun/14 21:00         Germany   5-1 (3-0)  Scotland     @ München Fußball Arena, München
        [Wirtz 10' Musiala 19' Havertz 45+1' (pen.) Füllkrug 68' Can 90+3'; Rüdiger 87' (o.g.)]
  Germany:    Neuer - Kimmich, Rüdiger, Tah [Y], Mittelstädt - Andrich [Y] (46' Groß),
              Kroos (80' Can) - Musiala (74' Müller), Gündogan,
              Wirtz (63' Sane) - Havertz (63' Füllkrug).
  Scotland:   Gunn - Porteous [R 44'], Hendry, Tierney (78' McKenna) - Ralston [Y],
              McTominay, McGregor (67' Gilmour), Robertson - Christie (82' Shankland),
              Adams (46' Hanley), McGinn (67' McLean).

 (2) Sat Jun/15 15:00         Hungary   1-3 (0-2)   Switzerland  @ Köln Stadion, Köln
           [Varga 66'; Duah 12' Aebischer 45' Embolo 90+3']
  Hungary:     Gulacsi - Lang (46' Bolla [Y]), Orban, Szalai [Y] (79' Dardai) - Fiola,
               Nagy (67' Kleinheisler), Schäfer, Kerkez (79' Adam) - Sallai, Varga, Szoboszlai.
  Switzerland: Sommer - Schär, Akanji, Rodriguez - Widmer [Y] (68' Stergiou), Xhaka,
               Freuler [Y] (86' Sierro), Aebischer - Ndoye (86' Rieder), Duah (68' Amdouni),
               Vargas (73' Embolo).


TXT

puts txt
puts


parser = SportDb::Parser.new
tokens = parser.tokenize( txt )
pp tokens

puts "bye"