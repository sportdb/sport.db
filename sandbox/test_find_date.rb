require 'date/formats'


start = Date.new( 2021, 6, 1 )
  
# extract date from line
    # and return it
    # NB: side effect - removes date from line string
line = "xxx"
date =   DateFormats.find!( line, start: start )
puts line
pp date

line = "yada yada  Jul/10   yada yada"
date =   DateFormats.find!( line, start: start )
puts line
pp date   ## note: returns Date (NOT DateTime)

line = "yada yada  Jul/10 21:00  yada yada"
date =   DateFormats.find!( line, start: start )
puts line
pp date  ## note: returns DateTime (NOT Date)

line = "21.00  Liverpool FC              4-1 (4-0)  Norwich City FC"
date =   DateFormats.find!( line, start: start )
puts line
pp date

puts "bye"
