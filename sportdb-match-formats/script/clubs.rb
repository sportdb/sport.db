
require 'sportdb/config'

COUNTRIES = SportDb::Import.config.countries
LEAGUES   = SportDb::Import.config.leagues
CLUBS     = SportDb::Import.config.clubs


def print_clubs( txt )
  errors = 0
  txt.each_line do |line|
      line = line.strip
      next if line.empty?

      club_name = line
      clubs = CLUBS.match( club_name )
      if clubs.nil?
        puts "!!    #{club_name}"
        errors += 1
      elsif clubs.size == 1
        club = clubs[0]
        print "#{club_name}"
        print " › #{club.country.fifa}"
        print "\n"
      else
        puts "x#{clubs.size}    #{club_name}"
        errors += 1
      end
  end
  puts "#{errors} error(s)"
end



txt= <<TXT
    Manchester United
    Basel
    CSKA Moscow
    Benfica
    Paris Saint-Germain
    Bayern München
    Celtic
    Anderlecht
    Roma
    Chelsea
    Atlético Madrid
    Qarabağ
    Barcelona
    Juventus
    Sporting CP
    Olympiacos
    Liverpool
    Sevilla
    Spartak Moscow
    Maribor
    Manchester City
    Shakhtar Donetsk
    Napoli
    Feyenoord
    Beşiktaş
    Porto
    RB Leipzig
    Monaco
    Tottenham Hotspur
    Real Madrid
    Borussia Dortmund
    APOEL
TXT

print_clubs( txt )
