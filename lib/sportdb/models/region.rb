# encoding: utf-8

## todo: how to best extends country model?

module WorldDb::Models

  class Region
    has_many :teams, :class_name => 'SportDb::Models::Team', :through => :cities
  end # class Region

end # module WorldDb::Models

## moved to models/forward
# module SportDb::Models
#  Region = WorldDb::Models::Region
# end # module SportDb::Models
