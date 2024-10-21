
module Sports


class LeaguePeriod
   def self._search() CatalogDb::Metal::LeaguePeriod; end


  def self.match_by( name: nil, code: nil, season: )
    ## todo/fix upstream - remove "generic" match_by() - why? why not?
    ###
    if code && name.nil?
     _search.match_by_code( code, season: season )
   elsif name && code.nil?
     _search.match_by_name( name, season: season )
   else
     raise ArgumentError, "LeaguePeriod.match_by - one (and only one arg) required - code: or name:"
   end
  end


 ## all-in-one query (name or code)
 def self.match( q, season: )
    _search.match_by_name_or_code( q, season: season )
 end

  ###############
  ### more deriv support functions / helpers
  def self.find!( q, season: )
    period = find( q, season: season )
    if period.nil?
      puts "** !!! ERROR - no league period found for >#{q}+#{season}<, add to leagues table; sorry"
      exit 1
    end
    period
  end

  def self.find( q, season: )
    period = nil
    recs = match( q, season: season )
    # pp m

    if recs.empty?
      ## fall through/do nothing
    elsif recs.size > 1
      puts "** !!! ERROR - too many matches (#{recs.size}) for league period >#{q}+#{season}<:"
      pp recs
      exit 1
    else
      period = recs[0]
    end

    period
  end
end  # class LeaguePeriod


class League
    def self._search() CatalogDb::Metal::League; end

  ###################
  ## core required delegates  - use delegate generator - why? why not?
  def self.match_by( name: nil, code: nil, country: nil )
    ## todo/fix upstream - remove "generic" match_by() - why? why not?
    ###
    if code && name.nil?
     _search.match_by_code( code, country: country )
   elsif name && code.nil?
     _search.match_by_name( name, country: country )
   else
     raise ArgumentError, "League.match_by - one (and only one arg) required - code: or name:"
   end
  end


 ## all-in-one query (name or code)
 def self.match( q, country: nil )
    _search.match_by_name_or_code( q, country: country )
 end

  ###############
  ### more deriv support functions / helpers
  def self.find!( q )
    league = find( q )
    if league.nil?
      puts "** !!! ERROR - no league match found for >#{q}<, add to leagues table; sorry"
      exit 1
    end
    league
  end

  def self.find( q )
    league = nil
    recs = match( q )
    # pp m

    if recs.empty?
      ## fall through/do nothing
    elsif recs.size > 1
      puts "** !!! ERROR - too many matches (#{recs.size}) for league #{q}:"
      pp recs
      exit 1
    else
      league = recs[0]
    end

    league
  end
end # class League
end   # module Sports