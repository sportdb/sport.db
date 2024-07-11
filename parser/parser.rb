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

BASICS_RE = %r{
    (?<score>  [0-9]+-[0-9]+) 
       |
    (?<time>   [0-9]+(:|\.)[0-9]+)       ## e.g. 18.30 (or 18:30)
       |
    (?<vs>   
       (?<=[ ])	# Positive lookbehind for space	
       (vs|v|-)   # not bigger match first e.g. vs than v etc.
       (?=[ ])   # positive lookahead for space
    ) 
       | 
    (?<spaces> [ ]{2,}) |
    (?<space>  [ ]) 
        |
    (?<sym>[;,@|\[\]]) 
}ix

# (?=X)	Positive lookahead	"Ruby"[/.(?=b)/] #=> "u"
# (?!X)	Negative lookahead	"Ruby"[/.(?!u)/] #=> "u"
# (?<=X)	Positive lookbehind	"Ruby"[/(?<=u)./] #=> "b"
# (?<!X)	Negative lookbehind	"Ruby"[/(?<!R|^)./] #=> "b"



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

=begin
TEXT2_RE = %r<
          (?<text2>
             [0-9]+  # check for num lookahead (MUST be space or dot)
              ## MUST be followed by (optional dot) and
              ##                      required space !!!
              ## MUST be follow by a to z!!!!
              (\.?     ## optional dot
                [ ]   ## make space optional too - why? why not?
               [a-z]+
              )
              (([ ]|     # only single spaces allowed inline!!!
                [-]     # check for lookbehind and ahead (NOT a space)
                        #      and lookbehind (NOT a number!!)
               )?
               (
                 [a-z&]|
                 [0-9]+|  
                 \.     # check for lookahead (NOT a number!!!)
               )  
              )* 
          )
>ix
=end

###
# (?=X)	Positive lookahead	"Ruby"[/.(?=b)/] #=> "u"
# (?!X)	Negative lookahead	"Ruby"[/.(?!u)/] #=> "u"
# (?<=X)	Positive lookbehind	"Ruby"[/(?<=u)./] #=> "b"
# (?<!X)	Negative lookbehind	"Ruby"[/(?<!R|^)./] #=> "b"
#
#  see https://idiosyncratic-ruby.com/11-regular-extremism.html


TEXT_RE = %r{
    ## must start with alpha (allow unicode letters!!)      
    (?<text>    
           ## positive lookbehind
            (?<=[ ,;@|\[\]]
                 |^
            )
            (  # opt 1 - start with alpha
                 [a-z]+
                   |
                  # opt 2 - start with num!! - allow special case (e.g. 1. FC) 
                 [0-9]+  # check for num lookahead (MUST be space or dot)
                  ## MUST be followed by (optional dot) and
                  ##                      required space !!!
                  ## MUST be follow by a to z!!!!
                   \.?     ## optional dot
                   [ ]   ## make space optional too - why? why not?
                   [a-z]+                
               )
                    
              ((  [ ]|     # only single spaces allowed inline!!!
                  [-]                                              
               )?
               (
                 [a-z&]|
                 (
                   [0-9]+ 
                   (?![.:-])   ## negative lookahead
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



re = Regexp.union( BASICS_RE, TEXT_RE )

# re = TEXT_RE 
# pp re

RE = Regexp.union( BASICS_RE, TEXT_RE )
 

##  make -1 possible  (e.g. check ukraine dnepro-1 !!!)

lines = [
"1. FC Koln    ",
"Brighton & Abilion   ",
"Schalke 04    ",
"Dnipro-1     27+4' 12'  ",
"1 FC   ",
"1. FC   ",
"1890 Munich      ",
"America - RS  ",
"Team 4-3  ",
]



lines.each do |line|
  puts "==> >#{line}<"
  pp line.match( re )
end







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
        elsif m[:time]
          [:time, m[:time]]
        elsif m[:score]
          [:score, m[:score]]
        elsif m[:vs]
          [:vs, m[:vs]]
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

lines = [
 "1. FC Koln   Koln 2   Fortuna Dusseldorf  -  Rot-Weiss Preussen 18:30   11-12    vs   Munchen 1840  3-2  12.30  @ Waldstadion, Dusseldorf ",
 " 18.30   21:30  Brighton & Abilion  0-0  Arsenal F.C. ",
]


lines.each do |line|
   puts
   puts ">#{line}<"
   tokens = tokenize( line )
   pp tokens
end


puts "bye bye"