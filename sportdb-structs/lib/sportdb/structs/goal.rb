
module Sports

class Goal  ### nested (non-freestanding) inside match (match is parent)
  attr_reader :score1,
              :score2,
              :team,
              :player,
              :minute,
              :offset,
              :owngoal,
              :penalty,
              :notes

  ## add alias for player => name - why? why not?
  alias_method :name, :player


  def owngoal?() @owngoal==true; end
  def penalty?() @penalty==true; end
  def team1?()   @team == 1; end
  def team2?()   @team == 2; end


  ## note: make score1,score2 optional for now !!!!
  def initialize( team:,
                  player:,
                  minute:,
                  offset:  nil,
                  owngoal: false,
                  penalty: false,
                  score1:  nil,
                  score2:  nil,
                  notes:   nil
                )
    @score1  = score1
    @score2  = score2

    @team    = team     # 1 or 2
    @player  = player
    @minute  = minute
    @offset  = offset
    @owngoal = owngoal
    @penalty = penalty
    @notes   = notes
  end

  def state
    [@score1, @score2,
     @team,
     @player, @minute, @offset, @owngoal, @penalty,
     @notes
     ]
  end

  def ==(o)
    o.class == self.class && o.state == state
  end

  def pretty_print( printer )
    buf = String.new
    buf << "<Goal: #{@score1 ? @score1 : '?'}-#{@score2 ? @score2 : '?'}"
    buf << " #{@player} #{@minute}"
    buf << "+#{@offset}"    if @offset && @offset > 0
    buf << "'"
    buf << " (o.g.)"  if @owngoal
    buf << " (pen.)"  if @penalty
    buf << " for #{@team}"     ### team 1 or 2 - use home/away
    buf << " -- #{@notes}"   if @notes
    buf << ">"

    printer.text( buf )
  end
end # class Goal


end # module Sports

