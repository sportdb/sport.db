# encoding: utf-8

## todo: how to best extends city model?

module WorldDb::Model

  class City
    has_many :teams,   class_name: 'SportDb::Model::Team',   foreign_key: 'city_id'
    has_many :grounds, class_name: 'SportDb::Model::Ground', foreign_key: 'city_id'
  end

end # module WorldDb::Model

