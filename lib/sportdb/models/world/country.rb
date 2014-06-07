# encoding: utf-8

module WorldDb
  module Model

  class Country
    has_many :teams,   class_name: 'SportDb::Model::Team',   foreign_key: 'country_id'
    has_one  :assoc,   class_name: 'SportDb::Model::Assoc',  foreign_key: 'country_id'

    # fix: require active record 4
    # has_many :clubs,           -> { where club: true },  class_name: 'SportDb::Model::Team',   foreign_key: 'country_id'
    # has_many :national_teams,  -> { where club: false }, class_name: 'SportDb::Model::Team',   foreign_key: 'country_id'

    has_many :leagues, class_name: 'SportDb::Model::League', foreign_key: 'country_id'
    has_many :grounds, class_name: 'SportDb::Model::Ground', foreign_key: 'country_id'
  end # class Country

  end # module Model
end # module WorldDb
