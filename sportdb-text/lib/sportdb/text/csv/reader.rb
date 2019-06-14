# encoding: utf-8



class CsvMatchReader

## todo/check: what name? use from_string, from_file, etc. instead of read / parse - why? why not?

def self.read( path, headers: nil, filters: nil, col_sep: ',' )
   text = File.open( path, 'r:utf-8' ).read   ## note: make sure to use (assume) utf-8
   parse( text, headers: headers, filters: filters, col_sep: col_sep )
end


def self.parse( text, headers: nil, filters: nil, col_sep: ',' )

  headers_mapping = {}

  csv_options = { headers: true,
                  col_sep: col_sep }
                ###  external_encoding: 'utf-8' }   ## note: always use (assume) utf8 for now

  csv = CSV.parse( text, csv_options )

  pp csv

  if headers   ## use user supplied headers if present
    headers_mapping = headers_mapping.merge( headers )
  else

    headers = csv.headers   ## note: returns an array of strings (header names)
    pp headers

    # note: greece 2001-02 etc. use HT  -  check CVS reader  row['HomeTeam'] may not be nil but an empty string?
    #   e.g. row['HomeTeam'] || row['HT'] will NOT work for now

    if find_header( headers, ['Team 1']) && find_header( headers, ['Team 2'])
       ## assume our own football.csv format, see github.com/footballcsv
       headers_mapping[:team1]  = find_header( headers, ['Team 1'] )
       headers_mapping[:team2]  = find_header( headers, ['Team 2'] )
       headers_mapping[:date]   = find_header( headers, ['Date'] )

       ## check for all-in-one full time (ft) and half time (ht9 scores?
       headers_mapping[:score]  = find_header( headers, ['FT'] )
       headers_mapping[:scorei] = find_header( headers, ['HT'] )

       headers_mapping[:round]  = find_header( headers, ['Round'] )
    else
       ## else try footballdata.uk and others
       headers_mapping[:team1]  = find_header( headers, ['HomeTeam', 'HT', 'Home'] )
       headers_mapping[:team2]  = find_header( headers, ['AwayTeam', 'AT', 'Away'] )
       headers_mapping[:date]   = find_header( headers, ['Date'] )

       ## note: FT = Full Time, HG = Home Goal, AG = Away Goal
       headers_mapping[:score1] = find_header( headers, ['FTHG', 'HG'] )
       headers_mapping[:score2] = find_header( headers, ['FTAG', 'AG'] )

       ## check for half time scores ?
       ##  note: HT = Half Time
       headers_mapping[:score1i] = find_header( headers, ['HTHG'] )
       headers_mapping[:score2i] = find_header( headers, ['HTAG'] )
    end
  end

  pp headers_mapping

  ### todo/fix: check headers - how?
  ##  if present HomeTeam or HT required etc.
  ##   issue error/warn is not present
  ##
  ## puts "*** !!! wrong (unknown) headers format; cannot continue; fix it; sorry"
  ##    exit 1
  ##

  matches = []

  csv.each_with_index do |row,i|

    puts "[#{i}] " + row.inspect  if i < 2


     if filters    ## filter MUST match if present e.g. row['Season'] == '2017/2018'
       skip = false
       filters.each do |header, value|
         if row[ header ] != value   ## e.g. row['Season']
           skip = true
           break
         end
       end
       next if skip   ## if header values NOT matching
     end


    team1 = row[ headers_mapping[ :team1 ]]
    team2 = row[ headers_mapping[ :team2 ]]


    ## check if data present - if not skip (might be empty row)
    if team1.nil? && team2.nil?
      puts "*** skipping empty? row[#{i}] - no teams found:"
      pp row
      next
    end

    ## remove possible match played counters e.g. (4) (11) etc.
    team1 = team1.sub( /\(\d+\)/, '' ).strip
    team2 = team2.sub( /\(\d+\)/, '' ).strip

    ## reformat team if match  (e.g. Bayern Munich => Bayern München etc.)
    ##  use "global" default/built-in team mappings for now
    team_mappings = SportDb::Import.config.team_mappings
    team1 = team_mappings[ team1 ]   if team_mappings[ team1 ]
    team2 = team_mappings[ team2 ]   if team_mappings[ team2 ]


    col = row[ headers_mapping[ :date ]]
    col = col.strip   # make sure not leading or trailing spaces left over

    if col.empty? || col == '-' || col == '?'
       ## note: allow missing / unknown date for match
       date = nil
    else
      ## remove possible weekday or weeknumber  e.g. (Fri) (4) etc.
      col = col.sub( /\(W?\d{1,2}\)/, '' )  ## e.g. (W11), (4), (21) etc.
      col = col.sub( /\(\w+\)/, '' )  ## e.g. (Fri), (Fr) etc.
      col = col.strip   # make sure not leading or trailing spaces left over

      if col =~ /^\d{2}\/\d{2}\/\d{4}$/
        date_fmt = '%d/%m/%Y'   # e.g. 17/08/2002
      elsif col =~ /^\d{2}\/\d{2}\/\d{2}$/
        date_fmt = '%d/%m/%y'   # e.g. 17/08/02
      elsif col =~ /^\d{4}-\d{2}-\d{2}$/      ## "standard" / default date format
        date_fmt = '%Y-%m-%d'   # e.g. 1995-08-04
      elsif col =~ /^\d{1,2} \w{3} \d{4}$/
        date_fmt = '%d %b %Y'   # e.g. 8 Jul 2017
      else
        puts "*** !!! wrong (unknown) date format >>#{col}<<; cannot continue; fix it; sorry"
        ## todo/fix: add to errors/warns list - why? why not?
        exit 1
      end

      ## todo/check: use date object (keep string?) - why? why not?
      ##  todo/fix: yes!! use date object!!!! do NOT use string
      date = Date.strptime( col, date_fmt ).strftime( '%Y-%m-%d' )
    end


    round   = nil
    ## check for (optional) round / matchday
    if headers_mapping[ :round ]
      col = row[ headers_mapping[ :round ]]
      ## todo: issue warning if not ? or - (and just empty string) why? why not
      round = col.to_i  if col =~ /^\d{1,2}$/     # check format - e.g. ignore ? or - or such non-numbers for now
    end


    score1  = nil
    score2  = nil
    score1i = nil
    score2i = nil

    ## check for full time scores ?
    if headers_mapping[ :score1 ] && headers_mapping[ :score2 ]
      ft = [ row[ headers_mapping[ :score1 ]],
             row[ headers_mapping[ :score2 ]] ]

      ## todo/fix: issue warning if not ? or - (and just empty string) why? why not
      score1 = ft[0].to_i  if ft[0] =~ /^\d{1,2}$/
      score2 = ft[1].to_i  if ft[1] =~ /^\d{1,2}$/
    end

    ## check for half time scores ?
    if headers_mapping[ :score1i ] && headers_mapping[ :score2i ]
      ht = [ row[ headers_mapping[ :score1i ]],
             row[ headers_mapping[ :score2i ]] ]

      ## todo/fix: issue warning if not ? or - (and just empty string) why? why not
      score1i = ht[0].to_i  if ht[0] =~ /^\d{1,2}$/
      score2i = ht[1].to_i  if ht[1] =~ /^\d{1,2}$/
    end

    ## check for all-in-one full time scores?
    if headers_mapping[ :score ]
      ft = row[ headers_mapping[ :score ] ]
      if ft =~ /^\d{1,2}[\-:]\d{1,2}$/   ## sanity check scores format
        scores = ft.split( /[\-:]/ )
        score1 = scores[0].to_i
        score2 = scores[1].to_i
      end
      ## todo/fix: issue warning if non-empty!!! and not matching format!!!!
    end

    if headers_mapping[ :scorei ]
      ht = row[ headers_mapping[ :scorei ] ]
      if ht =~ /^\d{1,2}[\-:]\d{1,2}$/   ## sanity check scores format
        scores = ht.split( /[\-:]/)   ## allow 1-1 and 1:1
        score1i = scores[0].to_i
        score2i = scores[1].to_i
      end
      ## todo/fix: issue warning if non-empty!!! and not matching format!!!!
    end


    match = SportDb::Struct::Match.new( date:  date,
                                        team1: team1,     team2: team2,
                                        score1: score1,   score2: score2,
                                        score1i: score1i, score2i: score2i,
                                        round:  round )
    matches << match
  end

  ## pp matches
  matches
end




def self.dump( path, headers: nil, col_sep: ',' )
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
  CSV.foreach( path, headers: true ) do |row|
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



private

def self.find_header( headers, candidates )
   ## todo/fix: use find_first from enumare of similar ?! - why? more idiomatic code?

  candidates.each do |candidate|
     return candidate   if headers.include? candidate  ## bingo!!!
  end
  nil  ## no matching header  found!!!
end

end # class CsvReader
