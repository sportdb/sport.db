

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