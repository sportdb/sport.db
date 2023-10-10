module WorldDb
  module Model

class Country
  has_many :persons,   class_name: 'PersonDb::Model::Person',  foreign_key: 'country_id'
end # class Country

  end # module Model
end # module WorldDb

