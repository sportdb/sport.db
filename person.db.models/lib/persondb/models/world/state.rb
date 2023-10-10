module WorldDb
  module Model

class State
  has_many :persons,   class_name: 'PersonDb::Model::Person',  foreign_key: 'state_id'
end # class State

  end # module Model
end # module WorldDb

