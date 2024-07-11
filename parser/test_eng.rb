require_relative 'parser'


eng =<<TXT
Matchday 1
[Fri Aug/11]
  20.00  Burnley FC               0-3 (0-2)  Manchester City FC
[Sat Aug/12]
  13.00  Arsenal FC               2-1 (2-0)  Nottingham Forest FC
  15.00  AFC Bournemouth          1-1 (0-0)  West Ham United FC
         Brighton & Hove Albion FC  4-1 (1-0)  Luton Town FC
         Everton FC               0-1 (0-0)  Fulham FC
         Sheffield United FC      0-1 (0-0)  Crystal Palace FC
  17.30  Newcastle United FC      5-1 (2-1)  Aston Villa FC
[Sun Aug/13]
  14.00  Brentford FC             2-2 (2-2)  Tottenham Hotspur FC
  16.30  Chelsea FC               1-1 (1-1)  Liverpool FC
[Mon Aug/14]
  20.00  Manchester United FC     1-0 (0-0)  Wolverhampton Wanderers FC
TXT

lines = eng.split( "\n" )
pp lines

lines.each_with_index do |line,i|
  puts
  puts "line #{i+1}/#{lines.size}  >#{line}<"
  tokens = tokenize( line )
  pp tokens
end


puts "bye"
