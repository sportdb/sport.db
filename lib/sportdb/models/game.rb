module SportDb::Models


class Game < ActiveRecord::Base

  belongs_to :team1, :class_name => 'Team', :foreign_key => 'team1_id'
  belongs_to :team2, :class_name => 'Team', :foreign_key => 'team2_id'
  
  belongs_to :round
  belongs_to :group   # group is optional
  
  has_many :goals

  before_save :calc_winner


  def toto12x() toto1x2; end # alias for toto12x - todo/fix: use ruby alias helper
  def toto1x2
    ## note: will return string e.g. 1-X-2 (winner will return int e.g. 1-0-2)
    
    ## fix: use switch/when expr/stmt instead of ifs
    value = winner90   # 1 0 2  1 => team 1 0 => draw 2 => team
    if value == 0
      'X'
    elsif value == 1
      '1'
    elsif value == 2
      '2'
    elsif value == -1
      nil  # ??? - unknown -- include --??? why? why not??
    else
      nil
    end
  end


  def winner1?() winner == 1; end
  def winner2?() winner == 2; end
  def draw?   () winner == 0; end    # use different name; use an alias (any better names more speaking???)


  def calc_winner
    if score1.nil? || score2.nil?
      self.winner90 = nil
      self.winner   = nil
    else
      if score1 > score2
        self.winner90 = 1
      elsif score1 < score2
        self.winner90 = 2
      else # assume score1 == score2 - draw
        self.winner90 = 0
      end

      ## todo/fix:
      #  check for next-game/pre-game !!!
      #    use 1st leg and 2nd leg - use for winner too
      #  or add new winner_total or winner_aggregated method ???

      ## check for penalty  - note: some games might only have penalty and no extra time (e.g. copa liberatadores)
      if score1p.present? && score2p.present?
        if score1p > score2p
          self.winner = 1
        elsif score1p < score2p
          self.winner = 2
        else
          # issue warning! - should not happen; penalty goes on until winner found!
          puts "*** warn: should not happen; penalty goes on until winner found"
        end
      ## check for extra time
      elsif score1et.present? && score2et.present?
        if score1et > score2et
          self.winner = 1
        elsif score1et < score2et
          self.winner = 2
        else # assume score1et == score2et - draw
          self.winner = 0
        end
      else
        # assume no penalty and no extra time; same as 90min result
        self.winner = self.winner90
      end
    end
  end


  ### getter/setters for deprecated attribs (score3,4,5,6) n national
  
  def score3
    score1et
  end

  def score4
    score2et
  end
  
  def score1ot
    score1et
  end

  def score2ot
    score2et
  end

  def score5
    score1p
  end

  def score6
    score2p
  end

  def score3=(value)
    self.score1et = value
  end

  def score4=(value)
    self.score2et = value
  end

  def score1ot=(value)
    self.score1et = value
  end

  def score2ot=(value)
    self.score2et = value
  end

  def score5=(value)
    self.score1p = value
  end

  def score6=(value)
    self.score2p = value
  end



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
        :score1et  => value_scores[2],
        :score2et  => value_scores[3],
        :score1p   => value_scores[4],
        :score2p   => value_scores[5],
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
        :score1et  =>pair[1][2][2],
        :score2et  =>pair[1][2][3],
        :score1p   =>pair[1][2][4],
        :score1p   =>pair[1][2][5],
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

    ### fix: loser
    ## - add method for checking winner/loser on ko pairs using (1st leg/2nd leg totals) ??
    ## use new winner_total method ??
 
    if complete?
      if winner1?
        buf << 'game-team-winner '
      elsif winner2?
        buf << 'game-team-loser '
      else # assume draw
        buf << 'game-team-draw '
      end
    end
    
    buf << 'game-knockout '     if knockout?
    buf
  end

  def team2_style_class
    buf = ''
    ## NB: remove if calc?

    ### fix: loser
    ## - add method for checking winner/loser on ko pairs using (1st leg/2nd leg totals) ??
    ## use new winner_total method ??

    if complete?
      if winner1?
        buf << 'game-team-loser '
      elsif winner2?
        buf << 'game-team-winner '
      else # assume draw
        buf << 'game-team-draw '
      end
    end

    buf << 'game-knockout '     if knockout?
    buf
  end


  def play_at_str( format = nil )
    ## e.g. use like
    #  play_at_str  or
    #  play_at_str( :db ) etc.
    if format == :db
      play_at.strftime( '%Y-%m-%d %H:%M %z' )  # NB: removed seconds (:%S)
    else
      play_at.strftime( "%a. %d. %b. / %H:%M" )
    end
  end


  def score_str
    ## return ' - ' if score1.nil? && score2.nil?

    # note: make after extra time optional;
    # e.g. copa liberatadores only has regular time plus penalty, for example

    buf = ""

    buf << "#{score1_str} : #{score2_str}"
    buf << " / #{score1et_str} : #{score2et_str} n.V."  if score1et.present? || score2et.present?
    buf << " / #{score1p_str} : #{score2p_str} i.E."    if score1p.present?  || score2p.present?

    buf
  end

  def score1_str()  score1.nil? ? '-' : score1.to_s;  end
  def score2_str()  score2.nil? ? '-' : score2.to_s;  end

  def score1et_str()  score1et.nil? ? '-' : score1et.to_s;  end
  def score2et_str()  score2et.nil? ? '-' : score2et.to_s;  end

  def score1p_str()  score1p.nil? ? '-' : score1p.to_s;  end
  def score2p_str()  score2p.nil? ? '-' : score2p.to_s;  end



  ## todo/fix: find a better name?
  ##  todo: move to utils for reuse?
  
  def check_for_changes( new_attributes )
    changes_counter = 0
    new_attributes.each do |key,new_value|
      old_value = attributes[ key.to_s ]
      ## todo/fix: also check for class/type matching ????
      if new_value == old_value
        # do nothing
      else
        changes_counter +=1
        puts "change #{changes_counter} for #{key} old:>#{old_value}< : #{old_value.class.name} new:>#{new_value}< : #{new_value.class.name}"
      end
    end
    
    # no changes found for counter==0;
    # -- otherwise x changes found; return true
    changes_counter == 0 ? false : true
  end

end # class Game


end # module SportDb::Models
