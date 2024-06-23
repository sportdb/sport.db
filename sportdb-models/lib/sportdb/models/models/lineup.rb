
module SportDb
  module Model

### todo/fix - yes, use Squad for name
###     use lineup table for match (specific) players lineup/formation 
##          NOT league (all season) squad !!!!!


class Lineup < ActiveRecord::Base

  belongs_to :event
  belongs_to :team
  belongs_to :person, class_name: 'PersonDb::Model::Person', foreign_key: 'person_id'

end  # class Lineup

  end # module Model
end # module SportDb

