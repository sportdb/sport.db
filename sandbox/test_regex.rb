

  ATTRIB_REGEX = /^  
                   [ ]*?     # slurp leading spaces
                (?<key>[^: \]\[()\/;-]
                       [^:\]\[()\/;]{0,30}
                 )
                   [ ]*?     # slurp trailing spaces
                   :[ ]+
                (?<value>.+)
                    [ ]*?   # slurp trailing spaces
                   $
                /ix

lines = [
   " Austria:  Pentz - Posch",
   " 1. FC Köln:    Goalie ",
   "  Mainz 05:  Goalie",
   " 1. FC Mainz 05:  Goalie",
   "   Group A:",
   "Mon Jun 17 21:00  ",
   "Mon Jun/17 21:00  ",
   "(8) Mon Jun/17 21:00   ",
]


lines.each_with_index do |line,i|
  puts "==> #{i+1}/#{lines.size} - >#{line}<"
  m=ATTRIB_REGEX.match( line )
  if m
    pp m
    puts "bingo"
    pp m[:key]
    pp m[:value]
  else
    puts " no key/value in:"
    puts line
  end
end

puts "bye"