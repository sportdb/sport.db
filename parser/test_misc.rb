require_relative 'parser'



##  make -1 possible  (e.g. check ukraine dnepro-1 !!!)

lines = [
"1. FC Köln - Schalke 04     ",
"Brighton & Hove Albion F.C. vs Arsenal F.C.   ",
"SC Dnipro-1     27+4' 12'  ",
"1 FC   ",
"1. FC   ",
"1860 Munich      ",
"1860 München v München 1860 vs TSV 1860 München    Fri Jun 12 2012 ",
"America - RS  ",
"Team 4-3  ",
"Team Fri Jun 12 2012   ",  ## note - separate date by two spaces from team!
"Team, Fri Jun 12 2012   ",  ## note - separate date by two spaces from team!
"Team [Fri Jun 12 2012]   ",
"[Fri Jun 12 2012] Team   ",
"Fri Jun 12 2012 Team   ",
"Cote d'Ivoire 12'",
]


lines.each do |line|
  puts "==> >#{line}<"
  tokens = tokenize( line )
pp tokens
end



lines = [
 "1. FC Köln   Köln 2   Fortuna Düsseldorf  -  Rot-Weiss Essen 18:30   11-12    vs   München 1860  3-2  12.30  @ Waldstadion, Frankfurt ",
 " 18.30   21:30  Brighton & Hove Albion F.C.  0-0  Arsenal F.C.   3-2 (1-0)",
 "  [-; Kane 21]",
 "- ; Kane 21' 27+4'",
 "Côte d'Ivoire 21'  ",
 " $$$$   !!!   §§§  "
]


lines.each do |line|
   puts
   puts ">#{line}<"
   tokens = tokenize( line )
   pp tokens
end


puts "bye"