module SportDb::Models


class Goal < ActiveRecord::Base

    belongs_to :game
    belongs_to :player

end  # class Goal


end # module SportDb::Models
