###
##  team prop mode e.g.
##
##
##    Fri Jun 14 21:00  @ München Fußball Arena, München        
##  (1)  Germany  v  Scotland   5-1 (3-0)     
##  Wirtz 10' Musiala 19' Havertz 45+1' (pen.) Füllkrug 68' Can 90+3'; Rüdiger 87' (o.g.)
## 
## Germany:    Neuer - Kimmich, Rüdiger, Tah [Y], Mittelstädt - Andrich [Y] (Groß 46'),
##       Kroos (Can 80') - Musiala (Müller 74'), Gündogan, Wirtz (Sane 63') - 
##       Havertz (Füllkrug 63')
## Scotland:   Gunn - Porteous [R 44'], Hendry, Tierney (McKenna 78') - Ralston [Y],
##       McTominay, McGregor (Gilmour 67'), Robertson - Christie (Shankland 82'),
##       Adams (Hanley 46'), McGinn (McLean 67')


module SportDb
class Lexer


## name different from text (does NOT allow number in name/text)
PROP_NAME_RE = %r{
                 (?<prop_name> 
                      \b
                   (?<name>
                      \p{L}+       
                        \.?    ## optional dot
                          (?:
                             ## rule for space; only one single space allowed inline!!!
                              (?:
                                (?<![ ])  ## use negative lookbehind                             
                                  [ ] 
                                (?=\p{L}|')      ## use lookahead        
                              )
                                  |                         
                             (?:
                                (?<=\p{L})   ## use lookbehind
                                 ['-]   ## must be surrounded by letters
                                       ## e.g. One/Two NOT
                                       ##      One/ Two or One / Two or One /Two etc.
                                (?=\p{L})      ## use lookahead        
                              )
                                 |   
                              (?:
                                (?<=[ ])   ## use lookbehind  -- add letter (plus dot) or such - why? why not?
                                 [']   ## must be surrounded by leading space and
                                       ## traling letters  (e.g. UDI 'Beter Bed)
                                (?=\p{L})      ## use lookahead        
                              )   
                                 |
                              (?:
                                (?<=\p{L})   ## use lookbehind
                                 [']   ## must be surrounded by leading letter and
                                       ## trailing space PLUS letter  (e.g. UDI' Beter Bed)
                                (?=[ ]\p{L})      ## use lookahead (space WITH letter         
                              )   
                                 |   ## standard case with letter(s) and optinal dot
                              (?: \p{L}+
                                    \.?  ## optional dot
                              )
                          )*
                    )
               ## add lookahead - must be non-alphanum 
                  (?=[ ,;\]\)]|$)
                  )
}ix




##############
#  add support for props/ attributes e.g.
# 
#    Germany:    Neuer - Kimmich, Rüdiger, Tah [Y], Mittelstädt - Andrich [Y] (46' Groß),
#      Kroos (80' Can) - Musiala (74' Müller), Gündogan,
#      Wirtz (63' Sane) - Havertz (63' Füllkrug)
#    Scotland:   Gunn - Porteous [R 44'], Hendry, Tierney (78' McKenna) - Ralston [Y],
#      McTominay, McGregor (67' Gilmour), Robertson - Christie (82' Shankland),
#      Adams (46' Hanley), McGinn (67' McLean)
#
## note:  colon (:) MUST be followed by one (or more) spaces
##      make sure mon feb 12 18:10 will not match
##        allow 1. FC Köln etc.
##               Mainz 05:
##           limit to 30 chars max
##          only allow  chars incl. intl but (NOT ()[]/;)
##
## todo/fix:
##   check if   St. Pölten     works; with starting St. ???
##
##  note - use special \G - Matches first matching position !!!!


  PROP_KEY_RE = %r{ 
                    ^     # note - MUST start line; leading spaces optional (eat-up)
                    [ ]*  
                 (?<prop_key>
                   (?<key>
                       (?:\p{L}+
                           |
                           \d+  # check for num lookahead (MUST be space or dot)
                        ## MUST be followed by (optional dot) and
                        ##                      required space !!!
                        ## MUST be follow by a to z!!!!
                         \.?     ## optional dot
                         [ ]?   ## make space optional too  - why? why not?
                             ##  yes - eg. 1st, 2nd, 5th etc.
                         \p{L}+
                        )
                        [\d\p{L}'/° -]*?   ## allow almost anyting 
                                          ## fix - add negative lookahead 
                                          ##         no space and dash etc.
                                          ##    only allowed "inline" not at the end
                                          ## must end with latter or digit!
                   )
                    [ ]*?     # slurp trailing spaces
                     :
                    (?=[ ]+)  ## possitive lookahead (must be followed by space!!)
                   )
                 }ix



################
##     todo/check - use token for card short cuts?
##                if m[:name] == 'Y'
##                 [:YELLOW_CARD, m[:name]]
##               elsif m[:name] == 'R'
##                 [:RED_CARD, m[:name]]
##           -  [Y], [R], [Y/R]  Yellow-Red Card 
##    check if minutes possible inside [Y 46'] 
##     add [c] for captain too



### simple prop key for inline use e.g.
###    Coach:  or Trainer:  or ...  add more here later

  PROP_KEY_INLINE_RE = %r{ 
                    \b  
                 (?<prop_key>    ## note: use prop_key (NOT prop_key_inline or such)
                   (?<key>
                       \p{L}+
                   )
                    ## note - NO spaces allowed for key for now!!! 
                     :
                    (?=[ ]+)  ## possitive lookahead (must be followed by space!!)
                   )
                 }ix

                 

PROP_BASICS_RE = %r{
    (?<spaces> [ ]{2,}) |
    (?<space>  [ ])
        |
    (?<sym>  
        [;,\(\)\[\]-] 
    )   
}ix

PROP_RE = Regexp.union(
   PROP_BASICS_RE, 
   MINUTE_RE,
   PROP_KEY_INLINE_RE,
   PROP_NAME_RE,
   ## todo/fix - add ANY_RE here too!!!
)

## note - no inline keys possible
##         todo/fix - use custom (limited) prop basics too
PROP_CARDS_RE =  Regexp.union(
   PROP_BASICS_RE, 
   MINUTE_RE,
   PROP_NAME_RE,
   ## todo/fix - add ANY_RE here too!!!
) 

    
end  # class Lexer
end  # module SportDb