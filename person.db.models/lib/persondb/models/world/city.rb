module WorldDb
  module Model

class City
  has_many :persons,   class_name: 'PersonDb::Model::Person',  foreign_key: 'city_id'
end # class City

  end # module Model
end # module WorldDb

