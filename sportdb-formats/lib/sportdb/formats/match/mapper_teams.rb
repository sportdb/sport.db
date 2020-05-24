# encoding: utf-8

module SportDb

class TeamMapper
  def initialize( records_or_mapping )
    @mapper = MapperV2.new( records_or_mapping, 'team' )
  end

  def find_teams!( line ) # Note: returns an array - note: plural! (teamsssss)
    @mapper.find_recs!( line )
  end

  def find_team!( line )  # Note: returns key (string or nil)
    @mapper.find_rec!( line )
  end

  def map_teams!( line )
    @mapper.map_names!( line )
  end
end # class TeamMapper

end # module SportDb
