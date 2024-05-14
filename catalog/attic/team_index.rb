
module SportDb
  module Import


class TeamIndex
  ## note: "virtual" index lets you search clubs and/or national_teams (don't care)

  def catalog() Import.catalog; end

  ## todo/check: rename to/use map_by! for array version - why? why not?
  def find_by!( name:, league:, mods: nil )
    if name.is_a?( Array )
      recs = []
      name.each do |q|
        recs << __find_by!( name: q, league: league, mods: mods )
      end
      recs
    else  ## assume single name
      __find_by!( name: name, league: league, mods: mods )
    end
  end

  def __find_by!( name:, league:, mods: nil )
    if mods && mods[ league.key ] && mods[ league.key ][ name ]
      mods[ league.key ][ name ]
    else
      if league.clubs?
        if league.intl?    ## todo/fix: add intl? to ActiveRecord league!!!
          catalog.clubs.find!( name )
        else  ## assume clubs in domestic/national league tournament
          catalog.clubs.find_by!( name: name, country: league.country )
        end
      else   ## assume national teams (not clubs)
        catalog.national_teams.find!( name )
      end
    end
  end # method __find_by!

end  # class TeamIndex

end   # module Import
end   # module SportDb
