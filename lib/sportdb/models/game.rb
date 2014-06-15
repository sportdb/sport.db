
module SportDb
  module Model


class Game < ActiveRecord::Base

  belongs_to :team1, class_name: 'Team', foreign_key: 'team1_id'
  belongs_to :team2, class_name: 'Team', foreign_key: 'team2_id'
  
  belongs_to :round
  belongs_to :group   # group is optional
  
  belongs_to :ground  # ground is optional
  belongs_to :city,  class_name: 'WorldDb::Model::City', foreign_key: 'city_id'   # city   is optioanl (remove?? redundant?? use ground ??)

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



  ## winner after extra time  (will ignore possible penalty shootout; used for alltime standings in world cup calc, for example)
  ## - also add winnerp nil,1,2   => nil -> no penalty shoutout (or no scores) -- needed for what?
  def winneret
      ## check for extra time
      if score1et.present? && score2et.present?
        if score1et > score2et
          1
        elsif score1et < score2et
          2
        else # assume score1et == score2et - draw
          0
        end
      else
        nil  # no extra time; note: return nil  use  winneret || winner90 to get result for both extra time or if not present regular time
      end
  end


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
  
  def score1ot() score1et  end
  def score2ot() score2et  end

  def score1ot=(value) self.score1et = value  end
  def score2ot=(value) self.score2et = value  end


  # game over?
  def over?()     play_at <= Time.now;  end
  ## fix/todo: already added by ar magic ??? remove code
  def knockout?() knockout == true;  end
  def complete?() score1.present? && score2.present?;  end


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


  end # module Model
end # module SportDb
