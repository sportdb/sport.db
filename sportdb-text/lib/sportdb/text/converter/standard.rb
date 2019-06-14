# encoding: utf-8


##  add to SportDb / Converter module / namespace - why? why not?


class StandardNews

###
# builtin team samples
#
#  use namespace/module
#   lets you use:
#     include StandardNews::Teams

module Teams

AT1_TEAMS_2018_19 = <<TXT
 Rapid Wien
 SCR Altach
 SV Mattersburg
 RB Salzburg
 FC Wacker Innsbruck
 Sturm Graz
 TSV Hartberg
 FC Admira Wacker
 LASK
 SKN St. Pölten
 Wolfsberger AC
 Austria Wien
TXT


AT2_TEAMS_2018_19 = <<TXT
  Vorwärts Steyr
  SV Ried
  Kapfenberger SV 1919
  Austria Wien (A)
  SC Wiener Neustadt
  FC Blau Weiß Linz
  SK Austria Klagenfurt
  Austria Lustenau
  SV Horn
  FC Liefering
  WSG Wattens
  SV Lafnitz
  SKU Amstetten
  Floridsdorfer AC
  LASK (A)
  FC Wacker Innsbruck (A)
TXT


DE1_TEAMS_2018_19 = <<TXT
  Bayern München
  1899 Hoffenheim
  Hertha BSC
  1. FC Nürnberg
  Werder Bremen
  Hannover 96
  SC Freiburg
  Eintracht Frankfurt
  VfL Wolfsburg
  FC Schalke 04
  Fortuna Düsseldorf
  FC Augsburg
  Bor. Mönchengladbach
  Bayer Leverkusen
  1. FSV Mainz 05
  VfB Stuttgart
  Borussia Dortmund
  RB Leipzig
TXT


DE2_TEAMS_2018_19 = <<TXT
  Hamburger SV
  Holstein Kiel
  VfL Bochum
  1. FC Köln
  Jahn Regensburg
  FC Ingolstadt 04
  SpVgg Greuther Fürth
  SV Sandhausen
  1. FC Magdeburg
  FC St. Pauli
  1. FC Union Berlin
  Erzgebirge Aue
  SV Darmstadt 98
  SC Paderborn 07
  1. FC Heidenheim 1846
  Arminia Bielefeld
  Dynamo Dresden
  MSV Duisburg
TXT


ENG1_TEAMS_2018_19 = <<TXT
  Manchester United
  Leicester City
  Newcastle United
  Tottenham Hotspur
  AFC Bournemouth
  Cardiff City
  Fulham FC
  Crystal Palace
  Huddersfield Town
  Chelsea FC
  Watford FC
  Brighton & Hove Albion
  Wolverhampton Wanderers
  Everton FC
  Southampton FC
  Burnley FC
  Liverpool FC
  West Ham United
  Arsenal FC
  Manchester City
TXT


ES1_TEAMS_2018_19 = <<TXT
  Girona FC
  Real Valladolid
  Betis Sevilla
  Levante UD
  Celta Vigo
  Espanyol Barcelona
  Villarreal CF
  Real Sociedad San Sebastian
  FC Barcelona
  CD Alavés
  SD Eibar
  SD Huesca
  Rayo Vallecano
  Sevilla FC
  Real Madrid
  Getafe CF
  Valencia CF
  Atlético Madrid
  Athletic Bilbao
  CD Leganés
TXT

IT1_TEAMS_2018_19 = <<TXT
  Chievo Verona
  Juventus Turin
  Lazio Rom
  SSC Neapel
  FC Turin
  AS Rom
  Bologna FC
  SPAL 2013 Ferrara
  Empoli FC
  Cagliari Calcio
  AC Mailand
  FC Genua
  Parma Calcio 1913
  Udinese Calcio
  Sampdoria
  AC Florenz
  Sassuolo Calcio
  Inter Mailand
  Atalanta
  Frosinone Calcio
TXT


end # module Teams


#######################
# regex patterns

SPIELTAG_REGEX = /
                    (?<=\s|^)     # use zero assertion lookbehind
                    Spieltag \s (?<round>\d{1,2})
                    (?=\s|$)      # use zero assertion lookahead
                 /xi

DATE_REGEX = /
                (?<=\s|^)     # use zero assertion lookbehind
                   (?<day>\d{2})
                     \.
                   (?<month>\d{2})
                     \.
                   (?<year>\d{4})
              (?=[\s,]|$)      # use zero assertion lookahead
             /xi



def self.read( path, teams:, debug: false )
  txt = File.open( path, 'r:utf-8' ).read

  if debug
    ## e.g. convert
    ##    txt/at1_2018-19.txt     => to
    ##    txt/o/at1_2018-19.debug.txt
    debugpath = "#{File.dirname(path)}/o/#{File.basename(path,'.*')}.debug.txt"
  else
    debugpath = nil
  end

  parse( txt, teams: teams, debug: debug, debugpath: debugpath )
end



def self.parse( txt, teams:, debug: false, debugpath: nil )

  ## split teams into an array
  ## todo/fix: move to a helper for (re)use
  team_names = []
  teams.each_line do |line|
    line = line.strip
    next if line.empty?             ## skip
    next if line.start_with?( '#')  ## skip comments too

    team_names << line
  end
  pp team_names


team_pattern = team_names.map do |team|
  ## escape space to \s
  ## escape dot (.) to \. (literal)
  ## escape () to \( and \)
  team_esc = team.gsub(' ', '\s').
                  gsub('.', '\.').
                  gsub('(', '\(').
                  gsub(')', '\)')

  "(?:#{team_esc})"
end.join('|')

pp team_pattern


team_regex = /
                (?<=\s|^)     # use zero assertion lookbehind
                (?<team>#{team_pattern})
                (?=\s|$)      # use zero assertion lookahead
             /xi


new_lines = []


i=0
last_round = nil
last_date  = nil
matches = []


txt.each_line do |line|
  i+=1

  line = line.strip

  puts "#{i}: >#{line}<"


  ## check spieltag
  if line =~ SPIELTAG_REGEX
    m = $~   # last regex match
    ## puts "** bingo - round #{m[:round]}"
    last_round = m[:round]

    line = line.sub( m[0], '«SPIELTAG»')
  else
    if line =~ DATE_REGEX
      m = $~   # last regex match
      ## puts "** bingo - date #{m[:year]}/#{m[:month]}/#{m[:day]}"
      last_date = "#{m[:year]}-#{m[:month]}-#{m[:day]}"

      line = line.sub( m[0], '«DATE»')

      team1 = nil
      team2 = nil

      if line =~ team_regex
        m = $~   # last regex match
        ## puts "** bingo - team1 #{m[:team]}"
        line = line.sub( m[0], '«TEAM1»')
        team1 = m[:team]
      end

      if line =~ team_regex
        m = $~   # last regex match
        ## puts "** bingo - team2 #{m[:team]}"
        line = line.sub( m[0], '«TEAM2»')
        team2 = m[:team]
      end

      if team1 && team2
        ## match = [last_round, last_date, team1, team2]
        match = SportDb::Struct::Match.new(
                   team1: team1,
                   team2: team2,
                   round: last_round.to_i,
                   date:  last_date )

        puts "** bingo - add new match: #{match.inspect}"
        matches << match
      end
    end
  end

  puts "    >#{line}<"

  new_lines << line
end


  if debug
    File.open( debugpath, 'w:utf-8' ) do |out|
      out << new_lines.join( "\n" )
    end
  end


  ## todo/fix: sort by 1) round and 2) date
  pp matches
  matches
end  # method self.read



def self.convert_to_csv( path, outpath, teams:, debug: false )

  matches = read( path, teams: teams, debug: debug )

  CsvMatchWriter.write( outpath, matches )
end # method self.convert_to_csv

def self.convert_to_txt( path, outpath, teams:, title:, round:, lang: 'en', debug: false)

  matches = read( path, teams: teams, debug: debug )

  TxtMatchWriter.write( outpath, matches, title: title, round: round, lang: lang )
end # method self.convert_to_txt


end # class StandardNews
