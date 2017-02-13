# encoding: utf-8

module SportDb
  module Model


class GroupStanding < ActiveRecord::Base

  self.table_name = 'group_standings'

  has_many   :entries, class_name: 'SportDb::Model::GroupStandingEntry', foreign_key: 'group_standing_id', :dependent => :delete_all
  belongs_to :group

  ## convenience helper; recalcs all records
  def self.recalc!( opts={} )  self.order(:id).each { |rec| rec.recalc!(opts) };  end


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
