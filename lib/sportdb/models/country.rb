# encoding: utf-8

## todo: how to best extends country model?

module WorldDB::Models

  class Country
    has_many :teams,   :class_name => 'SportDB::Models::Team',   :foreign_key => 'country_id'
    has_many :leagues, :class_name => 'SportDB::Models::League', :foreign_key => 'country_id'
  end # class Country

end # module WorldDB::Models


## moved to models/forward
# module SportDB::Models
#  Country = WorldDB::Models::Country
# end # module SportDB::Models
