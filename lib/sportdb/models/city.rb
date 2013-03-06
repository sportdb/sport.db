
## todo: how to best extends city model?

module WorldDb::Models
  class City
    has_many :teams, :class_name => 'SportDb::Models::Team', :foreign_key => 'city_id'
  end
end # module WorldDb::Models


## moved to models/forward
#  module SportDb::Models
#  City = WorldDb::Models::City
# end # module SportDb::Models
