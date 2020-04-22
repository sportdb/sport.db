require 'pp'

##  aa|bb   is it like (aa)|(bb) matching aa or bb
##                  or a(a|b)b matching aab or abb  ?
#    lets try

re = /^(?:aa|bb)
        [ ]+
     /x

pp re.match( 'aa ' )     #=> #<MatchData "aa ">
pp re.match( 'bb ' )     #=> #<MatchData "bb ">
pp re.match( 'aab ' )    #=> nil
pp re.match( 'abb ' )    #=> nil


re = /^(?:
       (?<rank>\d+)\.?
         |
        [-]
       )
       [ ]+
      /x

pp re.match( '12  ' )             #=> #<MatchData "12  " rank:"12">
pp re.match( '12.  ' )            #=> #<MatchData "12.  " rank:"12">
pp re.match( '-  ' )              #=> #<MatchData "-  " rank:nil>
pp re.match( 'xxx  ' )            #=> nil
pp re.match( '10. 1. FC Mainz' )  #=> #<MatchData "10. " rank:"10">
pp re.match( '1. FC Bayern' )     #=> #<MatchData "1. " rank:"1">
