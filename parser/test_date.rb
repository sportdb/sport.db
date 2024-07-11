require_relative 'parser'


m=DATE_RE.match( "Jun 12 2013" )
pp m
pp m[:date]
pp m.named_captures

m=DATE_RE.match( "Fri Aug/9" )
pp m
pp m[:date]
pp m.named_captures


# m=DATE_RE.match( "Jul 29" )
m=DATE_RE.match( "[Jul 29]" )
pp m
pp m[:date]
pp m.named_captures


m=RE.match( "Jul 29" )
pp m
pp m[:date]
pp m.named_captures



puts "bye"