
module SportDb
  module Model

### use Squad for name? - alias??

class Lineup < ActiveRecord::Base

  belongs_to :event
  belongs_to :team
  belongs_to :person, class_name: 'PersonDb::Model::Person', foreign_key: 'person_id'

end  # class Lineup

  end # module Model
end # module SportDb

