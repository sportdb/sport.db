####
#  to run use:
#    $ ruby ./main2.rb  (in /fbtxt)



$LOAD_PATH.unshift( '../lib' )
require 'sportdb/parser'




txt = <<-TXT

Group A

 (1) Fri Jun/14 21:00         Germany   5-1 (3-0)  Scotland     @ München Fußball Arena, München
        [Wirtz 10' Musiala 19' Havertz 45+1' (pen.) Füllkrug 68' Can 90+3'; Rüdiger 87' (o.g.)]

  Germany:    Neuer - Kimmich, Rüdiger, Tah [Y], Mittelstädt - Andrich [Y] (46' Groß),
              Kroos (80' Can) - Musiala (74' Müller), Gündogan, Wirtz (63' Sane) - 
              Havertz (63' Füllkrug).
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


################
#### more       
Rapid Wien   0-1  Austria Wien
Rapid Wien   0-2  Austria Wien    [awarded]

Rapid Wien v Austria Wien
Rapid Wien v Austria Wien 0-3   [awarded]
Rapid Wien v Austria Wien 0-4     @ Gerhard-Hanappi-Stadion, Wien
Rapid Wien v Austria Wien   [cancelled]   @ Gerhard-Hanappi-Stadion, Wien
Rapid Wien - Austria Wien    


TXT


###
# test tokenize
tok = SportDb::Tokenizer.new( txt )
pp tok.next_token
pp tok.next_token
pp tok.next_token
pp tok.next_token
pp tok.next_token
pp tok.next_token

puts "---"



  parser = RaccMatchParser.new( txt )
  tree = parser.parse
  pp tree



puts "bye"

__END__


<LineupLine Germany lineup=[
   [Neuer],
   [Kimmich, Rüdiger, Tah card=Y, Mittelstädt],
   [Andrich card=Y sub=(46' Groß), Kroos sub=(80' Can)],
   [Musiala sub=(74' Müller), Gündogan, Wirtz sub=(63' Sane)],
   [Havertz sub=(63' Füllkrug)]
]>,

<LineupLine Scotland lineup=[
  [Gunn],
  [Porteous card=R 44', Hendry, Tierney sub=(78' McKenna)],
  [Ralston card=Y, McTominay, McGregor sub=(67' Gilmour), Robertson],
  [Christie sub=(82' Shankland), Adams sub=(46' Hanley), McGinn sub=(67' McLean)]
]>