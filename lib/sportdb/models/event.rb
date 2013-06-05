# encoding: utf-8

module SportDb::Models

class Event < ActiveRecord::Base

  belongs_to :league
  belongs_to :season
  
  has_many :rounds, :order => 'pos'  # all (fix and flex) rounds
  has_many :games, :through => :rounds
  
  has_many :groups, :order => 'pos'
  
  has_many :event_teams, :class_name => 'EventTeam'
  has_many :teams, :through => :event_teams

  before_save :on_before_save

  def add_teams_from_ary!( team_keys )
    team_keys.each do |team_key|
      team = Team.find_by_key!( team_key )
      self.teams << team
    end
  end

  def on_before_save
    # event key is composite of league + season (e.g. at.2012/13) etc.
    self.key = "#{league.key}.#{season.key}"
  end
  
  def title
    league.title
  end

  def full_title   # includes season (e.g. year)
    "#{league.title} #{season.title}"
  end


  #####################
  ## convenience helper for text parser/reader

  ###
  ## fix: use/add  to_teams_table( rec )  for reuse
  #
  ##  @known_teams = @event.known_teams_table


  def known_teams_table
    
    ## build known teams table w/ synonyms e.g.
    #
    # [[ 'wolfsbrug', [ 'VfL Wolfsburg' ]],
    #  [ 'augsburg',  [ 'FC Augsburg', 'Augi2', 'Augi3' ]],
    #  [ 'stuttgart', [ 'VfB Stuttgart' ]] ]
 
    known_teams = []
     
    teams.each_with_index do |team,index|

      titles = []
      titles << team.title
      titles += team.synonyms.split('|') if team.synonyms.present?
      
      ## NB: sort here by length (largest goes first - best match)
      #  exclude code and key (key should always go last)
      titles = titles.sort { |left,right| right.length <=> left.length }
      
      ## escape for regex plus allow subs for special chars/accents
      titles = titles.map { |title| TextUtils.title_esc_regex( title )  }
      
      titles << team.code                  if team.code.present?
      titles << team.key
            
      known_teams << [ team.key, titles ]
      
      ### fix:
      ## plain logger
      
      LogUtils::Logger.root.debug "  Team[#{index+1}] #{team.key} >#{titles.join('|')}<"
    end
    
    known_teams
  end # method known_teams_table

end # class Event

end # module SportDb::Models