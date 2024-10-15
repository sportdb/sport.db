

lines = [
  '1   1992/93-          Premier League,    1-premierleague',
  '1,1992/93-,Premier League,1-premierleague',
  '1  ,  1992/93-  ,  Premier League  ,   1-premierleague',
  '2   2004/05-    Division 1 =>  Championship,      2-championship',
  '3   2004/05-    Division 2 =>  League One,        3-league1',
  '4   2004/05-    Division 3 =>  League Two,        4-league2',
  '3a    Division 3 (North),    3a-division3_north',
  '3b    Division 3 (South),    3b-division3_south',
  'cup         FA Cup',
  'super       FA Community Shield',
]

lines.each do |line|
     puts "==> #{line}"
     ##  split by double (or more) spaces or by comma
     values = line.split( / [ ]*,[ ]*
                             |
                            [ ]{2,}
                          /x )
     pp values
end


lines = [
  'Division 1 =>  Championship',
  'Division 2 =>  League One',
  'Division 3 =>  League Two',
  'FA Community Shield',
]


lines.each do |line|
    puts "==> #{line}"
    ##  split by double (or more) spaces or by comma
    values = line.split( / [ ]*
                            =>
                           [ ]*
                         /x, 2 ).reverse
    pp values
end

puts "bye"