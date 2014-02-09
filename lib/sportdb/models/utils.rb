module SportDb
  module Model


class GameCursor

  def initialize( games )
    @games = games
  end

  def each
    state = GameCursorState.new 

    @games.each do |game|
      state.next( game )
      yield( game, state )   # e.g. lets you use state.new_date?  or state.new_week? or state.new_year? etc.
    end
  end # method each
end # class GameCursor


class GameCursorState

  def initialize
    @last_play_at  = DateTime.new( 1971, 1, 1 )
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
    
  def next( game )
    @index += 1   # zero-based index; start off with -1 (undefined/uninitialized)
    game_play_at = game.play_at  # cache play_at value ref

    if @last_play_at.year   == game_play_at.year  &&
       @last_play_at.month  == game_play_at.month &&
       @last_play_at.day    == game_play_at.day
      @new_date = false
    else
      @new_date = true
        
      # check for new_year
      if @last_play_at.year == game_play_at.year
        @new_year = false
      else
        @new_year = true
      end
        
      # check for new_week
      # -- todo: find a method for week number; do NOT use strftime; there must be something easier
      # -- check if activesupport adds  .week or similar ??? use it if it exists
      if @last_play_at.strftime('%V') == game_play_at.strftime('%V')
        @new_week = false
      else
        @new_week = true
      end
    end

    @last_play_at = game.play_at
  end # method next
    
end # class GameCursorState


  end # module Model
end # module SportDb
