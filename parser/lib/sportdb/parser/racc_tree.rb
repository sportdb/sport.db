
####
#   RaccMatchParser support machinery (incl. node classes/abstract syntax tree)

class RaccMatchParser

RefereeLine = Struct.new( :name, :country ) do 
  def pretty_print( printer )
    printer.text( "<RefereeLine " )
    printer.text( self.name )
    printer.text( " (#{self.country})" )  if self.country
    printer.text( ">" )
  end
end

AttendanceLine = Struct.new( :att ) do 
  def pretty_print( printer )
    printer.text( "<AttendanceLine #{self.att}>" )
  end
end



PenaltiesLine = Struct.new( :penalties ) do   
  def pretty_print( printer )
    printer.text( "<PenaltiesLine " )
    printer.text( self.penalties.pretty_inspect )
    printer.text( ">" )
  end
end

Penalty = Struct.new( :name, :score, :note ) do
  def to_s
    buf = String.new
    buf << "#{self.score} "   if self.score
    buf <<  self.name
    buf << " (#{self.note})"    if self.note 
    buf
  end

  def pretty_print( printer )
    printer.text( to_s )
  end  
end




##  find a better name for player (use bookings?) - note - red/yellow card for trainer possible
CardsLine = Struct.new( :type, :bookings ) do   
  def pretty_print( printer )
    printer.text( "<CardsLine " )
    printer.text( self.type )
    printer.text( " bookings=" + self.bookings.pretty_inspect )
    printer.text( ">" )
  end
end

Booking = Struct.new( :name, :minute ) do
  def to_s
    buf = String.new
    buf << "#{self.name}"
    buf << " #{self.minute.to_s}"   if self.minute
    buf
  end

  def pretty_print( printer )
    printer.text( to_s )
  end  
end



LineupLine = Struct.new( :team, :lineup, :coach ) do
  def pretty_print( printer )
    printer.text( "<LineupLine " )
    printer.text( self.team )
    printer.text( " lineup=" + self.lineup.pretty_inspect )
    printer.text( " coach=" + self.coach )   if self.coach
    printer.text( ">" )
  end
end


Lineup     = Struct.new( :name, :card, :sub ) do
  def pretty_print( printer )
    buf = String.new
    buf <<  self.name 
    buf << " card=" + self.card.pretty_inspect    if card
    buf << " sub=" + self.sub.pretty_inspect      if sub
    printer.text( buf ) 
  end
end


Card       = Struct.new( :name, :minute ) do
  def to_s
    buf = String.new
    buf << "#{self.name}"
    buf << " #{self.minute.to_s}"   if self.minute
    buf
  end

  def pretty_print( printer )
    printer.text( to_s )
  end  
end


Sub        = Struct.new( :minute, :sub )  do
  def pretty_print( printer )
    buf = String.new 
    buf << "("    ## note - possibly recursive (thus, let minute go first/print first/upfront)
    buf << "#{self.minute.to_s} "   if self.minute  
    buf << "#{self.sub.pretty_inspect}" 
    buf << ")"
    printer.text( buf ) 
  end
end



GroupDef   = Struct.new( :name, :teams ) do
  def pretty_print( printer )
    printer.text( "<GroupDef " )
    printer.text( self.name )
    printer.text( " teams=" + self.teams.pretty_inspect )
    printer.text( ">" )
  end
end


RoundDef   = Struct.new( :name, :date, :duration )  do
  def pretty_print( printer )
    printer.text( "<RoundDef " )
    printer.text( self.name )
    printer.text( " date=" + self.date.pretty_inspect ) if date
    printer.text( " duration=" + self.duration.pretty_inspect ) if duration
    printer.text( ">" )
  end
end

DateHeader = Struct.new( :date, :time, :geo, :timezone ) do
  def pretty_print( printer )
    printer.text( "<DateHeader " )
    printer.text( "#{self.date.pretty_inspect}" )
    printer.text( " time=#{self.time.pretty_inspect}" )          if self.time
    printer.text( " geo=#{self.geo.pretty_inspect}" )            if self.geo
    printer.text( " timezone=#{self.timezone}")             if self.timezone
    printer.text( ">")
  end
end

GroupHeader = Struct.new( :name ) do
  def pretty_print( printer )
    printer.text( "<GroupHeader " )
    printer.text( "#{self.name}>" )
  end
end

RoundHeader = Struct.new( :names, :group ) do
  def pretty_print( printer )
    printer.text( "<RoundHeader " )
    printer.text( "#{self.names.join(', ')}" )
    printer.text( " group=#{self.group}")    if self.group
    printer.text( ">" )
  end
end


RoundOutline = Struct.new( :outline ) do
  def pretty_print( printer )
    printer.text( "<RoundOutline #{self.outline}>" )
  end
end


MatchLine   = Struct.new( :ord, :date, :time, :wday,
                          :team1, :team2, 
                          :score, :score_note,
                          :status,  
                          :geo,
                          :timezone,
                          :note )  do   ## change to geos - why? why not?

  def pretty_print( printer )
    printer.text( "<MatchLine " )
    printer.text( "#{self.team1} v #{self.team2}")
    printer.breakable

    members.zip(values) do |name, value|
      next if [:team1, :team2].include?( name )
      next if value.nil?
      
      printer.text( "#{name}=#{value.pretty_inspect}" )
    end    

    printer.text( ">" )
  end  

end

## check - use a different name e.g. GoalLineScore or such - why? why not?
GoalLineAlt = Struct.new( :goals ) do
  def pretty_print( printer )
    printer.text( "<GoalLineAlt " )
    printer.text( "goals=" + self.goals.pretty_inspect + ">" )
  end  
end

GoalAlt   = Struct.new( :score, :player, :minute ) do
  def to_s
    buf = String.new
    buf << "#{score} "
    buf << "#{self.player}"
    buf << " #{self.minute}"  if self.minute
    buf
  end

  def pretty_print( printer )
    printer.text( to_s )
  end  
end



GoalLine    = Struct.new( :goals1, :goals2 ) do
  def pretty_print( printer )
    printer.text( "<GoalLine " )
    printer.text( "goals1=" + self.goals1.pretty_inspect + "," )
    printer.breakable
    printer.text( "goals2=" + self.goals2.pretty_inspect + ">" )
  end  
end

Goal        = Struct.new( :player, :minutes ) do
  def to_s
    buf = String.new
    buf << "#{self.player}"
    buf << " "
    buf << minutes.map { |min| min.to_s }.join(' ')
    buf
  end

  def pretty_print( printer )
    printer.text( to_s )
  end  

end


##
##  fix - move :og, :pen  to Goal if possible - why? why not?
##  or change to GoalMinute ???
Minute      = Struct.new( :m, :offset, :og, :pen )  do
    def to_s
      buf = String.new
      buf << "#{self.m}"
      buf << "+#{self.offset}"  if self.offset 
      buf << "'"
      buf << "(og)"   if self.og
      buf << "(pen)"  if self.pen
      buf
    end
 
    def pretty_print( printer ) 
       printer.text( to_s ) 
    end  
end

end  # class RaccMatchParser