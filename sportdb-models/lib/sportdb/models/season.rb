
module SportDb
  module Model


class Season < ActiveRecord::Base
  
  has_many :events

end  # class Season


  end  # module Model
end # module SportDb
