module SportDb::Models


class Goal < ActiveRecord::Base

    belongs_to :game
    belongs_to :person

end  # class Goal


end # module SportDb::Models
