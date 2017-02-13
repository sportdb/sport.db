# encoding: utf-8

module SportDb
  module Model

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
