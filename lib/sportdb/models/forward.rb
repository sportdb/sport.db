
### forward references
##   require first to resolve circular references

module SportDB::Models

  ## todo: why? why not use include WorldDB::Models here???

  Country = WorldDB::Models::Country
  Region  = WorldDB::Models::Region
  City    = WorldDB::Models::City
  Prop    = WorldDB::Models::Prop

  ## nb: for now only team and league use worlddb tables
  #   e.g. with belongs_to assoc (country,region)

  class Team < ActiveRecord::Base ; end
  class League < ActiveRecord::Base ; end
  
  #### make constanst such as AT_2012_13, WORLD_2010, etc. available
  include SportDB::Keys

end


module WorldDB::Models

  # add alias? why? why not? # is there a better way?
  #  - just include SportDB::Models  - why? why not?
  #  - just include once in loader??
  Team   = SportDB::Models::Team
  League = SportDB::Models::League

end
