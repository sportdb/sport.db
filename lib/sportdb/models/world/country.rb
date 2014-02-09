# encoding: utf-8

## todo: how to best extends country model?

module WorldDb::Model

  class Country
    has_many :teams,   class_name: 'SportDb::Model::Team',   foreign_key: 'country_id'
    has_many :leagues, class_name: 'SportDb::Model::League', foreign_key: 'country_id'
  end # class Country

end # module WorldDb::Model

