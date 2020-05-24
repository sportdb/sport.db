
module SportDb
  module Model


class Season < ActiveRecord::Base

  has_many :events
  has_many :leagues, :through => :events

end  # class Season


  end  # module Model
end # module SportDb
