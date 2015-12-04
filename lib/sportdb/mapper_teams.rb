# encoding: UTF-8

module SportDb

class TeamMapper
  def initialize( recs )
    @mapper = TextUtils::TitleMapper2.new( recs, 'team' )
  end

  def find_teams!( line ) # Note: returns an array - note: plural! (teamsssss)
    @mapper.find_keys!( line )
  end

  def find_team!( line )  # Note: returns key (string or nil)
    @mapper.find_key!( line )
  end

  def map_teams!( line )
    @mapper.map_titles!( line )
  end
end # class TeamMapper

end # module SportDb

