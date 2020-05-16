#######
## note: uses SportDb::Model namespace by design !!!
##

module SportDb
  module Model


class Record < ActiveRecord::Base

  belongs_to :race   # or
  belongs_to :run
  belongs_to :person, class_name: 'PersonDb::Model::Person', foreign_key: 'person_id'

end  # class Record


  end # module Model
end # module SportDb

