
###
# note: lets us SportDb::Model for now !! (and NOT FootballDb::Model)

module SportDb
  module Model

# PlayerStat
#
# Contains the primary statistics for a player.  Could be on a per-game
#  basis, per event, per-team, or all-time (no game, no event, no team).  A player will
#  have many player_stats and can also have many generic StatData items
#
# redCards
# yellowCards
# totalGoals
# goalsConceded
# wins
# losses
# draws
# foulsSuffered
# foulsCommitted
# goalAssists
# shotsOnTarget
# totalShots
# totalGoals
# subIns
# subOuts
# starts
# saves
# minutesPlayed
# position
#
# See schema.rb for full definition

class PlayerStat < ActiveRecord::Base

  belongs_to :person, class_name: 'PersonDb::Model::Person', foreign_key: 'person_id'

  belongs_to :team
  belongs_to :game
  belongs_to :event

end # class PlayerStat


  end # module Model
end # module SportDb

