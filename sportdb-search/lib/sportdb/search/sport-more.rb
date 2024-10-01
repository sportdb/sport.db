
module Sports

  class Ground
    def self._search() CatalogDb::Metal::Ground; end

  ###################
  ## core required delegates  - use delegate generator - why? why not?
  def self.match_by( name:, country: nil, city: nil )
    _search.match_by( name:    name,
                       country: country,
                       city:    city )
  end

  ###############
  ### more deriv support functions / helpers
  def self.match( name ) match_by( name: name ); end
  ## add more here - why? why not?
  end # class Ground



  class Player
    def self._search() CatalogDb::Metal::Player; end

  ###################
  ## core required delegates  - use delegate generator - why? why not?
  def self.match_by( name:, country: nil, year: nil )
    _search.match_by( name:    name,
                       country: country,
                       year:    year )
  end

  ###############
  ### more deriv support functions / helpers
  def self.match( name ) match_by( name: name ); end
  ## add more here - why? why not?
  end   # class Player

end   # module Sports
