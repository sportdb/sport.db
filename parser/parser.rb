####
# try a (simple) tokenizer/parser with regex

## note - match line-by-line
#            avoid massive backtracking by definition
#             that is, making it impossible

## vs - allow v, vs  - add point vs. too - why? why not?
###  (short for versus! - that is, against)

## sym(bols) -
##  text - change text to name - why? why not?

## NOT_SYM


##
#  todo
#   add timezone - why? why not?
#   e.g.  (UTC-3)  or (CEST-2)
#    or    
#        must have +1/-1 offsets!!!
#         for detection 


##
##  add (match) status !!!
##
##   canceled|cancelled
##   awarded|award.  etc.
##   postponed  etc.




require_relative 'parser-score'
require_relative 'parser-date'



BASICS_RE = %r{
    ## e.g. 18.30 (or 18:30 or 18h30)
    (?<time>  \b
              \d{1,2}
              (?: :|\.|h )
               \d{2}
              \b
    )     
       |
    ## e.g. (51) or (1) etc.  - limit digits of number???
    (?<num> \(\d+\) )    
       |
    (?<vs>   
       (?<=[ ])	# Positive lookbehind for space	
       (?: 
          vs\.?|   ## allow optional dot (eg. vs. v.)
          v\.?|
          -
       )   # not bigger match first e.g. vs than v etc.
       (?=[ ])   # positive lookahead for space
    ) 
       | 
    (?<none>
       (?<=[ \[]|^)	 # Positive lookbehind for space or [	
           -
        (?=[ ]*;)   # positive lookahead for space
    )
       |
    (?<spaces> [ ]{2,}) |
    (?<space>  [ ]) 
        |
    (?<sym>[;,@|\[\]]) 
}ix


MINUTE_RE = %r{
     (?<minute>
       (?<=[ ])	 # Positive lookbehind for space required
        \d{1,3}    ## constrain numbers to 0 to 999!!!
        (?: \+
            \d{1,3}
        )? 	
        '       ## must have minute marker!!!!
     )
}ix


##   goal types
# (pen.) or (pen) or (p.) or (p)  
## (o.g.) or (og)
GOAL_PEN_RE = %r{
   (?<pen> \(  
           (?:pen|p)\.? 
           \)
    )
}ix
GOAL_OG_RE = %r{
   (?<og> \(  
          (?:og|o\.g\.) 
          \)
   )
}ix


##  note - do NOT allow single alpha text for now
##   add later??      A - B    C - D  - why?        
## opt 1) one alpha
## (?<text_i> [a-z])    # only allow single letter text (not numbers!!)  
    
## opt 2) more than one alphanum


### allow special case - starting text with number e.g.
##    number must be follow by space or dot ()
# 1 FC   ##    allow 1-FC or 1FC   - why? why not?
# 1. FC
# 1.FC   - XXXX  - not allowed for now, parse error
# 1FC    - XXXX  - now allowed for now, parse error
# 1890 Munich
#


##
#  allow Cote'd Ivoir or such
##   e.g. add '


TEXT_RE = %r{
    ## must start with alpha (allow unicode letters!!)      
    (?<text>    
           ## positive lookbehind
            (?<=[ ,;@|\[\]]
                 |^
            )
            (?:  # opt 1 - start with alpha
                 \p{L}+    ## all unicode letters (e.g. [a-z])
                   |
                  # opt 2 - start with num!! - allow special case (e.g. 1. FC) 
                 \d+  # check for num lookahead (MUST be space or dot)
                  ## MUST be followed by (optional dot) and
                  ##                      required space !!!
                  ## MUST be follow by a to z!!!!
                   \.?     ## optional dot
                   [ ]   ## make space optional too - why? why not?
                   \p{L}+                
               )
        
              (?:(?:  (?:[ ]
                     (?!vs?\.?[ ])    ## note - exclude (v[ ]/vs[ ]/v.[ ]/vs.[ ])
                       )  
                      |     # only single spaces allowed inline!!!
                     [-]                                              
                  )?
                (?:
                  \p{L} |
                  [&'] |
                 (?:
                   \d+ 
                   (?![.:h'/+-])   ## negative lookahead for numbers
                 )|  
                 \.     # check for lookahead (NOT a number!!!)
               )  
              )*  ## must NOT end with space or dash(-)
              ##  todo/fix - possible in regex here
              ##     only end in alphanum a-z0-9 (not dot or & ???)

 ## add lookahead/lookbehind
 ##    must be space!!! 
 ##   (or comma or  start/end of string)
 ##   kind of \b !!!
            )   
 
            ## positive lookahead
            (?=[ ,;@|\[\]]
                 |$
            )
}ix




RE = Regexp.union( DURATION_RE,  # note - duration MUST match before date
                    DATE_RE,
                    SCORE_RE,
                    BASICS_RE, MINUTE_RE,
                    GOAL_OG_RE, GOAL_PEN_RE,
                     TEXT_RE )


def log( msg )
   ## append msg to ./logs.txt  
   ##     use ./errors.txt - why? why not?
   File.open( './logs.txt', 'a:utf-8' ) do |f|
     f.write( msg )
     f.write( "\n" ) 
   end
end


def tokenize( line, debug: false )
  tokens = []
  puts ">#{line}<"    if debug

  pos = 0
  ## track last offsets - to report error on no match 
  ##   or no match in end of string
  offsets = [0,0]
  m = nil

  while m = RE.match( line, pos )
    if debug
      pp m
      puts "pos: #{pos}"  
    end
    offsets = [m.begin(0), m.end(0)]

    if offsets[0] != pos
      ## match NOT starting at start/begin position!!!
      ##  report parse error!!!
      msg =  "!! WARN - parse error - skipping >#{line[pos..(offsets[0]-1)]}< in line >#{line}<"
      puts msg
      log( msg )
    end

    ##
    ## todo/fix - also check if possible
    ##   if no match but not yet end off string!!!!
    ##    report skipped text run too!!!

    pos = offsets[1]

    pp offsets   if debug

    t = if m[:space]
           ## skip space
           nil
        elsif m[:spaces]
           ## skip spaces
           nil
        elsif m[:text] 
          [:text, m[:text]]   ## keep pos - why? why not?
        elsif m[:date]
          [:date, m[:date]]
        elsif m[:time]
          [:time, m[:time]]
        elsif m[:duration]
          [:duration, m[:duration]]
        elsif m[:num]
          [:num, m[:num]]
        elsif m[:score]
          [:score, m[:score]]
        elsif m[:minute]
          [:minute, m[:minute]]
        elsif m[:og]
          [:og, m[:og]]
        elsif m[:pen]
          [:pen, m[:pen]]
        elsif m[:vs]
          [:vs, m[:vs]]
        elsif m[:none]
          [:none, m[:none]]
        elsif m[:sym]
          sym = m[:sym]
          ## return symbols "inline" as is - why? why not?
          case sym
          when ',' then [:',']
          when ';' then [:';']
          when '@' then [:'@']
          when '|' then [:'|']   
          else
            nil  ## ignore others (e.g. brackets [])
          end
        else
          ## report error 
          nil
        end

    tokens << t    if t    

    if debug
      print ">"
      print "*" * pos
      puts "#{line[pos..-1]}<"
    end
  end

  ## check if no match in end of string
  if offsets[1] != line.size
    msg =  "!! WARN - parse error - skipping >#{line[offsets[1]..-1]}< in line >#{line}<"
    puts msg
    log( msg )
  end


  tokens
end
