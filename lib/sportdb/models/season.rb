module SportDB::Models


class Season < ActiveRecord::Base
  
  has_many :events

end  # class Season


end # module SportDB::Models
