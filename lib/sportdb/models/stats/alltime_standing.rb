# encoding: utf-8

module SportDb
  module Model


class AlltimeStanding < ActiveRecord::Base

  self.table_name = 'alltime_standings'

  has_many :entries,  class_name: 'SportDb::Model::AlltimeStandingEntry', foreign_key: 'alltime_standing_id', :dependent => :delete_all


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


  end # module Model
end # module SportDb
