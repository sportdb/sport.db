module SportDb::Models


class Player < ActiveRecord::Base

  has_many :goals

end  # class Player


end # module SportDb::Models
