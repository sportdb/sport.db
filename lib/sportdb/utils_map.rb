# encoding: utf-8

module SportDb
  module FixtureHelpers


  def find_ground!( line )
    TextUtils.find_key_for!( 'ground', line )
  end

  ## todo/fix: pass in known_grounds as a parameter? why? why not?
  ### todo/fix:
  ##    remove =nil in para - make param required w/o fallback

  def map_ground!( line, known_grounds=nil )
    if known_grounds.nil?
      puts "depreciated API call map_ground! (pass in mapping table as 2nd param)"
      known_grounds = @known_grounds
    end

    TextUtils.map_titles_for!( 'ground', line, known_grounds )
  end



  def find_person!( line )
    TextUtils.find_key_for!( 'person', line )
  end

  ### todo/fix:
  ##    remove =nil in para - make param required w/o fallback
  def map_person!( line, known_persons=nil )
    if known_persons.nil?
      puts "depreciated API call map_person! (pass in mapping table as 2nd param)"
      known_persons = @known_persons
    end
    
    TextUtils.map_titles_for!( 'person', line, known_persons )
  end


  end # module FixtureHelpers
end # module SportDb

