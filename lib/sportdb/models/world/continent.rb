# encoding: utf-8

module WorldDb::Model

  class Continent
    has_many :teams,   :through => :countries
    has_many :leagues, :through => :countries
  end # class Continent

end # module WorldDb::Model
