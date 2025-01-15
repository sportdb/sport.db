###
#  to run use
#     ruby test/test_eng.rb


require_relative 'helper'

class TestEng < Minitest::Test


def test_tokenize


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

tokens = []
lines.each_with_index do |line,i|
  puts
  puts "line #{i+1}/#{lines.size}  >#{line}<"
  t = tokenize( line )
  pp t
  tokens << t
end

pp tokens

exp = [
[[:text, "Matchday 1"]],
[[:date, "Fri Aug/11"]],
[[:time, "20.00"], [:text, "Burnley FC"], [:score, "0-3 (0-2)"], [:text, "Manchester City FC"]],
[[:date, "Sat Aug/12"]],
[[:time, "13.00"], [:text, "Arsenal FC"], [:score, "2-1 (2-0)"], [:text, "Nottingham Forest FC"]],
[[:time, "15.00"], [:text, "AFC Bournemouth"], [:score, "1-1 (0-0)"], [:text, "West Ham United FC"]],
[[:text, "Brighton & Hove Albion FC"], [:score, "4-1 (1-0)"], [:text, "Luton Town FC"]],
[[:text, "Everton FC"], [:score, "0-1 (0-0)"], [:text, "Fulham FC"]],
[[:text, "Sheffield United FC"], [:score, "0-1 (0-0)"], [:text, "Crystal Palace FC"]],
[[:time, "17.30"], [:text, "Newcastle United FC"], [:score, "5-1 (2-1)"], [:text, "Aston Villa FC"]],
[[:date, "Sun Aug/13"]],
[[:time, "14.00"], [:text, "Brentford FC"], [:score, "2-2 (2-2)"], [:text, "Tottenham Hotspur FC"]],
[[:time, "16.30"], [:text, "Chelsea FC"], [:score, "1-1 (1-1)"], [:text, "Liverpool FC"]],
[[:date, "Mon Aug/14"]],
[[:time, "20.00"], [:text, "Manchester United FC"], [:score, "1-0 (0-0)"], [:text, "Wolverhampton Wanderers FC"]]]


assert_equal exp, tokens

end
end   # class TestEng 

