
module SportDb
  module Model

### use LineUp, Squad for name? - alias??

class Roster < ActiveRecord::Base

  belongs_to :event
  belongs_to :team
  belongs_to :person, class_name: 'PersonDb::Model::Person', foreign_key: 'person_id'

end  # class Roster


  end # module Model
end # module SportDb

