module SportDb::Models

class Roster < ActiveRecord::Base

  belongs_to :event
  belongs_to :team
  belongs_to :person

end  # class Roster


end # module SportDb::Models