

## check if \w  (word) is [a-zA-Z0-9_] only
##                    important for word boundary (\b)
##                         \b == [^\w]


m = /\w+/.match( "azAZ09_" )
pp m   #=> azAZ09_

m = /\w+/.match( "äöüßÄÖÜ" )
pp m        #=> nil

m = /\w+/.match( "eéèe" )
pp m    #=> e

m = /\b\w+\b/.match( "eéèe" )
pp m    #=> nil 

m = /\b\p{L}+\b/.match( "eéèe" )
pp m    #=> eéèe

m = /\w+/.match( "éè" )
pp m    #=> nil


m = /\w+/.match( "äöüßÄÖÜ" )
pp m        #=> nil

m = /\b\p{L}+\b/.match( "   äöüßÄÖÜ    " )
pp m   #=> äöüßÄÖÜ    

## note -  dash (-), dot (.) or
##          () or [] are word boundaries
m = /\b\p{L}+\b/.match( "   -äöüßÄÖÜ-    " )
pp m   #=> äöüßÄÖÜ    
m = /\b\p{L}+\b/.match( "   .äöüßÄÖÜ.    " )
pp m   #=> äöüßÄÖÜ    
m = /\b\p{L}+\b/.match( "   (äöüßÄÖÜ)    " )
pp m   #=> äöüßÄÖÜ    
m = /\b\p{L}+\b/.match( "   [äöüßÄÖÜ]    " )
pp m   #=> äöüßÄÖÜ    

##  note -  underscore (_) is NOT a word boundary!!!!
##             and all digits are NOT a word boundary
m = /\b\p{L}+\b/.match( "   _äöüßÄÖÜ_    " )
pp m   #=> nil
m = /\b\p{L}+\b/.match( "   äöüßÄÖÜ_abc    " )
pp m   #=> nil
m = /\b\p{L}+\b/.match( "   12äöüßÄÖÜ45    " )
pp m   #=> nil
m = /\b\p{L}+\b/.match( "   12äöüßÄÖÜ    " )
pp m   #=> nil
m = /\b\p{L}+\b/.match( "   äöüß123ÄÖÜ    " )
pp m   #=> nil

m = /\b\w+\b/.match( "   _abcABC123_    " )
pp m   #=> _abcABC123_



m = /\b\p{L}{3}\b/.match( "   äöüß ÄÖÜ    " )
pp m   #=> ÄÖÜ 

m = /\b\w{3}\b/.match( "   äüß ÖaÜ ÜabcÖ Öabc  " )
pp m    #=> nil



### check word boundary
##
##  note - word boundary after dot (. that is, non-word) NOT working
##   - space AFTER dot (.) is not a word boundary!!!!
##       MUSt use negative word boundary (\B)
 
m = /\bab\.\b/.match( "  aab   ab.     ")
pp m   #=> nil     

## another letter or digits IS!!!  
##   (word boundary gets negated on non-alphanum chars!!!)
m = /\bab\.\b/.match( "  aab   ab.c     ")
pp m   #=> ab.


m = /\bab\.\B/.match( "  aab   ab.     ")
pp m   #=> ab.   

m = /\bab\.\B/.match( "  aab   ab.c     ")
pp m   #=> nil   

m = /\bab\.\B/.match( "  aab   ab.1     ")
pp m   #=> nil   

m = /\bab\.\B/.match( "  aab   ab.$     ")
pp m   #=> ab.  

## check end of line (for word boundary)
m = /\bab\.\b/.match( "  aab   ab.")   
pp m   #=> nil     

m = /\bab\.\B/.match( "  aab   ab.")
pp m   #=> ab.     



m = /\bab\.(?=[^\w])/.match( "  aab   ab.     ")
pp m   #=> ab.    

## check end of line
m = /\bab\.(?=[^\w])/.match( "  aab   ab.")
pp m   #=> nil    

m = /\bab\.(?=[^\w]|$)/.match( "  aab   ab.")
pp m   #=> ab.    - MUST add end of line anchor!!!!   

## check underscore
m = /\bab\.(?=[^\w])/.match( "  aab   ab._")
pp m   #=> nil    

m = /\bab\.(?=[^\w])/.match( "  aab   ab.a")
pp m   #=> nil    

m = /\bab\.(?=[^\w])/.match( "  aab   ab.$")
pp m   #=> ab.   



m = /\bab\b/.match( " aaab   ab     ")
pp m   #=> "ab"


## check dash (-) inline allowed only pattern

RE = /\b
        \w[\w-]*\w
      \b  
        /x 

m =  RE.match( "a" )
pp m   #=>  nil    -  must be more than one letter!!!

m =  RE.match( "ab" )
pp m   #=>  ab   

m =  RE.match( "ab-" )
pp m   #=>  ab  -   dash (-) is valid word boundary!!!!!"

RE2 = /\b
        \w[\w-]*\w
        (?=[ ]|$)     ## use space lookahead or end of line|string  
        /x 

m =  RE2.match( "ab-" )
pp m   #=>  nil

m =  RE2.match( "ab-cd" )
pp m   #=>  ab-cd 




## nfa regex-engine
##   matching first in order (not longest)
##    order strings by size e.g. Monday|Mon|Mo etc.


m = /foo|foobar/.match( 'foobar')
#=> #<MatchData "foo">  !!!
pp m

m = /Mon|Monday/.match( 'Monday' )
#=> #<MatchData "Mon">  !!!!
pp m

m = /Mo|Mon|Monday/.match( 'Monday' )
#=> #<MatchData "Mo">  !!!!
pp m

m = /Monday|Mon|Mo/.match( 'Monday' )
#=> #<MatchData "Monday">   - bingo!!!!
pp m



puts "bye"