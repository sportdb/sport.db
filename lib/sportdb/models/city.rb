
## todo: how to best extends city model?

module WorldDB::Models
  class City
    has_many :teams, :class_name => 'SportDB::Models::Team', :foreign_key => 'city_id'
  end
end # module WorldDB::Models


## moved to models/forward
#  module SportDB::Models
#  City = WorldDB::Models::City
# end # module SportDB::Models
