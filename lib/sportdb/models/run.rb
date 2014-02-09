module SportDb::Model


class Run < ActiveRecord::Base

  belongs_to :race

end  # class Run


end # module SportDb::Model
