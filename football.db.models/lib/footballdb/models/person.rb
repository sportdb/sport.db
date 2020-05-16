
#### note ---
## uses PersonDb namespace!!!!!
#
# move to models/person/person.rb  - why? why not??


module PersonDb
  module Model

### extends "basic" person model in PersonDb
class Person

  ## todo/check: make more specific  - that is, use team_stats, all_time_stats etc. and use has_one!
  has_many :stats, class_name: 'SportDb::Model::PlayerStat'

end  # class Person


  end # module Model
end # module PersonDb

