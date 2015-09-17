# encoding: UTF-8


module SportDb


class CsvGameReader

  include LogUtils::Logging

## make models available by default with namespace
#  e.g. lets you use Usage instead of Model::Usage
  include Models

  ##
  ## todo: add from_file and from_zip too

  def self.from_string( event_key, text )
    ### fix - fix -fix:
    ##  change event to event_or_event_key !!!!!  - allow event_key as string passed in
    self.new( event_key, text )
  end

  def initialize( event_key, text )
    ### fix - fix -fix:
    ##  change event to event_or_event_key !!!!!  - allow event_key as string passed in

    ## todo/fix: how to add opts={} ???
    @event_key         = event_key
    @text              = text
  end


  def read
    ## note: assume active activerecord connection
    @event = Event.find_by!( key: @event_key )

    logger.debug "Event #{@event.key} >#{@event.title}<"

    @team_mapper = TextUtils::TitleMapper.new( @event.teams, 'team' )

    ## reset cached values
    @patch_round_ids = []

    @last_round    = nil      ## remove last round ?? - always required - why? why not?
    @last_date     = nil      ## remove last date ??  - always required - why? why not?
    
    parse_fixtures   
  end   # method load_fixtures


  def handle_round( round_pos_str )

    round_pos = round_pos_str.to_i

    round_attribs = { }

    round = Round.find_by( event_id: @event.id,
                           pos:      round_pos )

    if round.present?
      logger.debug "update round #{round.id}:"
    else
      logger.debug "create round:"
      round = Round.new
          
      round_attribs = round_attribs.merge( {
        event_id: @event.id,
        pos:      round_pos,
        title:    "Round #{round_pos}",
        title2:   nil,
        knockout: false,
        start_at: Date.parse('1911-11-11'),
        end_at:   Date.parse('1911-11-11')
      })
    end

    logger.debug round_attribs.to_json
   
    round.update_attributes!( round_attribs )

    ### store list of round ids for patching start_at/end_at at the end
    @patch_round_ids << round.id
    @last_round = round     ## keep track of last seen round for matches that follow etc.
  end

  def handle_game( date_str, team1_str, team2_str, ft_str, ht_str )

    ## todo/fix: make more "efficient"
    ##  - e.g. add new support method for mapping single team/reference - why? why not??
    line = "#{team1_str} - #{team2_str}"
    @team_mapper.map_titles!( line )
    team1_key = @team_mapper.find_key!( line )
    team2_key = @team_mapper.find_key!( line )

    ## note: if we do NOT find two teams; return false - no match found
    if team1_key.nil? || team2_key.nil?
      fail "  no game match (two teams required) found for line: >#{line}<"
    end

    if date_str
      date = DateTime.strptime( date_str, '%Y-%m-%d' )   ## (always) use DateTime - why? why not??
      @last_date = date    # keep a reference for later use
    else
      date = @last_date    # no date found; (re)use last seen date
    end

    ##
    ## todo: support for awarded, abadoned, a.e.t, pen. etc. - why?? why not??
    ## 

    if ht_str    ## half time scores
      scoresi_str = ht_str.gsub(/ /, '').split('-')    ## note: remove all (inline) spaces first
      score1i  = scoresi_str[0].to_i
      score2i  = scoresi_str[1].to_i
    else
      score1i  = nil
      score2i  = nil
    end

    if ft_str    ## full time scores
      scores_str = ft_str.gsub(/ /, '').split('-')    ## note: remove all (inline) spaces first
      score1  = scores_str[0].to_i
      score2  = scores_str[1].to_i
    else
      score1  = nil
      score2  = nil
    end
    
    ### todo: cache team lookups in hash? - why? why not??
    team1 = Team.find_by!( key: team1_key )
    team2 = Team.find_by!( key: team2_key )

    round = @last_round

    ### check if games exists
    ##  with this teams in this round if yes only update
    game = Game.find_by( round_id: round.id,
                         team1_id: team1.id,
                         team2_id: team2.id )
                          
    game_attribs = {
      score1:     score1,
      score2:     score2,
      score1i:    score1i,
      score2i:    score2i,
      play_at:    date,
      play_at_v2: nil,
      postponed:  false,
      knockout:   false,  ## round.knockout, ## note: for now always use knockout flag from round - why? why not?? 
      ground_id:  nil,
      group_id:   nil
    }

    if game.present?
      logger.debug "update game #{game.id}:"
    else
      logger.debug "create game:"
      game = Game.new

      ## Note: use round.games.count for pos
      ##  lets us add games out of order if later needed
      more_game_attribs = {
        round_id: round.id,
        team1_id: team1.id,
        team2_id: team2.id,
        pos:      round.games.count+1
      }
      game_attribs = game_attribs.merge( more_game_attribs )
    end

    logger.debug game_attribs.to_json
    game.update_attributes!( game_attribs )
    
  end # method handle_game


  def parse_fixtures

    CSV.parse( @text, headers: true ) do |row|
      puts row.inspect
      
      pp round = row['Round']
      pp date  = row['Date']
      pp team1 = row['Team 1']
      pp team2 = row['Team 2']
      pp ft    = row['FT']
      pp ht    = row['HT']
      
      ## find round by pos
      if round
        handle_round( round )
        handle_game( date, team1, team2, ft, ht )
      else
        fail "round required for import; sorry"
      end
    end

    ###########################
    # backtrack and patch round dates (start_at/end_at)

    unless @patch_round_ids.empty?
      ###
      # note: use uniq - to allow multiple round headers (possible?)

      Round.find( @patch_round_ids.uniq ).each do |r|
        logger.debug "patch round start_at/end_at date for #{r.title}:"

        ## note:
        ## will add "scope" pos first e.g
        #
        ## SELECT "games".* FROM "games"  WHERE "games"."round_id" = ?
        # ORDER BY pos, play_at asc  [["round_id", 7]]
        #   thus will NOT order by play_at but by pos first!!!
        # =>
        #  need to unscope pos!!! or use unordered_games - games_by_play_at_date etc.??
        #   thus use reorder()!!! - not just order('play_at asc')

        games = r.games.reorder( 'play_at asc' ).all

        ## skip rounds w/ no games

        ## todo/check/fix: what's the best way for checking assoc w/ 0 recs?
        next if games.size == 0

        # note: make sure start_at/end_at is date only (e.g. use play_at.to_date)
        #   sqlite3 saves datetime in date field as datetime, for example (will break date compares later!)

        round_attribs = {
          start_at: games[0].play_at.to_date,   # use games.first ?
          end_at:   games[-1].play_at.to_date  # use games.last ? why? why not?
        }

        logger.debug round_attribs.to_json
        r.update_attributes!( round_attribs )
      end
    end
  end # method parse_fixtures

end # class CsvGameReader
end # module SportDb
