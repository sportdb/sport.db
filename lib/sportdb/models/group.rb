module SportDB::Models


class Group < ActiveRecord::Base
    
  has_many :games, :order => 'pos'
  belongs_to :event
  
  has_many :group_teams, :class_name => 'GroupTeam'
  has_many :teams, :through => :group_teams
      
  def add_teams_from_ary!( team_keys )
    team_keys.each do |team_key|
      team = Team.find_by_key!( team_key )
      self.teams << team
    end
  end
      
end # class Group
  
  
end # module SportDB::Models

