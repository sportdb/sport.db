# encoding: utf-8


module WorldDb
  module Model

  class City
    has_many :teams,   class_name: 'SportDb::Model::Team',   foreign_key: 'city_id'
    
    # fix: require active record 4
    # has_many :clubs,           -> { where club: true },  class_name: 'SportDb::Model::Team',   foreign_key: 'city_id'
    # has_many :national_teams,  -> { where club: false }, class_name: 'SportDb::Model::Team',   foreign_key: 'city_id'


    has_many :grounds, class_name: 'SportDb::Model::Ground', foreign_key: 'city_id'
    has_many :games,   :through => :grounds
  end

  end # module Model
end # module WorldDb

