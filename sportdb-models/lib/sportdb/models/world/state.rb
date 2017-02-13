# encoding: utf-8


module WorldDb
  module Model

  class State
    has_many :teams,          class_name: 'SportDb::Model::Team',   :through => :cities

    # fix: require active record 4
    # has_many :clubs,          class_name: 'SportDb::Model::Team',   :through => :cities
    # has_many :national_teams, class_name: 'SportDb::Model::Team',   :through => :cities

    has_many :grounds, class_name: 'SportDb::Model::Ground', :through => :cities
  end # class State

  end # module Model
end # module WorldDb

