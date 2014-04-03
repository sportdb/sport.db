# encoding: utf-8

module WorldDb
  module Model

  class Continent
    has_many :teams,          :through => :countries

    # fix: require active record 4
    # has_many :clubs,          :through => :countries
    # has_many :national_teams, :through => :countries


    has_many :leagues, :through => :countries
    has_many :grounds, :through => :countries
  end # class Continent

  end # module Model
end # module WorldDb

