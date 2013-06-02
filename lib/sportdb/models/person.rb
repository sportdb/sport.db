module SportDb::Models


class Person < ActiveRecord::Base

  has_many :goals

end  # class Person


end # module SportDb::Models
