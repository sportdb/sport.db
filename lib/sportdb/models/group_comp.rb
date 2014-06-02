# encoding: utf-8

module SportDb
  module Model

#############################################################
# collect depreciated or methods for future removal here
# - keep for now for compatibility (for old code)

class Group

  def add_teams_from_ary!( team_keys )
    team_keys.each do |team_key|
      team = Team.find_by_key!( team_key )
      self.teams << team
    end
  end

end # class Group


  end # module Model
end # module SportDb
