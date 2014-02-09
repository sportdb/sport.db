
### forward references
##   require first to resolve circular references

module SportDb::Model

  ## todo: why? why not use include WorldDb::Models here???

  Continent = WorldDb::Model::Continent
  Country   = WorldDb::Model::Country
  Region    = WorldDb::Model::Region
  City      = WorldDb::Model::City
  Prop      = WorldDb::Model::Prop

  ## nb: for now only team and league use worlddb tables
  #   e.g. with belongs_to assoc (country,region)

  class Team < ActiveRecord::Base ; end
  class League < ActiveRecord::Base ; end

end


module WorldDb::Model

  # add alias? why? why not? # is there a better way?
  #  - just include SportDb::Models  - why? why not?
  #  - just include once in loader??
  Team   = SportDb::Model::Team
  League = SportDb::Model::League

end
