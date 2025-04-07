
module SportDbV2
  module Model


class Match < ActiveRecord::Base

  self.table_name = 'matches'

  belongs_to :team1, class_name: 'Team', foreign_key: 'team1_id'
  belongs_to :team2, class_name: 'Team', foreign_key: 'team2_id'

  def team1_name()  team1.name; end
  def team2_name()  team2.name; end

  
  belongs_to :league

  ##  todo - add via
  ## belongs_to :event
  def event 
    ## check if where always returns array or single record too??
    Event.where( league_id: league_id, season: season )
  end
  belongs_to :event_round    # round is optional


end # class Match

  end # module Model
end # module SportDbV2
