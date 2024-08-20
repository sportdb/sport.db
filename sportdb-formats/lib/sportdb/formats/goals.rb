
module SportDb

class GoalStruct
  ######
  # flat struct for goals - one entry per goals
  attr_accessor :name
  attr_accessor :team   #  1 or 2 ? check/todo: add team1 or team2 flag?
  attr_accessor :minute, :offset
  attr_accessor :penalty, :owngoal
  attr_accessor :score1, :score2  # gets calculated

  ## add pos  for sequence number? e.g. 1,2,3,4  (1st goald, 2nd goal, etc.) ???


  def initialize( **kwargs )    ## add/allow quick and dirty quick init with keywords
    if kwargs.empty?
      # do nothing
    else
      kwargs.each do |key,value|
        send( "#{key}=", value )
      end
    end
  end

  def ==(o)
    o.class == self.class && o.state == state
  end

  def state
    [@name, @team, @minute, @offset, @penalty, @owngoal, @score1, @score2]
  end


  def pretty_print( printer )
    buf = String.new
    buf << "<GoalStruct: #{@score1}-#{@score2} #{@name} #{@minute}"
    buf << "+#{@offset}"    if @offset && @offset > 0
    buf << "'"
    buf << " (o.g.)"  if @owngoal
    buf << " (pen.)"  if @penalty
    buf << " for #{@team}"     ### team 1 or 2 - use home/away
    buf << ">"

    printer.text( buf )
  end
end
end # module SportDb
