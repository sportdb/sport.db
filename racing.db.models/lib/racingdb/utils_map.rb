# encoding: utf-8

module SportDb
  module FixtureHelpers


  def find_track!( line )
    TextUtils.find_key_for!( 'track', line )
  end

  ## todo/fix: pass in known_tracks as a parameter? why? why not?
  def map_track!( line )
    TextUtils.map_titles_for!( 'track', line, @known_tracks )
  end


  ## depreciated methods - use map_
  ###  - fix: depreciated - remove - use map_track!
  def match_track!( line )  ## fix: rename to map_track!!!
    ## todo: issue depreciated warning
    map_track!( line )
  end # method match_tracks!


  end # module FixtureHelpers
end # module SportDb

