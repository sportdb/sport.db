# encoding: utf-8

## todo: how to best extends country model?

module WorldDb::Models

  class Country
    has_many :teams,   :class_name => 'SportDb::Models::Team',   :foreign_key => 'country_id'
    has_many :leagues, :class_name => 'SportDb::Models::League', :foreign_key => 'country_id'
  end # class Country

end # module WorldDb::Models


## moved to models/forward
# module SportDb::Models
#  Country = WorldDb::Models::Country
# end # module SportDb::Models
