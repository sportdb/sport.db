
module SportDbV2
  module Model


class Team < ActiveRecord::Base

  has_many :home_matches, class_name: 'Match', foreign_key: 'team1_id'
  has_many :away_matches, class_name: 'Match', foreign_key: 'team2_id'

  ## note: for now allow any key and code
  ## validates :key,  format: { with: TEAM_KEY_RE,  message: TEAM_KEY_MESSAGE }
  ## validates :code, format: { with: TEAM_CODE_RE, message: TEAM_CODE_MESSAGE }, allow_nil: true

  has_many :event_teams, class_name: 'EventTeam'  # join table (events+teams)
  has_many :events, :through => :event_teams

  ### fix!!! - how to do it with has_many macro? use finder_sql?
  ##  finder_sql is depreciated in Rails 4!!!
  #   use -> { where()  } etc.  -- try it if it works
  ##   keep as is! best solution ??
  ##   a discussion here -> https://github.com/rails/rails/issues/9726
  ##   a discussion here (not really helpful) -> http://stackoverflow.com/questions/2125440/activerecord-has-many-where-two-columns-in-table-a-are-primary-keys-in-table-b

  def matches
    Match.where( 'team1_id = ? or team2_id = ?', id, id ).order( 'date' )
  end

  def upcoming_matches
    Match.where( 'team1_id = ? or team2_id = ?', id, id ).where( 'date > ?', Date.today ).order( 'date' )
  end

  def past_matches
    Match.where( 'team1_id = ? or team2_id = ?', id, id ).where( 'date < ?', Date.today ).order( 'date desc' )
  end
end  # class Team


  end # module Model
end # module SportDbV2
