##########
# todo/fix:
##   reuse standings helper/calculator from sportdb
##   do NOT duplicate


module Sports


class Standings

  class StandingsLine     ## nested class StandinsLine - todo/fix: change to Line - why? why not?
    attr_accessor  :rank, :team,
                   :played, :won, :lost, :drawn,                      ## -- total
                   :goals_for, :goals_against, :pts,
                   :home_played, :home_won, :home_lost, :home_drawn,  ## -- home
                   :home_goals_for, :home_goals_against, :home_pts,
                   :away_played, :away_won, :away_lost, :away_drawn,  ## -- away
                   :away_goals_for, :away_goals_against, :away_pts

     alias_method :team_name, :team     ## note: team for now always a string
     alias_method :pos,       :rank     ##  rename back to use pos instead of rank - why? why not?


    def initialize( team )
      @rank = nil # use 0? why? why not?
      ## change rank back to pos - why? why not?
      @team = team
      @played = @home_played = @away_played = 0
      @won    = @home_won    = @away_won    = 0
      @lost   = @home_lost   = @away_lost   = 0
      @drawn  = @home_drawn  = @away_drawn  = 0
      @goals_for     = @home_goals_for     = @away_goals_for     = 0
      @goals_against = @home_goals_against = @away_goals_against = 0
      @pts    = @home_pts    = @away_pts    = 0
    end
  end # (nested) class StandingsLine


  def initialize( match_or_matches=nil, opts={} )
    ## fix:
    # passing in e.g. pts for win (3? 2? etc.)
    # default to 3 for now

    ## lets you pass in 2 as an alterantive, for example
    @pts_won = opts[:pts_won] || 3

    @lines = {}   # StandingsLines cached by team name/key

    ## add init and update all-in-one convenience shortcut
    update( match_or_matches )  if match_or_matches
  end


  def update( match_or_matches )
    ## convenience - update all matches at once
    ## todo/check:  check for ActiveRecord_Associations_CollectionProxy and than use to_a (to "force" array) - why? why not?
    matches = if match_or_matches.is_a?(Array)
                match_or_matches
              else
                [match_or_matches]
              end

    matches.each_with_index do |match,i| # note: index(i) starts w/ zero (0)
      update_match( match )
    end
    self  # note: return self to allow chaining
  end


  ## note: add a convenience shortcut
  ##  to_a  will sort and add rank (1,2,3) to standing lines
  def each( &block ) to_a.each( &block ); end

  def to_a
    ## return lines; sort and add rank
    ## note: will update rank!!!! (side effect)

    #############################
    ### calc ranking position (rank)
    ## fix/allow same rank e.g. all 1 or more than one team 3rd etc.

    # build array from hash
    ary = []
    @lines.each do |k,v|
      ary << v
    end

    ary.sort! do |l,r|
      ## note: reverse order (thus, change l,r to r,l)
      value = r.pts <=> l.pts
      if value == 0 # same pts try goal diff
        value = (r.goals_for-r.goals_against) <=> (l.goals_for-l.goals_against)
        if value == 0 # same goal diff too; try assume more goals better for now
          value = r.goals_for <=> l.goals_for
        end
      end
      value
    end

    ## update rank using ordered array
    ary.each_with_index do |line,i|
      line.rank = i+1 ## add ranking (e.g. 1,2,3 etc.) - note: i starts w/ zero (0)
    end

    ary
  end  # to_a



  #####
  ###
  ## fix: move build to StandingsPart/Report   !!!!
  def build( source: nil )   ## build / pretty print standings table in string buffer
    ## keep pretty printer in struct - why? why not?


    ## add standings table in markdown to buffer (buf)

    ## todo: use different styles/formats (simple/ etc  ???)

  ## simple table (only totals - no home/away)
  ##       standings.to_a.each do |l|
  ##         buf << '%2d. '  % l.rank
  ##         buf << '%-28s  ' % l.team
  ##         buf << '%2d '     % l.played
  ##         buf << '%3d '     % l.won
  ##         buf << '%3d '     % l.drawn
  ##         buf << '%3d '     % l.lost
  ##         buf << '%3d:%-3d ' % [l.goals_for,l.goals_against]
  ##         buf << '%3d'       % l.pts
  ##         buf << "\n"
  ##       end

    buf = ''
    buf << "\n"
    buf << "```\n"
    buf << "                                        - Home -          - Away -            - Total -\n"
    buf << "                                 Pld   W  D  L   F:A     W  D  L   F:A      F:A   +/-  Pts\n"

    to_a.each do |l|
      buf << '%2d. '  % l.rank
      buf << '%-28s  ' % l.team
      buf << '%2d  '     % l.played

      buf << '%2d '      % l.home_won
      buf << '%2d '      % l.home_drawn
      buf << '%2d '      % l.home_lost
      buf << '%3d:%-3d  ' % [l.home_goals_for,l.home_goals_against]

      buf << '%2d '       % l.away_won
      buf << '%2d '       % l.away_drawn
      buf << '%2d '       % l.away_lost
      buf << '%3d:%-3d  ' % [l.away_goals_for,l.away_goals_against]

      buf << '%3d:%-3d ' % [l.goals_for,l.goals_against]

      goals_diff = l.goals_for-l.goals_against
      if goals_diff > 0
        buf << '%3s  '  %  "+#{goals_diff}"
      elsif goals_diff < 0
        buf << '%3s  '  %  "#{goals_diff}"
      else ## assume 0
        buf << '     '
      end

      buf << '%3d'       % l.pts
      buf << "\n"
    end

    buf << "```\n"
    buf << "\n"

    ## optinal: add data source if known / present
    ##   assume (relative) markdown link for now in README.md
    if source
      buf << "(Source: [`#{source}`](#{source}))\n"
      buf << "\n"
    end

    buf
  end


private
  def update_match( m )   ## add a match

    ## note: always use team as string for now
    ##   for now allow passing in of string OR struct - why? why not?
    ##   todo/fix:  change to m.team1_name and m.team2_name - why? why not?
    team1 = m.team1.is_a?( String ) ? m.team1 : m.team1.name
    team2 = m.team2.is_a?( String ) ? m.team2 : m.team2.name

    score = m.score.to_s

    ##  puts "   #{team1} - #{team2} #{score}"

    unless m.over?
      puts " !!!! skipping match - not yet over (date in the future) => #{m.date}"
      return
    end

    unless m.complete?
      puts "!!! [calc_standings] skipping match #{team1} - #{team2} w/ past date #{m.date} - scores incomplete => #{score}"
      return
    end



    line1 = @lines[ team1 ] || StandingsLine.new( team1 )
    line2 = @lines[ team2 ] || StandingsLine.new( team2 )

    line1.played      += 1
    line1.home_played += 1

    line2.played      += 1
    line2.away_played += 1

    if m.winner == 1
      line1.won      += 1
      line1.home_won += 1

      line2.lost      += 1
      line2.away_lost += 1

      line1.pts      += @pts_won
      line1.home_pts += @pts_won
    elsif m.winner == 2
      line1.lost      += 1
      line1.home_lost += 1

      line2.won       += 1
      line2.away_won  += 1

      line2.pts      += @pts_won
      line2.away_pts += @pts_won
    else ## assume drawn/tie (that is, 0)
      line1.drawn      += 1
      line1.home_drawn += 1

      line2.drawn      += 1
      line2.away_drawn += 1

      line1.pts      += 1
      line1.home_pts += 1
      line2.pts      += 1
      line2.away_pts += 1
    end

    if m.score1 && m.score2
      line1.goals_for      += m.score1
      line1.home_goals_for += m.score1
      line1.goals_against      += m.score2
      line1.home_goals_against += m.score2

      line2.goals_for      += m.score2
      line2.away_goals_for += m.score2
      line2.goals_against      += m.score1
      line2.away_goals_against += m.score1
    else
      puts "*** warn: [standings] skipping match with missing scores: #{m.inspect}"
    end

    @lines[ team1 ] = line1
    @lines[ team2 ] = line2
  end  # method update_match

end  # class Standings


end # module Sports
