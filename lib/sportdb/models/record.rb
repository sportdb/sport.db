
module SportDb
  module Model


class Record < ActiveRecord::Base

  belongs_to :race   # or
  belongs_to :run
  belongs_to :person

end  # class Record


  end # module Model
end # module SportDb

