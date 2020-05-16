# encoding: utf-8


class CsvMatchWriter

def self.write( path, matches, format: 'classic' )

  ## for convenience - make sure parent folders/directories exist
  FileUtils.mkdir_p( File.dirname( path) )  unless Dir.exists?( File.dirname( path ))


  out = File.new( path, 'w:utf-8' )

  ## champs "hack":
  ##   do NOT include stage,group col(umn)s if no group defined/present
  group_count    =  matches.reduce( 0 ) {|count,m|  (m.group.nil? || m.group.empty?) ? count : count+1  }

  ## add (optional) comments as last column if present
  comments_count =  matches.reduce( 0 ) {|count,m|  (m.comments.nil? || m.comments.empty?) ? count : count+1  }



  headers = []

  if format == 'mls'
    headers += 'Stage,Round,Conf 1,Conf 2,Date,Team 1,FT,HT,Team 2,ET,P'.split(',')
  elsif format == 'champs'
    if group_count > 0
      ## only add stage and group columns if present
      #  in champions league first groups / group stage starting in 2011/12
      headers += 'Stage,Round,Group,Date,Team 1,FT,HT,Team 2,∑FT,ET,P'.split(',')
    else
      headers += 'Round,Date,Team 1,FT,HT,Team 2,∑FT,ET,P'.split(',')
    end
  else   ## default to classic headers
    headers += 'Round,Date,Team 1,FT,HT,Team 2'.split(',')
  end

  if comments_count > 0
     headers << 'Comments'
  end

  out << headers.join(',')   ## e.g. Round,Date,Team 1,FT,HT,Team 2
  out << "\n"



  ## track match played for team
  played = Hash.new(0)

  matches.each_with_index do |match,i|

    if i < 2
       puts "[#{i}]:" + match.inspect
    end

    values = []

    if format == 'mls' || (format == 'champs' && group_count > 0)
      values << match.stage
    end


    if match.round     ## optional: might be nil
      round_buf = "#{match.round}"

      ## append leg if present
      if match.leg
        if match.leg =~ /^\d{1}$/
          round_buf << " | Leg #{match.leg}"
        else
          ## todo/check: warn about unkown leg !? - why? why not?
          ##  note: Replay for now only known non-numeric leg value
          round_buf << " | #{match.leg}"
        end
      end
      values << round_buf
    else
      values << "?"   ## match round missing - fix - add!!!!
    end


    ## if ['mls', 'champs'].include?( format )
      ## note: use - for undefined/nil/not applicable (n/a)
      ##       use ? for unknown
    ##  values << (match.leg ? match.leg : '')
    ## end


    if format == 'mls'
      values << match.conf1
      values << match.conf2
    end

    if format == 'champs' && group_count > 0
      values << (match.group ? match.group : '')
    end


    ## note:
    ##   as a convention add all auto-calculated values in ()
    ##  e.g. weekday e.g. (Fri), weeknumber (22), matches played (2), etc.

    ## for easier double-checking of rounds and dates
    ##  (auto-)add weekday and weeknumber
    ##  todo/fix: weeknumber - use +1  (do NOT start with 0 - why? why not)
    if match.date
      ## note: assumes string for now e.g. 2018-11-22
      date = Date.strptime( match.date, '%Y-%m-%d' )

      date_buf = ''
      date_buf << date.strftime( '(%a) %-d %b %Y' )
      date_buf << " (W#{date.cweek})"  ## use week number (iso-standard week starting on monday)

      values << date_buf   ## print weekday e.g. Fri, Sat, etc.
    else
      values << '?'
    end

    team1_played = played[match.team1] += 1
    team2_played = played[match.team2] += 1


    ## note: remove (1991-)  or (-2011) or (1899-1911) from team names for now
    team1 = match.team1.gsub( /\([0-9\- ]+\)/, '' ).strip

    if format == 'champs'
      ## add country to team
      values << "#{team1} › #{match.country1} (#{team1_played})"
    else
      values << "#{team1} (#{team1_played})"
    end


    if match.score1 && match.score2
      ## add (*) a.e.t present marker - why? makes it easier to read (for humans)
      ##   move (*) marker up-front instead of back-last - why? why not?
      if match.score1et && match.score2et
        values << "#{match.score_str} (*)"
      else
        values << match.score_str
      end
    else
      # no (or incomplete) full time score; add empty
      values << '?'
    end

    if match.score1i && match.score2i
      values << match.scorei_str
    else
      # no (or incomplete) half time score; add empty
      values << '?'
    end

    ## note: remove (1991-)  or (-2011) or (1899-1911) from team names for now
    team2 = match.team2.gsub( /\([0-9\- ]+\)/, '' ).strip


    if format == 'champs'
      ## add country to team
      values << "#{team2} › #{match.country2} (#{team2_played})"
    else
      values << "#{team2} (#{team2_played})"
    end


    if format == 'champs'
      if match.score1agg && match.score2agg
        ## todo/check:
        ##   check if agg score is equal if has away goals comment!!!! warn/report error - why? why not?
        agg_buf = ''
        agg_buf << '(a) '  if match.comments && match.comments.include?( 'Away Goals' )
        agg_buf << "#{match.score1agg}-#{match.score2agg} (agg.)"

        values << agg_buf
      else
        values << ''
      end
    end


    if ['mls', 'champs'].include?( format )
      if match.score1et && match.score2et
        values << "#{match.score1et}-#{match.score2et} (a.e.t.)"
      else
        values << ''
      end

      if match.score1p && match.score2p
        values << "#{match.score1p}-#{match.score2p} (pen.)"
      else
        values << ''
      end
    end

    # if format == 'champs'
    #  values << match.country1
    #  values << match.country2
    # end

    if comments_count > 0
       values << "#{match.comments}"
    end


    out << values.join( ',' )
    out << "\n"
  end

  out.close
end
end # class CsvMatchWriter
