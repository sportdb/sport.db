####
#  to run use:
#    $ ruby ./main2b.rb  (in /fbtxt)



$LOAD_PATH.unshift( '../lib' )
require 'sportdb/parser'




txt = <<-TXT

Group A

  Fri Jun 14 21:00  @ München Fußball Arena, München        
 (1)  Germany  v  Scotland   5-1 (3-0)     
        Wirtz 10' Musiala 19' Havertz 45+1' (pen.) Füllkrug 68' Can 90+3'; Rüdiger 87' (o.g.)

  Germany:    Neuer - Kimmich, Rüdiger, Tah [Y], Mittelstädt - Andrich [Y] (Groß 46'),
              Kroos (Can 80') - Musiala (Müller 74'), Gündogan, Wirtz (Sane 63') - 
              Havertz (Füllkrug 63')
  Scotland:   Gunn - Porteous [R 44'], Hendry, Tierney (McKenna 78') - Ralston [Y],
              McTominay, McGregor (Gilmour 67'), Robertson - Christie (Shankland 82'),
              Adams (Hanley 46'), McGinn (McLean 67')

 Sat Jun 15 15:00  @ Köln Stadion, Köln
 (2)  Hungary   v   Switzerland  1-3 (0-2)  
          Varga 66'; Duah 12' Aebischer 45' Embolo 90+3'

  Hungary:     Gulacsi - Lang (Bolla [Y] 46'), Orban, Szalai [Y] (Dardai 79') - Fiola,
               Nagy (Kleinheisler 67'), Schäfer, Kerkez (Adam 79') - 
               Sallai, Varga, Szoboszlai
  Switzerland: Sommer - Schär, Akanji, Rodriguez - Widmer [Y] (Stergiou 68'), Xhaka,
               Freuler [Y] (Sierro 86'), Aebischer - Ndoye (Rieder 86'), Duah (Amdouni 68'),
               Vargas (Embolo 73')

TXT



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