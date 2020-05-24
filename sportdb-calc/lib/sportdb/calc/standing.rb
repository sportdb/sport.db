# encoding: utf-8

module SportDb
  module Model


class AlltimeStanding
  ## note: (re)open class - add (re)calc machinery

  def recalc_for_league!( league, opts={} )

    recs = StandingsHelper.calc_for_events( league.events, opts )

    ## - remove (if exit) old entries and add new entries
    entries.delete_all    # note: assoc dependent set to :delete_all (defaults to :nullify)

    recs.each do |team_key,rec|

      team = Team.find_by_key!( team_key )
      ### note: we also add rec.recs (appearance counter) - not included w/ group or event standings, for example
      entries.create!(
                team_id: team.id,
                pos:     rec.pos,
                played:  rec.played,
                won:     rec.won,
                drawn:   rec.drawn,
                lost:    rec.lost,
                goals_for: rec.goals_for,
                goals_against: rec.goals_against,
                pts:     rec.pts,
                recs:    rec.recs )
    end
  end  # method recalc_for_league!

end # class AlltimeStanding


class EventStanding
  ## note: (re)open class - add (re)calc machinery

  ## convenience helper; recalcs all records
  def self.recalc!( opts={} )  order(:id).each { |rec| rec.recalc!(opts) };  end

  def recalc!( opts={} )
    ##  will calculate event standing e.g.

    ## calc points (pts) - loop over all group games/matches
    # group.games.each do |game|
    # end

    #  todo/fix!!!!!!!!!!:
    # skip knockout rounds  - why? why not?
    #   make it configure-able?

    recs = StandingsHelper.calc( event.games, opts )

    ## - remove (if exit) old entries and add new entries
    entries.delete_all    # note: assoc dependent set to :delete_all (defaults to :nullify)

    ## add empty entries
    event.teams.each do |team|
      puts "   adding entry for team #{team.title} (#{team.code})"
      rec = recs[ team.key ]  # find  (in-memory) stats records
      entries.create!(
                team_id: team.id,
                pos:     rec.pos,
                played:  rec.played,
                won:     rec.won,
                drawn:   rec.drawn,
                lost:    rec.lost,
                goals_for: rec.goals_for,
                goals_against: rec.goals_against,
                pts:     rec.pts  )
    end
  end  # method recalc!
end # class EventStanding


class GroupStanding
  ## note: (re)open class - add (re)calc machinery

  ## convenience helper; recalcs all records
  def self.recalc!( opts={} )  order(:id).each { |rec| rec.recalc!(opts) };  end

  def recalc!( opts={} )
    ##  will calculate group standing e.g.

    ## calc points (pts) - loop over all group games/matches
    # group.games.each do |game|
    # end
    recs = StandingsHelper.calc( group.games, opts )

    ## - remove (if exit) old entries and add new entries
    entries.delete_all    # note: assoc dependent set to :delete_all (defaults to :nullify)

    ## add empty entries
    group.teams.each do |team|
      puts "   adding entry for team #{team.title} (#{team.code})"
      rec = recs[ team.key ]  # find  (in-memory) stats records
      entries.create!(
                team_id: team.id,
                pos:     rec.pos,
                played:  rec.played,
                won:     rec.won,
                drawn:   rec.drawn,
                lost:    rec.lost,
                goals_for: rec.goals_for,
                goals_against: rec.goals_against,
                pts:     rec.pts  )
    end
  end  # method recalc!
end # class GroupStanding


  end # module Model
end # module SportDb
