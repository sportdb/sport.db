module SportDb
  module Model


class MatchCursor

  def initialize( matches )
    @matches = matches
  end

  def each
    state = MatchCursorState.new

    @matches.each do |match|
      state.next( match )
      yield( match, state )   # e.g. lets you use state.new_date?  or state.new_week? or state.new_year? etc.
    end
  end # method each
end # class MatchCursor


class MatchCursorState

  def initialize
    @last_date     = DateTime.new( 1971, 1, 1 )
    @new_date      = true
    @new_year      = true
    @new_week      = true
    @index         = -1   # zero-based index; thus start off with -1 (e.g. -1+=1 => 0)
  end

  attr_reader :index

  def new_date?()  @new_date; end
  def new_year?()  @new_year; end
  def new_week?()  @new_week; end


  ## add new league ?
  ## add new round  ?
  ## add new time   ?

  def next( match )
    @index += 1   # zero-based index; start off with -1 (undefined/uninitialized)
    match_date = match.date  # cache date value ref

    if @last_date.year   == match_date.year  &&
       @last_date.month  == match_date.month &&
       @last_date.day    == match_date.day
      @new_date = false
    else
      @new_date = true

      # check for new_year
      if @last_date.year == match_date.year
        @new_year = false
      else
        @new_year = true
      end

      # check for new_week
      # -- todo: find a method for week number; do NOT use strftime; there must be something easier
      # -- check if activesupport adds  .week or similar ??? use it if it exists
      if @last_date.strftime('%V') == match_date.strftime('%V')
        @new_week = false
      else
        @new_week = true
      end
    end

    @last_date = match.date
  end # method next

end # class MatchCursorState


  end # module Model
end # module SportDb
