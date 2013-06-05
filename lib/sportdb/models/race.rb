module SportDb::Models


class Race < ActiveRecord::Base

  belongs_to :track
  belongs_to :event

  ### fix/todo: add runs/records  (records - join table - run/race+person)
  ## has_many :runs    # e.g. Test Drive, Quali 1, Quali 2, Quali 3, Race
  ## run - has_many  records? - run_stats?  - what name to use?

end  # class Race


end # module SportDb::Models