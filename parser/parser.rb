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
#    add date duration (date range??)
#     used for matchday defs e.g. matchday 1  |
#     allow +-
#
#  match date duration (before date)



SCORE_RE = %r{
    (?<score>  
       ([0-9]+-[0-9]+)
       ([ ]+             ## require space?
        \([0-9]+-[0-9]+
        \)
       )?
    ) 
}ix

def build_names( txt )
  lines = [] # array of lines (with words)

  txt.each_line do |line|
    line = line.strip

    next if line.empty?
    next if line.start_with?( '#' )   ## skip comments too

    ## strip inline (until end-of-line) comments too
    ##   e.g. Janvier  Janv  Jan  ## check janv in use??
    ##   =>   Janvier  Janv  Jan

    line = line.sub( /#.*/, '' ).strip
    ## pp line

    values = line.split( /[ \t]+/ )
    ## pp values

    ## todo/fix -- add check for duplicates
    lines << values
  end
  lines

  ## join all words together into a single string e.g.
  ##   January|Jan|February|Feb|March|Mar|April|Apr|May|June|Jun|...
  lines.map { |line| line.join('|') }.join('|')
end # method parse



MONTH_NAMES = build_names( <<TXT )
January    Jan
February   Feb
March      Mar
April      Apr
May
June       Jun
July       Jul
August     Aug
September  Sept  Sep
October    Oct
November   Nov
December   Dec
TXT

DAY_NAMES = build_names( <<TXT )
Monday                   Mon  Mo
Tuesday            Tues  Tue  Tu
Wednesday                Wed  We
Thursday    Thurs  Thur  Thu  Th
Friday                   Fri  Fr
Saturday                 Sat  Sa
Sunday                   Sun  Su
TXT



pp MONTH_NAMES 
pp  DAY_NAMES 

#=>
# "January|Jan|February|Feb|March|Mar|April|Apr|May|June|Jun|
#  July|Jul|August|Aug|September|Sept|Sep|October|Oct|
#  November|Nov|December|Dec"
#
# "Monday|Mon|Mo|Tuesday|Tues|Tue|Tu|Wednesday|Wed|We|
#  Thursday|Thurs|Thur|Thu|Th|Friday|Fri|Fr|
#  Saturday|Sat|Sa|Sunday|Sun|Su"



## todo - add more date variants !!!!

# e.g. Fri Aug/9  or Fri Aug 9
DATE_RE = /\b
(?<date>
     ((?<day_name>#{DAY_NAMES})
        \s
     )?    ## optional day name
     (?<month_name>#{MONTH_NAMES})
        (?: \/|\s )
     (?<day>\d{1,2})
     ( \s
        (?<year>\d{4})
     )?   ## optional year
)
\b/ix




BASICS_RE = %r{
    (?<time>   [0-9]+(:|\.)[0-9]+)       ## e.g. 18.30 (or 18:30)
       |
    (?<num> \([0-9]+\) )    ## e.g. (51) or (1) etc.
       |
    (?<vs>   
       (?<=[ ])	# Positive lookbehind for space	
       (vs|v|-)   # not bigger match first e.g. vs than v etc.
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
       (?<=[ ])	 # Positive lookbehind for space
        [0-9]{1,3}    ## constrain numbers to 0 to 999!!!
        (\+
         [0-9]{1,3}
        )? 	
        '       ## must have minute marker!!!!
     )
}ix


# (pen.) or (pen) or (p.) or (p)  
## (o.g.) or (og)
##  rename to goal type or such - why? why not?
GOAL_RE = %r{
   (?<goal>
    \(
     (
       ((pen|p)\.?)
         |
       (og|o\.g\.)
      )
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
            (  # opt 1 - start with alpha
                 \p{L}+    ## all unicode letters (e.g. [a-z])
                   |
                  # opt 2 - start with num!! - allow special case (e.g. 1. FC) 
                 [0-9]+  # check for num lookahead (MUST be space or dot)
                  ## MUST be followed by (optional dot) and
                  ##                      required space !!!
                  ## MUST be follow by a to z!!!!
                   \.?     ## optional dot
                   [ ]   ## make space optional too - why? why not?
                   \p{L}+                
               )
        
              ((  ([ ]
                   (?!vs?[ ]) ## note - exclude (v[ ]/vs[ ])
                    )  
                   |     # only single spaces allowed inline!!!
                  [-]                                              
               )?
               (
                  \p{L} |
                  [&'] |
                 (
                   [0-9]+ 
                   (?![.:'+-])   ## negative lookahead
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




RE = Regexp.union( DATE_RE,
                    SCORE_RE,
                    BASICS_RE, MINUTE_RE,
                    GOAL_RE,
                     TEXT_RE )



def tokenize( line, debug: false )
  tokens = []
  puts ">#{line}<"    if debug

  pos = 0
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
      puts "!! WARN - parse error - skipping >#{line[pos..(offsets[0]-1)]}<"
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
        elsif m[:num]
          [:num, m[:num]]
        elsif m[:score]
          [:score, m[:score]]
        elsif m[:minute]
          [:minute, m[:minute]]
        elsif m[:goal]
          [:goal, m[:goal]]
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
  tokens
end
