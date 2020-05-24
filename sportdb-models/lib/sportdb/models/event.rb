# encoding: utf-8

module SportDb
  module Model

class Event < ActiveRecord::Base

  belongs_to :league
  belongs_to :season

  has_many :rounds, -> { order('pos') }  # all (fix and flex) rounds
  has_many :groups, -> { order('pos') }
  has_many :stages

  has_many :matches, :through => :rounds

  has_many :event_teams,  class_name: 'EventTeam'
  has_many :teams, :through => :event_teams

  has_many :event_grounds,  class_name: 'EventGround'
  has_many :grounds, :through => :event_grounds


  before_save :on_before_save

  def on_before_save
    # event key is composite of league + season (e.g. at.2012/13) etc.
    self.key = "#{league.key}.#{season.key}"
  end

  def name
    "#{league.name} #{season.name}"
  end

end # class Event


class EventTeam < ActiveRecord::Base
  self.table_name = 'events_teams'

  belongs_to :event
  belongs_to :team
end # class EventTeam


class EventGround < ActiveRecord::Base
  self.table_name = 'events_grounds'

  belongs_to :event
  belongs_to :ground
end # class EventGround





  end # module Model
end # module SportDb
