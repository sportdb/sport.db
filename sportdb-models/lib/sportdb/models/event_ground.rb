
module SportDb
  module Model


class EventGround < ActiveRecord::Base
  self.table_name = 'events_grounds'

  belongs_to :event
  belongs_to :ground
end # class EventGround


  end # module Model
end # module SportDb
