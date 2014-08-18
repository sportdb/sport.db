# encoding: utf-8

module SportDb
  module FixtureHelpers


  def find_ground!( line )
    TextUtils.find_key_for!( 'ground', line )
  end

  ## todo/fix: pass in known_grounds as a parameter? why? why not?
  def map_ground!( line )
    TextUtils.map_titles_for!( 'ground', line, @known_grounds )
  end


  def find_person!( line )
    TextUtils.find_key_for!( 'person', line )
  end

  def map_person!( line )
    TextUtils.map_titles_for!( 'person', line, @known_persons)
  end


  end # module FixtureHelpers
end # module SportDb

