# encoding: utf-8

module SportDb
  module FixtureHelpers


  def find_teams!( line ) # NB: returns an array - note: plural! (teamsss)
    TextUtils.find_keys_for!( 'team', line )
  end
  
  def find_team!( line )  # NB: returns key (string or nil)
    TextUtils.find_key_for!( 'team', line )
  end

  ## todo: check if find_team1 gets used?  if not remove it!!  use find_teams!
  def find_team1!( line )
    TextUtils.find_key_for!( 'team1', line )
  end

  def find_team2!( line )
    TextUtils.find_key_for!( 'team2', line )
  end

  ## todo/fix: pass in known_teams as a parameter? why? why not?

  def map_teams!( line )
    TextUtils.map_titles_for!( 'team', line, @known_teams )
  end
  
  def map_team!( line )  # alias map_teams!
    map_teams!( line )
  end


  ## depreciated methods - use map_
  def match_teams!( line )   ## fix: rename to map_teams!! - remove match_teams!
    ## todo: issue depreciated warning
    map_teams!( line )
  end # method match_teams!


  end # module FixtureHelpers
end # module SportDb