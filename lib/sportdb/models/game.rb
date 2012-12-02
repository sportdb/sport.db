module SportDB::Models


class Game < ActiveRecord::Base

  belongs_to :team1, :class_name => 'Team', :foreign_key => 'team1_id'
  belongs_to :team2, :class_name => 'Team', :foreign_key => 'team2_id'
  
  belongs_to :round
  belongs_to :group   # group is optional

  before_save :calc_toto12x


  def self.create_knockouts_from_ary!( games, round )
    Game.create_from_ary!( games, round, true )
  end

  def self.create_from_ary!( games, round, knockout=false )

### fix:
#  replace knockout=false with more attribs
#    see create teams and than merge attribs

    games.each_with_index do |values,index|
      
      value_pos      = index+1
      value_scores   = []
      value_teams    = []
      value_knockout = knockout
      value_play_at  = round.start_at  # if no date present use it from round
      value_group    = nil
      
      ### lets you use arguments in any order
      ##   makes pos optional (if not present counting from 1 to n)
      
      values.each do |value|
        if value.kind_of? Numeric
          value_pos = value
        elsif value.kind_of?( TrueClass ) || value.kind_of?( FalseClass )
          value_knockout = value
        elsif value.kind_of? Array
          value_scores = value
        elsif value.kind_of? Team
          value_teams << value
        elsif value.kind_of? Group
          value_group = value
        elsif value.kind_of?( Date ) || value.kind_of?( Time ) || value.kind_of?( DateTime )
          value_play_at = value
        else
          # issue an error/warning here
        end
      end

      Game.create!(
        :round     => round,
        :pos       => value_pos,
        :team1     => value_teams[0],
        :score1    => value_scores[0],
        :score2    => value_scores[1],
        :score3    => value_scores[2],
        :score4    => value_scores[3],
        :score5    => value_scores[4],
        :score6    => value_scores[5],
        :team2     => value_teams[1],
        :play_at   => value_play_at,
        :group     => value_group,     # Note: group is optional (may be null/nil)
        :knockout  => value_knockout )
    end # each games
  end

  def self.create_pairs_from_ary_for_group!( pairs, group )
    
    pairs.each do |pair|
      game1_attribs = {
        :round     =>pair[0][5],
        :pos       =>pair[0][0],
        :team1     =>pair[0][1],
        :score1    =>pair[0][2][0],
        :score2    =>pair[0][2][1],
        :team2     =>pair[0][3],
        :play_at   =>pair[0][4],
        :group     =>group }

      game2_attribs = {
        :round     =>pair[1][5],
        :pos       =>pair[1][0],
        :team1     =>pair[1][1],
        :score1    =>pair[1][2][0],
        :score2    =>pair[1][2][1],
        :team2     =>pair[1][3],
        :play_at   =>pair[1][4],
        :group     =>group }
  
      game1 = Game.create!( game1_attribs )
      game2 = Game.create!( game2_attribs )

      # linkup games
      game1.next_game_id = game2.id
      game1.save!
  
      game2.prev_game_id = game1.id
      game2.save!
    end # each pair
  end

  def self.create_knockout_pairs_from_ary!( pairs, round1, round2 )
    
    pairs.each do |pair|
      game1_attribs = {
        :round     =>round1,
        :pos       =>pair[0][0],
        :team1     =>pair[0][1],
        :score1    =>pair[0][2][0],
        :score2    =>pair[0][2][1],
        :team2     =>pair[0][3],
        :play_at   =>pair[0][4] }

      game2_attribs = {
        :round     =>round2,
        :pos       =>pair[1][0],
        :team1     =>pair[1][1],
        :score1    =>pair[1][2][0],
        :score2    =>pair[1][2][1],
        :score3    =>pair[1][2][2],
        :score4    =>pair[1][2][3],
        :score5    =>pair[1][2][4],
        :score6    =>pair[1][2][5],
        :team2     =>pair[1][3],
        :play_at   =>pair[1][4],
        :knockout  =>true }
  
      game1 = Game.create!( game1_attribs )
      game2 = Game.create!( game2_attribs )

      # linkup games
      game1.next_game_id = game2.id
      game1.save!
  
      game2.prev_game_id = game1.id
      game2.save!
    end # each pair
  end


      
  def calc_toto12x
    if score1.nil? || score2.nil?
      self.toto12x = nil
    elsif score1 == score2
      self.toto12x = 'X'
    elsif score1 > score2
      self.toto12x = '1'
    elsif score1 < score2
      self.toto12x = '2'
    end
  end
  

  def over?   # game over?
    play_at <= Time.now
  end

  ## fix/todo: already added by ar magic ??? remove code
  def knockout?
    knockout == true
  end
  
  def complete?
    score1.present? && score2.present?
  end

############# convenience helpers for styling
##

  def team1_style_class
    buf = ''
    ## NB: remove if calc?
    buf << 'game-team-winner '  if complete? && (score1 >  score2)
    buf << 'game-team-draw '    if complete? && (score1 == score2)
    buf
  end
  
  def team2_style_class
    buf = ''
    ## NB: remove if calc?
    buf << 'game-team-winner '  if complete? && (score2 >  score1)
    buf << 'game-team-draw '    if complete? && (score2 == score1)
    buf
  end



end # class Game


end # module SportDB::Models
