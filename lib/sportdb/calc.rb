# encoding: utf-8

module SportDb


##############################################
# helper/ builds standings table in memory
#  - find a better module name for StandingsHelper ?? why? why not?


module StandingsHelper

  ## todo:
  ##  add team_id to struct - why? why not?  - saves a db lookup?
  class Stats
     attr_accessor :pos, :played, :won, :lost, :drawn,
                   :goals_for, :goals_against, :pts,
                   :recs

     def initialize
       @pos           = nil    # use 0? why? why not?
       @played        = 0
       @won           = 0
       @lost          = 0
       @drawn         = 0
       @goals_for     = 0
       @goals_against = 0
       @pts           = 0
       @recs          = 0
       # note: appearances (event) count  or similar
       #   is recs counter (number of (stats) records)
     end

     def add( rec )
       ### fix: add plus + operator too!
       
       # note: will NOT update/add pos (ranking)
       self.played        += rec.played
       self.won           += rec.won
       self.lost          += rec.lost
       self.drawn         += rec.drawn
       self.goals_for     += rec.goals_for
       self.goals_against += rec.goals_against
       self.pts           += rec.pts
       self.recs          += rec.recs

       self # return self stats rec
     end # method add
  end  # class Stats


  def self.calc( games, opts={} )
     
     ##
     #  possible opts include:
     #    pts_won:              3 or 2 or n   (default 3)
     #    pts_exclude_scorep    false or true (default false)  -- exclude penalty shotout scores (e.g. count a draw/tie - no winner)
     #
    recs = calc_stats( games, opts )

    ## update pos (that is, ranking e.g. 1.,2., 3. etc.)
    recs= update_ranking( recs )

    pp recs
    recs
  end



  def self.calc_for_events( events, opts={} )

    ## todo:
    ##  - add tracker for appeareances (stats records counter)

    alltime_recs = {}  # stats recs indexed by team_key

    events.each do |event|
      puts "  update standings for #{event.title}"
      recs = calc_stats( event.games, opts )

      recs.each do |team_key, rec|
        alltime_rec = alltime_recs[ team_key ] || Stats.new

        ## add stats values
        alltime_rec.add( rec )

        alltime_recs[ team_key ] = alltime_rec 
      end
    end


    ### fix:
    # - make merge team into a helper method (for reuse)

    ## check for merging teams
    # e.g. all time world cup
    #   Germany incl. West Germany
    #   Russia  incl. Soviet Union etc.
    
    # todo: change opts para to :includes  instead of :merge ? why? why not??

    merge = opts[:merge]
    if merge
      puts "  merging teams (stats records):"
      pp merge

      merge.each do |k,v|
        # note: assume key is destition team key and
        #         value is source team key  e.g.  'GER' => 'FRG'
        #         or array (for mulitple teamss e.g.  'GER' => ['FRG','GDR']
        team_key_dest = k.to_s

        if v.kind_of? Array
          team_keys_src = v
        else
          team_keys_src = [v]    # turn single value arg into array w/ single item
        end
        team_keys_src = team_keys_src.map { |src| src.to_s }  # turn all to string (might be symbol)

        alltime_rec_dest = alltime_recs[ team_key_dest ] || Stats.new

        team_keys_src.each do |team_key_src|
          alltime_rec_src  = alltime_recs[ team_key_src]

          if alltime_rec_src  # stats record found?
            alltime_rec_dest.add( alltime_rec_src )  # add stats values
            alltime_recs.delete( team_key_src )      # remove old src entry
          end
        end

        alltime_recs[ team_key_dest ] = alltime_rec_dest
      end
    end

    ## update pos (that is, ranking e.g. 1.,2., 3. etc.)
    alltime_recs= update_ranking( alltime_recs )

    ## pp alltime_recs
    alltime_recs
  end



  def self.calc_stats( games, opts={} )

    ## fix:
    #   passing in e.g. pts for win (3? 2? etc.)
    #    default to 3 for now

    # note:
    #   returns stats records w/ stats records counter always set to one (recs==1)

    ## todo/fix: find a better way to include logger (do NOT hardcode usage of root logger)!!!
    logger = LogUtils::Logger.root


    ## lets you pass in 2 as an alterantive, for example
    pts_won  = opts[:pts_won] || 3

    ## lets you exclude penalty shootout (e.g. match gets scored as draw/tie 1 pt each)
    #  e.g. why? used for alltime standings formula in world cup, for example
    #   todo: check other standings - exclude penalty shootout too - e.g. championsleague ?? if yes - make it true as default??
    pts_exclude_scorep = opts[:pts_exclude_scorep].present? ? opts[:pts_exclude_scorep] : false


    recs = {}

    games.each_with_index do |g,i|   # note: index(i) starts w/ zero (0)
      puts "  [#{i+1}] #{g.team1.title} - #{g.team2.title}  #{g.score_str}"
      unless g.over?
        puts "    !!!! skipping match - not yet over (play_at date in the future)"
        next
      end
      unless g.complete?
        logger.error "[StandingsHelper.calc_stats] skipping match #{g.team1.title} - #{g.team2.title} - scores incomplete #{g.score_str}"
        next
      end

      rec1 = recs[ g.team1.key ] || Stats.new
      rec2 = recs[ g.team2.key ] || Stats.new

      ## set stats records counter to one if new (first) record update 
      rec1.recs = 1   if rec1.recs == 0
      rec2.recs = 1   if rec2.recs == 0

      rec1.played += 1
      rec2.played += 1

      ## check - if winner (excludes penalty shootout scores in calc? start w/ extra time e.g winneret)
      if pts_exclude_scorep
         winner = g.winneret || g.winner90     ## if no extra time (et) score; try 90min (regular time score)
      else
         winner = g.winner   ## note: might include penalty shoot scores
      end

      if winner == 1
        rec1.won  += 1
        rec2.lost += 1
        rec1.pts  += pts_won
      elsif winner == 2
        rec1.lost  += 1
        rec2.won   += 1
        rec2.pts   += pts_won
      else  ## assume drawn/tie (that is, 0)
        rec1.drawn += 1
        rec2.drawn += 1
        rec1.pts   += 1
        rec2.pts   += 1
      end

      rec1.goals_for     += g.score1
      rec1.goals_against += g.score2
      
      rec2.goals_for     += g.score2
      rec2.goals_against += g.score1

      ## add overtime and penalty??
      ##  - for now add only overtime if present
      
      rec1.goals_for     += (g.score1et-g.score1)  if g.score1et.present?
      rec1.goals_against += (g.score2et-g.score2)  if g.score2et.present?

      rec2.goals_for     += (g.score2et-g.score2)  if g.score2et.present?
      rec2.goals_against += (g.score1et-g.score1)  if g.score1et.present?

      recs[ g.team1.key ] = rec1
      recs[ g.team2.key ] = rec2
    end  # each game

    recs # return records; hash indexed by team key
  end # method calc


  def self.update_ranking( recs )
    #############################
    ### calc ranking / pos
    ##
    ## fix/allow sampe pos e.g. all 1 or more than one team 3rd etc.
    ##   see sportbook for an example

    # build array from hash
    ary = []
    recs.each do |k,v|
      ary << [k,v]
    end

    ary.sort! do |l,r|
      ## note: reverse order (thus, change l,r to r,l)
      value =  r[1].pts <=> l[1].pts
      if value == 0    # same pts try goal diff
        value =   (r[1].goals_for-r[1].goals_against) <=> (l[1].goals_for-l[1].goals_against)
        if value == 0  # same goal diff too; try assume more goals better for now
          value =   r[1].goals_for <=> l[1].goals_for
        end
      end
      value
    end

    ## update pos using ordered array
    ary.each_with_index  do |rec,i|
      k = rec[0]
      v = rec[1]
      v.pos = i+1    ## add ranking (e.g. 1,2,3 etc.)  - note: i starts w/ zero (0)
      recs[ k ] = v   ## update recs
    end
    
    recs
  end # method update_ranking

  
end # module StandingsHelper

end # module SportDb
