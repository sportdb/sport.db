## blocks/hangs union regex - why?
XXX_OLD_PLAYER_WITH_MINUTE_RE = %r{
#### (player) name  (see prop_name)
####
   (?<player_with_minute>
                    ## \b
                    ## always use begin of line - why? why not?
                    ##    spaces eaten-up and pos will advance for match
                     # ^   ## start of match buffer (use \A) - why? why not?
                      \G     ## \G blocks in union of regex??
                   (?<name>
                      \p{L}+       
                        \.?    ## optional dot
                      (?: 
                          [ ]?    # only single spaces allowed inline!!!
                          (?:
                              (?:
                                (?<=\p{L})   ## use lookbehind
                                 [/'-]   ## must be surrounded by letters
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
                          )+
                     )*
                   )
#### spaces
     (?: [ ]+)
#### minute (see above)
#####   use MINUTE_RE.source or such - for inline (reference) use? do not copy
     (?<minute>
       (?<=[ (])	 # positive lookbehind for space or opening ( e.g. (61') required
                     #    todo - add more lookbehinds e.g.  ,) etc. - why? why not?
           (?: 
              (?<value>\d{1,3})      ## constrain numbers to 0 to 999!!!
                   (?: \+
                     (?<value2>\d{1,3})   
                   )?
               |
              (?<value> \?{2} | _{2} )  ## add support for n/a (not/available)
           )           
        '     ## must have minute marker!!!!
     )
   )
}ix


##  blocks in regex union - not sure why, maybe single space rule is weird
##    see above for new formula
XXX_OLD_PROP_NAME_RE = %r{
                 (?<prop_name> \b
                   (?<name>
                      \p{L}+       
                        \.?    ## optional dot
                      (?: 
                          [ ]?    # only single spaces allowed inline!!!
                          (?:
                              (?:
                                (?<=\p{L})   ## use lookbehind
                                 [/'-]   ## must be surrounded by letters
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
                          )+
                     )*
                   )
               ## add lookahead - must be non-alphanum 
                  (?=[ ,;\]\)]|$)
                  )
}ix




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
                                (?=\p{L}|['"])      ## use lookahead        
                              )
                              ## support (inline) quoted name e.g. "Rodri" or such
                                  |
                                  (?:" \p{L}+ " )                      
                                  |   
                             (?:
                                (?<=\p{L})   ## use lookbehind
                                 ['-]   ## must be surrounded by letters
                                       ## e.g. One/Two NOT
                                       ##      One/ Two or One / Two or One /Two etc.
                                (?=\p{L})      ## use lookahead        
                              )
                                 |   
                              (?:  ## fix add flex rule for quote - allow any
                                    ##  only check for double quotes e.g. cannot follow other ' for now - why? why not?
                                    ##        allows  rodrigez 'rodri'     for example
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






