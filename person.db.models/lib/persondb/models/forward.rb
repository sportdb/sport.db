### forward references
##   require first to resolve circular references

module PersonDb
  module Model

    ## todo: why? why not use include WorldDb::Models here???
    Continent = WorldDb::Model::Continent
    Country   = WorldDb::Model::Country
    State     = WorldDb::Model::State
    City      = WorldDb::Model::City

    Tagging   = TagDb::Model::Tagging
    Tag       = TagDb::Model::Tag

    Prop      = ConfDb::Model::Prop

    class Person < ActiveRecord::Base ; end

  end # module Model

  ## note: for convenciene (and compatibility) add alias Models for Model namespace
  ##  e.g lets you use include PersonDb::Models
  Models = Model

end # module PersonDb


module WorldDb
  module Model
    Person   = PersonDb::Model::Person
  end
end
