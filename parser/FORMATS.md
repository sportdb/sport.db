# Notes on (Alternate) Formats


## use/support/allow/enable two (separate) team lines - why? why not?

e.g.

```
 (1) Fri Jun/14 21:00         Germany   5-1 (3-0)  Scotland     @ München Fußball Arena, München
        [Wirtz 10' Musiala 19' Havertz 45+1' (pen.) Füllkrug 68' Can 90+3'; Rüdiger 87' (o.g.)]
  Germany:    Neuer - Kimmich, Rüdiger, Tah [Y], Mittelstädt – Andrich [Y] (46' Groß),
              Kroos (80' Can) – Musiala (74' Müller), Gündogan,
              Wirtz (63' Sane) – Havertz (63' Füllkrug).
  Scotland:   Gunn – Porteous [R 44'], Hendry, Tierney (78' McKenna) – Ralston [Y],
              McTominay, McGregor (67' Gilmour), Robertson – Christie (82' Shankland),
              Adams (46' Hanley), McGinn (67' McLean).

```

changed to =>

```
(1) 
Fri, Jun 14 21:00    @  München Fußball Arena, München
Germany   (3) 5   Wirtz 10' Musiala 19' Havertz 45+1' (pen.) Füllkrug 68' Can 90+3'  
Scotland  (0) 1   Rüdiger 87' (o.g.)

  Germany:  Neuer - Kimmich, Rüdiger, Tah [Y], Mittelstädt – Andrich [Y] (46' Groß),
    Kroos (80' Can) – Musiala (74' Müller), Gündogan,
    Wirtz (63' Sane) – Havertz (63' Füllkrug).
  Scotland:   Gunn – Porteous [R 44'], Hendry, Tierney (78' McKenna) – Ralston [Y],
    McTominay, McGregor (67' Gilmour), Robertson – Christie (82' Shankland),
    Adams (46' Hanley), McGinn (67' McLean).

(2) Sat, Jun 15 15:00  @ Köln Stadion, Köln  
Hungary       (0) 1   Varga 66'    
Switzerland   (2) 3   Duah 12' Aebischer 45' Embolo 90+3'
           
  Hungary:     Gulacsi – Lang (46' Bolla [Y]), Orban, Szalai [Y] (79' Dardai) – Fiola,
     Nagy (67' Kleinheisler), Schäfer, Kerkez (79' Adam) – Sallai, Varga, Szoboszlai.
  Switzerland: Sommer – Schär, Akanji, Rodriguez – Widmer [Y] (68' Stergiou), Xhaka,
     Freuler [Y] (86' Sierro), Aebischer – Ndoye (86' Rieder), Duah (68' Amdouni),
    Vargas (73' Embolo).
```

or

```
  Fri Jun/14 21:00 @ München Fußball Arena, München 
   (1) Germany v  Scotland 5-1 (3-0)
       Wirtz 10' Musiala 19' Havertz 45+1' (pen.) Füllkrug 68' Can 90+3'; Rüdiger 87' (o.g.)

  Germany:    Neuer - Kimmich, Rüdiger, Tah [Y], Mittelstädt – Andrich [Y] (46' Groß),
              Kroos (80' Can) – Musiala (74' Müller), Gündogan,
              Wirtz (63' Sane) – Havertz (63' Füllkrug).
  Scotland:   Gunn – Porteous [R 44'], Hendry, Tierney (78' McKenna) – Ralston [Y],
              McTominay, McGregor (67' Gilmour), Robertson – Christie (82' Shankland),
              Adams (46' Hanley), McGinn (67' McLean).


  Fri Jun 14 21:00   @ München Fußball Arena, München 
   (1) Germany v Scotland   5-1 (3-0)
    
  Germany:    Neuer - Kimmich, Rüdiger, Tah [Y], Mittelstädt – Andrich [Y] (46' Groß),
              Kroos (80' Can) – Musiala (74' Müller), Gündogan,
              Wirtz (63' Sane) – Havertz (63' Füllkrug).
    Scorers: Wirtz 10' Musiala 19' Havertz 45+1' (pen.) Füllkrug 68' Can 90+3' 
  Scotland:   Gunn – Porteous [R 44'], Hendry, Tierney (78' McKenna) – Ralston [Y],
              McTominay, McGregor (67' Gilmour), Robertson – Christie (82' Shankland),
              Adams (46' Hanley), McGinn (67' McLean).
    Scorer: Rüdiger 87' (o.g.) 




Fri, Jun 14 21:00  (1)  Germany v Scotland  5-1 (3-0)   @ München Fußball Arena, München
       
Fri, Jun 14 21:00  @ München Fußball Arena, München
  (1)  Germany v Scotland  5-1 (3-0)   

```



## more score formats

```
(48) Sat Jul/6 18:00   England      5-3 pen. 1-1 a.e.t. (1-1, 0-0)  Switzerland    @ Düsseldorf Arena, Düsseldorf    # Winner Match 40 - Winner Match 38
```

change a.e.t. to =>   - why? why not?

```
(48) Sat Jul 6 18:00   England v Switzerland   5-3 pen. 1-1 a.e.t. (1-1, 0-0)    @ Düsseldorf Arena, Düsseldorf    


Sat Jul 6 18:00  @ Düsseldorf Arena, Düsseldorf 
  (48) England v Switzerland    (0-0, 1-1, 1-1) 5-3 pen.       

or

Sat Jul 6 18:00   @ Düsseldorf Arena, Düsseldorf 
  (48) England v Switzerland   5-3 pen. (1-1, 1-1, 0-0)     

or

Sat Jul 6 18:00   @ Düsseldorf Arena, Düsseldorf 
  (48) England  5-3 pen. (1-1, 1-1, 0-0)  Switzerland        

or

Sat Jul 6   @ Düsseldorf Arena, Düsseldorf 
  (48) England v Switzerland    (0-0, 1-1, 1-1) 5-3 pen.    (18h00)        
```
