
module SportDb
  module Model


class Goal < ActiveRecord::Base

  belongs_to :game
  belongs_to :person

end  # class Goal


  end # module Model
end # module SportDb
