
module SportDb
  class CsvMatchParser

  #############
  # helpers
  def self.find_seasons( path, col: 'Season', sep: nil, headers: nil )

    ## check if headers incl. season if yes,has priority over col mapping
    ##  e.g. no need to specify twice (if using headers)
    col = headers[:season]    if headers && headers[:season]

    seasons = Hash.new( 0 )   ## default value is 0

    ## todo/fix: yes, use CsvHash.foreach  - why? why not?
    ##                    use read_csv with block  to switch to foreach!!!!
    rows = read_csv( path, sep: sep )

    rows.each_with_index do |row,i|
      puts "[#{i}] " + row.inspect  if i < 2

      season = row[ col ]   ## column name defaults to 'Season'
      seasons[ season ] += 1
    end

    pp seasons

    ## note: only return season keys/names (not hash with usage counter)
    seasons.keys
  end


  ##########
  # main machinery

  ##  todo/fix: use a generic "global" parse_csv method - why? why not?
  ## def self.parse_csv( text, sep: ',' )    ## helper -lets you change the csv library in one place if needed/desired
  ##   ## note:  do NOT symbolize keys - keep them as is!!!!!!
  ##  ##   todo/fix: move "upstream" and remove symbolize keys too!!! - why? why not?
  ##   CsvHash.parse( text, sep: sep )
  ## end

  def self.read( path, headers: nil, filters: nil, converters: nil, sep: nil )
     txt = File.open( path, 'r:utf-8' ) {|f| f.read }   ## note: make sure to use (assume) utf-8
     parse( txt, headers: headers,
                 filters: filters,
                 converters: converters,
                 sep: sep )
  end

  def self.parse( txt, headers: nil, filters: nil, converters: nil, sep: nil )
     new( txt ).parse( headers: headers,
                        filters: filters,
                        converters: converters,
                        sep: sep )
  end


  def initialize( txt )
    @txt = txt
  end

  def parse( headers: nil, filters: nil, converters: nil, sep: nil )

    headers_mapping = {}

    rows = parse_csv( @txt, sep: sep )

    return []   if rows.empty?      ## no rows / empty?


    ## fix/todo: use logger!!!!
    ## pp csv

    if headers   ## use user supplied headers if present
      headers_mapping = headers_mapping.merge( headers )
    else

      ## note: returns an array of strings (header names)  - assume all rows have the same columns/fields!!!
      headers = rows[0].keys
      pp headers

      # note: greece 2001-02 etc. use HT  -  check CVS reader  row['HomeTeam'] may not be nil but an empty string?
      #   e.g. row['HomeTeam'] || row['HT'] will NOT work for now

      if find_header( headers, ['Team 1']) && find_header( headers, ['Team 2'])
         ## assume our own football.csv format, see github.com/footballcsv
         headers_mapping[:team1]  = find_header( headers, ['Team 1'] )
         headers_mapping[:team2]  = find_header( headers, ['Team 2'] )
         headers_mapping[:date]   = find_header( headers, ['Date'] )
         headers_mapping[:time]   = find_header( headers, ['Time'] )

         ## check for all-in-one full time (ft) and half time (ht9 scores?
         headers_mapping[:score]  = find_header( headers, ['FT'] )
         headers_mapping[:scorei] = find_header( headers, ['HT'] )

         headers_mapping[:round]  = find_header( headers, ['Round', 'Matchday'] )

         ## optional headers - note: find_header returns nil if header NOT found
         header_stage = find_header( headers, ['Stage'] )
         headers_mapping[:stage]  =  header_stage   if header_stage

         header_group = find_header( headers, ['Group'] )
         headers_mapping[:group]  =  header_group   if header_group


         header_et = find_header( headers, ['ET', 'AET'] )   ## (after) extra time
         headers_mapping[:score_et] = header_et   if header_et

         header_p  = find_header( headers, ['P', 'PEN'] )    ## penalties
         headers_mapping[:score_p] = header_p   if header_p

         header_notes = find_header( headers, ['Notes', 'Comments'] )
         headers_mapping[:notes]  =  header_notes   if header_notes


         header_league = find_header( headers, ['League'] )
         headers_mapping[:league] = header_league   if header_league
      else
         ## else try footballdata.uk and others
         headers_mapping[:team1]  = find_header( headers, ['HomeTeam', 'HT', 'Home'] )
         headers_mapping[:team2]  = find_header( headers, ['AwayTeam', 'AT', 'Away'] )
         headers_mapping[:date]   = find_header( headers, ['Date'] )
         headers_mapping[:time]   = find_header( headers, ['Time'] )

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

    rows.each_with_index do |row,i|

      ## fix/todo: use logger!!!!
      ## puts "[#{i}] " + row.inspect  if i < 2


      ## todo/fix: move to its own (helper) method - filter or such!!!!
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


      ## note:
      ##   add converters after filters for now (why not before filters?)
      if converters   ## any converters defined?
        ## convert single proc shortcut to array with single converter
        converters = [converters]    if converters.is_a?( Proc )

        ## assumes array of procs
        converters.each do |converter|
          row = converter.call( row )
        end
      end



      team1 = row[ headers_mapping[ :team1 ]]
      team2 = row[ headers_mapping[ :team2 ]]


      ## check if data present - if not skip (might be empty row)
      ##  note:  (old classic) csv reader returns nil for empty fields
      ##         new modern csv reader ALWAYS returns strings (and empty strings for data not available (n/a))
      if (team1.nil? || team1.empty?) &&
         (team2.nil? || team2.empty?)
        puts "*** WARN: skipping empty? row[#{i}] - no teams found:"
        pp row
        next
      end

      ## remove possible match played counters e.g. (4) (11) etc.
      team1 = team1.sub( /\(\d+\)/, '' ).strip
      team2 = team2.sub( /\(\d+\)/, '' ).strip



      col = row[ headers_mapping[ :time ]]

      if col.nil?
        time = nil
      else
        col = col.strip     # make sure not leading or trailing spaces left over

        if col.empty?
          col =~ /^-{1,}$/ ||      # e.g.  - or ---
          col =~ /^\?{1,}$/        # e.g. ? or ???
          ## note: allow missing / unknown date for match
          time = nil
        else
          if col =~ /^\d{1,2}:\d{2}$/
            time_fmt = '%H:%M'   # e.g. 17:00 or 3:00
          elsif col =~ /^\d{1,2}.\d{2}$/
            time_fmt = '%H.%M'   # e.g. 17:00 or 3:00
          else
            puts "*** !!! wrong (unknown) time format >>#{col}<<; cannot continue; fix it; sorry"
            ## todo/fix: add to errors/warns list - why? why not?
            exit 1
          end

          ## todo/check: use date object (keep string?) - why? why not?
          ##  todo/fix: yes!! use date object!!!! do NOT use string
          time = Time.strptime( col, time_fmt ).strftime( '%H:%M' )
        end
      end



      col = row[ headers_mapping[ :date ]]
      col = col.strip   # make sure not leading or trailing spaces left over

      if col.empty? ||
         col =~ /^-{1,}$/ ||      # e.g.  - or ---
         col =~ /^\?{1,}$/        # e.g. ? or ???
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
        elsif col =~ /^\d{4}-\d{1,2}-\d{1,2}$/      ## "standard" / default date format
          date_fmt = '%Y-%m-%d'   # e.g. 1995-08-04
        elsif col =~ /^\d{1,2} \w{3} \d{4}$/
          date_fmt = '%d %b %Y'   # e.g. 8 Jul 2017
        elsif col =~ /^\w{3} \w{3} \d{1,2} \d{4}$/
          date_fmt = '%a %b %d %Y'   # e.g. Sat Aug 7 1993
        else
          puts "*** !!! wrong (unknown) date format >>#{col}<<; cannot continue; fix it; sorry"
          ## todo/fix: add to errors/warns list - why? why not?
          exit 1
        end

        ## todo/check: use date object (keep string?) - why? why not?
        ##  todo/fix: yes!! use date object!!!! do NOT use string
        date = Date.strptime( col, date_fmt ).strftime( '%Y-%m-%d' )
      end


      ##
      ## todo/fix:  round might not always be just a simple integer number!!!
      ##             might be text such as Final | Leg 1 or such!!!!
      round   = nil
      ## check for (optional) round / matchday
      if headers_mapping[ :round ]
        col = row[ headers_mapping[ :round ]]
        ## todo: issue warning if not ? or - (and just empty string) why? why not
        ## (old attic) was: round = col.to_i  if col =~ /^\d{1,2}$/     # check format - e.g. ignore ? or - or such non-numbers for now

        ## note: make round always a string for now!!!! e.g. "1", "2" too!!
        round = if col.nil? || col.empty? || col == '-' || col == 'n/a'
                 ## note: allow missing round for match / defaults to nil
                 nil
                else
                  col
                end
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
        col = row[ headers_mapping[ :score ]]
        score = parse_score( col )
        if score
          score1 = score[0]
          score2 = score[1]
        else
          puts "!! ERROR - invalid score (ft) format >#{col}<:"
          pp row
          exit 1
        end
      end

      if headers_mapping[ :scorei ]
        col = row[ headers_mapping[ :scorei ]]
        score = parse_score( col )
        if score
          score1i = score[0]
          score2i = score[1]
        else
          puts "!! ERROR - invalid score (ht) format >#{col}<:"
          pp row
          exit 1
        end
      end

      ####
      ## try optional score - extra time (et) and penalities (p/pen)
      score1et  = nil
      score2et  = nil
      score1p   = nil
      score2p   = nil

      if headers_mapping[ :score_et ]
        col = row[ headers_mapping[ :score_et ]]
        score = parse_score( col )
        if score
          score1et = score[0]
          score2et = score[1]
        else
          puts "!! ERROR - invalid score (et) format >#{col}<:"
          pp row
          exit 1
        end
      end

      if headers_mapping[ :score_p ]
        col = row[ headers_mapping[ :score_p ]]
        score = parse_score( col )
        if score
          score1p = score[0]
          score2p = score[1]
        else
          puts "!! ERROR - invalid score (p) format >#{col}<:"
          pp row
          exit 1
        end
      end


      ## try some optional headings / columns
      stage = nil
      if headers_mapping[ :stage ]
        col = row[ headers_mapping[ :stage ]]
        ## todo/fix: check can col be nil e.g. col.nil? possible?
        stage =  if col.nil? || col.empty? || col == '-' || col == 'n/a'
                    ## note: allow missing stage for match / defaults to "regular"
                    nil
                 elsif col == '?'
                     ## note: default explicit unknown to unknown for now AND not regular - why? why not?
                    '?'   ## todo/check: use unkown and NOT ?  - why? why not?
                 else
                    col
                 end
      end

      group = nil
      if headers_mapping[ :group ]
        col = row[ headers_mapping[ :group ]]
        ## todo/fix: check can col be nil e.g. col.nil? possible?
        group =  if col.nil? || col.empty? || col == '-' || col == 'n/a'
                    ## note: allow missing stage for match / defaults to "regular"
                    nil
                 else
                    col
                 end
      end

      status = nil    ## e.g. AWARDED, CANCELLED, POSTPONED, etc.
      if headers_mapping[ :notes ]
        col = row[ headers_mapping[ :notes ]]
        ## check for optional (match) status in notes / comments
        status = if col.nil? || col.empty? || col == '-' || col == 'n/a'
                   nil
                 else
                   StatusParser.parse( col )  # note: returns nil if no (match) status found
                 end
      end


      league = nil
      league = row[ headers_mapping[ :league ]]   if headers_mapping[ :league ]


      ## puts 'match attributes:'
      attributes = {
        date:     date,
        time:     time,
        team1:    team1,    team2:    team2,
        score1:   score1,   score2:   score2,
        score1i:  score1i,  score2i:  score2i,
        score1et: score1et, score2et: score2et,
        score1p:  score1p,  score2p:  score2p,
        round:    round,
        stage:    stage,
        group:    group,
        status:   status,
        league:   league
      }
      ## pp attributes

      match = Sports::Match.new( **attributes )
      matches << match
    end

    ## pp matches
    matches
  end


  private

  def find_header( headers, candidates )
     ## todo/fix: use find_first from enumare of similar ?! - why? more idiomatic code?

    candidates.each do |candidate|
       return candidate   if headers.include?( candidate ) ## bingo!!!
    end
    nil  ## no matching header  found!!!
  end

########
# more helpers
#

def parse_score( str )
  if str.nil?    ## todo/check: remove nil case - possible? - why? why not?
    [nil,nil]
  else
    ## remove (optional single) note/footnote/endnote markers
    ##  e.g. (*) or (a), (b),
    ##    or [*], [A], [1], etc.
    ##  - allow (1) or maybe (*1) in the future - why? why not?
    str = str.sub( /\( [a-z*] \)
                        |
                    \[ [1-9a-z*] \]
                   /ix, '' ).strip

    if str.empty? || str == '?' || str == '-' || str == 'n/a'
      [nil,nil]
    ### todo/check: use regex with named capture groups here - why? why not?
    elsif str =~ /^\d{1,2}[:-]\d{1,2}$/   ## sanity check scores format
      score  = str.split( /[:-]/ )
      [score[0].to_i, score[1].to_i]
    else
      nil  ## note: returns nil if invalid / unparseable format!!!
    end
  end
end # method parse_score



  end # class CsvMatchParser
end # module Sports

