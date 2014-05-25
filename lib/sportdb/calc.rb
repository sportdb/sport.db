# encoding: utf-8

module SportDb


##############################################
# helper/ builds standings table in memory
#  - find a better module name for StandingsHelper ?? why? why not?


module StandingsHelper

  Stats = Struct.new(
            :pos,
            :played,
            :won,
            :lost,
            :drawn,
            :goals_for,
            :goals_against,
            :pts )


  def self.calc( games, opts={} )
    
    ## fix:
    #   passing in e.g. pts for win (3? 2? etc.)
    #    default to 3 for now
    
    recs = {}

    games.each_with_index do |g,i|   # note: index(i) starts w/ zero (0)
      puts "  [#{i+1}] #{g.team1.title} - #{g.team2.title}  #{g.score_str}"
      unless g.over?
        puts "    skipping match - not yet over (play_at date in the future)"
        next
      end
      unless g.complete?
        puts "    skipping match - scores incomplete"
        next
      end

      rec1 = recs[ g.team1.key ] || Stats.new( 0, 0, 0, 0, 0, 0, 0, 0 )
      rec2 = recs[ g.team2.key ] || Stats.new( 0, 0, 0, 0, 0, 0, 0, 0 )

      rec1.played += 1
      rec2.played += 1
      
      if g.winner == 1
        rec1.won  += 1
        rec2.lost += 1
        rec1.pts  += 3   # 3pts for win (hardcoded for now; change - use event setting?)
      elsif g.winner == 2
        rec1.lost  += 1
        rec2.won   += 1
        rec2.pts   += 3  # 3pts for win (hardcoded for now; change - use event setting?)
      else ## assume == 0 (drawn)
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
      rec1.goals_for     += (g.score1et-g.score1)    if g.score1et.present?
      rec1.goals_against += (g.score2et-g.score2)    if g.score2et.present?

      rec2.goals_for     += (g.score2et-g.score2)    if g.score2et.present?
      rec2.goals_against += (g.score1et-g.score1)    if g.score1et.present?


      recs[ g.team1.key ] = rec1
      recs[ g.team2.key ] = rec2
    end  # each game

    ## update pos (that is, ranking e.g. 1.,2., 3. etc.)
    recs= update_ranking( recs )

    pp recs

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
