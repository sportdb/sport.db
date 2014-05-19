
module SportDb
  module Model


class Goal < ActiveRecord::Base

  belongs_to :game
  belongs_to :person, class_name: 'PersonDb::Model::Person', foreign_key: 'person_id'

end  # class Goal


  end # module Model
end # module SportDb
