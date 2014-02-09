# encoding: utf-8

## todo: how to best extends country model?

module WorldDb::Model

  class Region
    has_many :teams, class_name: 'SportDb::Model::Team', :through => :cities
  end # class Region

end # module WorldDb::Model

