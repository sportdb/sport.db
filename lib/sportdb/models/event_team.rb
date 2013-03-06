module SportDb::Models


class EventTeam < ActiveRecord::Base
  self.table_name = 'events_teams'
  
  belongs_to :event
  belongs_to :team
end # class EventTeam


end # module SportDb::Models