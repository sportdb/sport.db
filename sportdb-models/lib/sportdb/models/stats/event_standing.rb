# encoding: utf-8

module SportDb
  module Model


class EventStanding < ActiveRecord::Base

  self.table_name = 'event_standings'

  has_many   :entries, class_name: 'SportDb::Model::EventStandingEntry', foreign_key: 'event_standing_id', :dependent => :delete_all
  belongs_to :event

end # class EventStanding


class EventStandingEntry < ActiveRecord::Base

  self.table_name = 'event_standing_entries'

  belongs_to :standing, class_name: 'SportDb::Model::EventStanding', foreign_key: 'event_standing_id'
  belongs_to :team

  ## note:
  ##  map standing_id to group_standing_id - convenience alias
  def standing_id=(value)  write_attribute(:event_standing_id, value);  end

end # class EventStandingEntry

  end # module Model
end # module SportDb
