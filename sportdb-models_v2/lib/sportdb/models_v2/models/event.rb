
module SportDbV2
  module Model


class Event < ActiveRecord::Base

  belongs_to :league
 
  ## has_many :matches, -> { order('pos') }, class_name: 'Match'
  def matches
    Match.where( league_id: league_id, season: season )
  end


  ## use event_rounds - why? why not?
  ##   round ALWAYS specific to event
  has_many :rounds, class_name: 'EventRound'
  
  ## note - pass teams through to get shared team record
  ##        for "local" event name use event_teams - why? why not?
  has_many :event_teams,  class_name: 'EventTeam'
  has_many :teams, :through => :event_teams
end # class Event


class EventTeam < ActiveRecord::Base
  self.table_name = 'event_teams'

  belongs_to :event
  belongs_to :team
end # class EventTeam


class EventRound < ActiveRecord::Base
  self.table_name = 'event_rounds'

  belongs_to :event
  has_many   :matches, class_name: 'Match', foreign_key: 'event_round_id'
end # class EventRound


  end # module Model
end # module SportDb
