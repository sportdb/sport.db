# encoding: utf-8

module SportDb::Models

  ## add convenience finders to some model classes
  
  class Event

  include SportDb::Keys::EventKeys

  def self.find_at_2012_13!
    self.find_by_key!( AT_2012_13 )
  end
  
  def self.find_at_cup_2012_13!
    self.find_by_key!( AT_CUP_2012_13 )
  end
  
  def self.find_cl_2012_13!
    self.find_by_key!( CL_2012_13 )
  end
  
  def self.find_euro_2012!
    self.find_by_key!( EURO_2012 )
  end
  
  def self.find_world_2010!
    self.find_by_key!( WORLD_2010 )
  end
  
  def self.find_world_quali_europe_2014!
    self.find_by_key!( WORLD_QUALI_EUROPE_2014 )
  end
  
  def self.find_world_quali_america_2014!
    self.find_by_key!( WORLD_QUALI_AMERICA_2014 )
  end
    
  end # class Event

end # module SportDb::Models


