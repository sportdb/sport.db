require_relative 'parser'



euro =<<TXT
Group A  |  Germany   Scotland     Hungary   Switzerland
Group B  |  Spain     Croatia      Italy     Albania
Group C  |  Slovenia  Denmark      Serbia    England
Group D  |  Poland    Netherlands  Austria   France
Group E  |  Belgium   Slovakia     Romania   Ukraine 
Group F  |  Turkey    Georgia      Portugal  Czech Republic


Group A:

 (1) Fri Jun/14 21:00         Germany   5-1 (3-0)  Scotland     @ München Fußball Arena, München
        [Wirtz 10' Musiala 19' Havertz 45+1' (pen.) Füllkrug 68' Can 90+3'; Rüdiger 87' (o.g.)]
 
 (2) Sat Jun/15 15:00         Hungary   1-3 (0-2)   Switzerland  @ Köln Stadion, Köln
           [Varga 66'; Duah 12' Aebischer 45' Embolo 90+3']



TXT

lines = euro.split( "\n" )
pp lines

lines.each_with_index do |line,i|
  puts
  puts "line #{i+1}/#{lines.size}  >#{line}<"
  next if line.strip.empty?
  tokens = tokenize( line )
  pp tokens
end



puts "bye"