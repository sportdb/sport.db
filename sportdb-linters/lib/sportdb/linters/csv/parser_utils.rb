# encoding: utf-8


module SportDb
  class CsvMatchParser

def self.dump( path, headers: nil, sep: ',' )
  ## for debugging add a quick test reader for stats

  headers_mapping = {}

  if headers   ## use user supplied headers if present
    headers_mapping = headers_mapping.merge( headers )
  else
    ## todo/fix: setup default mapping - why? why not?
    ##    use auto-detect - why? why not?
    ##   issue warn - headers mapping missing/required !?
  end

  ## note: make all stats headers passed in optional
  if headers_mapping[:team1] && headers_mapping[:team2]
     teams   = Hash.new(0)
     team_mappings = SportDb::Import.config.team_mappings
     known_teams   = SportDb::Import.config.teams
  end

  seasons = Hash.new(0)      if headers_mapping[:season]
  scores  = Hash.new(0)      if headers_mapping[:score]
  missing_dates = []         if headers_mapping[:date]


  rounds    = Hash.new(0)    if headers_mapping[:round]
  stages    = Hash.new(0)    if headers_mapping[:stage]
  legs      = Hash.new(0)    if headers_mapping[:leg]

  countries = Hash.new(0)    if headers_mapping[:country1] && headers_mapping[:country2]
  confs     = Hash.new(0)    if headers_mapping[:conf1]    && headers_mapping[:conf2]     ## confernces e.g. west,east,central
  ## use group1 / group2 or div1 / div2 for confs - find a better name?? ??

  levels    = Hash.new(0)    if headers_mapping[:level]  ## level / tier e.g. 1,2,3...
  divs      = Hash.new(0)    if headers_mapping[:div]    ## divisions e.g. 1,2,3,3a,3b,...


  i = 0
  CsvHashReader.foreach( path ) do |row|
    i += 1

    if i == 1
      pp row
    end

    print '.' if i % 100 == 0

    if headers_mapping[:team1] && headers_mapping[:team2]
      teams[row[headers_mapping[:team1]]] += 1
      teams[row[headers_mapping[:team2]]] += 1
    end

    scores[row[headers_mapping[:score]]] += 1    if headers_mapping[:score]

    seasons[row[headers_mapping[:season]]] += 1  if headers_mapping[:season]

    if headers_mapping[:date]
      date = row[headers_mapping[:date]]
      if date.empty? || date == 'NA' || date == '?' || date == '-'
        puts "*** missing date in row: #{row.inspect}"
        missing_dates << row
      end
    end


    ##### mote optional columns
    rounds[row[headers_mapping[:round]]] +=1   if headers_mapping[:round]
    stages[row[headers_mapping[:stage]]] += 1  if headers_mapping[:stage]
    legs[row[headers_mapping[:leg]]] += 1      if headers_mapping[:leg]

    if headers_mapping[:country1] && headers_mapping[:country2]
      countries[row[headers_mapping[:country1]]] += 1
      countries[row[headers_mapping[:country2]]] += 1
    end

    if headers_mapping[:conf1]  && headers_mapping[:conf2]     ## confernces e.g. west,east,central
      confs[row[headers_mapping[:conf1]]] += 1
      confs[row[headers_mapping[:conf2]]] += 1
    end


    levels[row[headers_mapping[:level]]] += 1  if headers_mapping[:level]  ## level / tier e.g. 1,2,3...
    divs[row[headers_mapping[:div]]] += 1      if headers_mapping[:div]    ## divisions e.g. 1,2,3,3a,3b,...
  end

  puts " #{i} rows"

  if headers_mapping[:conf1] && headers_mapping[:conf2]
    puts "#{confs.size} confs:"
    pp confs
  end

  if headers_mapping[:country1] && headers_mapping[:country2]
    puts "#{countries.size} countries:"
    pp countries
  end

  if headers_mapping[:leg]
    puts "#{legs.size} legs:"
    pp legs
  end

  if headers_mapping[:round]
    puts "#{rounds.size} rounds:"
    pp rounds
  end

  if headers_mapping[:season]
    puts "#{seasons.size} seasons:"
    pp seasons
  end

  if headers_mapping[:score]
    puts "#{scores.size} scores:"
    pp scores
  end

  if headers_mapping[:date]
    puts "#{missing_dates.size} missing dates:"
    pp missing_dates
  end

  if headers_mapping[:team1] && headers_mapping[:team2]
    puts "#{teams.size} teams:"
    pp teams

    ### check for unknown teams
    unknown_teams = {}
    teams.each do |team,match_count|
      ## note: do NOT forget to check known_teams (1:1) mapping too!!!! (to avoid duplicate mappings)
      if team_mappings[ team ] || known_teams[ team ]
        # do nothing
      else
        unknown_teams[team] = match_count
      end
    end

    puts "#{unknown_teams.size} unknown teams of #{teams.size}:"
    if unknown_teams.size > 0
      ## sort unknown_teams by match_count
      sorted_unknown_teams = unknown_teams.to_a.sort { |l,r| r[1] <=> l[1] }
      pp sorted_unknown_teams
    else
      pp unknown_teams
    end
  end
end # method dump


end # class CsvMatchParser
end # module SportDb
