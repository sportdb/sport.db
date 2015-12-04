# encoding: UTF-8

##
## note: for now lets only support leagues with rounds (no cups/knockout rounds n groups)
##     (re)add later when needed (e.g. for playoffs etc.)


module SportDb


class RsssfGameReader    ### todo: rename to RsssfLeagueMatchReader ( or use league/cup option?) - why? why not??

  include LogUtils::Logging

## make models available by default with namespace
#  e.g. lets you use Usage instead of Model::Usage
  include Models

  ##
  ## todo: add from_file and from_zip too

  def self.from_string( event_or_event_key, text )
    self.new( event_or_event_key, text )
  end

  def initialize( event_or_event_key, text )
    ## todo/fix: how to add opts={} ???
    @event_or_event_key = event_or_event_key
    @text               = text
  end


  def read
    ## note: assume active activerecord connection
    
    if @event_or_event_key.kind_of?( Event )
      @event= @event_or_event_key
    else   ## assume string
      @event = Event.find_by!( key: @event_or_event_key )
    end

    logger.debug "Event #{@event.key} >#{@event.title}<"

    @mapper_teams = TeamMapper.new( @event.teams )

    ## reset cached values
    @patch_round_ids = []

    @last_round    = nil
    @last_date     = nil
    
    reader = LineReader.from_string( @text )
    parse_fixtures( reader )    
  end   # method load_fixtures



  RSSSF_FT_REGEX = /\b
             (?<score1>\d{1,2})
                -
             (?<score2>\d{1,2})
               \b/x

  def find_rsssf_scores!( line ) 
    # e.g. 1-1 or 0-2 or 3-3
    
    m = RSSSF_FT_REGEX.match( line )
    if m
      score1 = m[:score1].to_i
      score2 = m[:score2].to_i

      logger.debug "   score: >#{score1}-#{score2}<"
      
      line.sub!( m[0], '[SCORE]' )
    else
      score1   = nil
      score2   = nil  
    end

    scores = [score1, score2]
    scores
  end  # method find_rsssf_scores!


  def find_rsssf_date!( line, opts={} )
    finder = RsssfDateFinder.new
    finder.find!( line, opts )
  end


  RSSSF_ROUND_REGEX = /\b
               (?<round>Round)
                  \s
               (?<pos>\d{1,3})
                  \b/x   

  def is_rsssf_round?( line )
    RSSSF_ROUND_REGEX.match( line ).nil? == false   ## match found if not nil
  end

  def find_rsssf_round!( line )
    ## todo: check if \b works for run on [Apr 13] too ??
    ## todo:  allow multiple spaces after round ??

    m = RSSSF_ROUND_REGEX.match( line )
    if m
      title = m[0]     ## note: title is complete match e.g. Round 1, Round 2, etc.
      pos   = m[:pos].to_i

      logger.debug "   title: >#{title}<, pos: >#{pos}<"
      
      line.sub!( m[0], '[ROUND]' )
    else
      ## fix: add logger.warn no round pos found in line
      title = nil
      pos   = nil
    end
    
    [title,pos]   ## return array; note: [nil,nil] if nothing found
  end # method find_rsssf_round!


  def parse_round_header( line )

    ## todo/fix:
    ##   simplify - for now round number always required
    #      e.g. no auto-calculation supported here
    #       fail if round found w/o number/pos !!!
    #
    #  also remove knockout flag for now (set to always false for now)
    
    logger.debug "parsing round header line: >#{line}<"

    ## check for date in header first e.g. Round 36 [Jul 20]  !!
    ##   avoid "conflict" with getting "wrong" round number from date etc.
    date = find_rsssf_date!( line, start_at: @event.start_at )
    if date
      @last_date = date
    end
    
    title, pos = find_rsssf_round!( line )

    ## check if pos available; if not auto-number/calculate
    if pos.nil?
        logger.error( "  no round pos found in line >#{line}<; round pos required in rsssf; sorry" )
        fail( "round pos required in rsssf; sorry")
    end

    logger.debug "  line: >#{line}<"
        
    ## Note: dummy/placeholder start_at, end_at date
    ##  replace/patch after adding all games for round

    round_attribs = {
      title:    title,
      title2:   nil,
      knockout: false
    }

    round = Round.find_by( event_id: @event.id,
                           pos:      pos )

    if round.present?
      logger.debug "update round #{round.id}:"
    else
      logger.debug "create round:"
      round = Round.new
          
      round_attribs = round_attribs.merge( {
        event_id: @event.id,
        pos:      pos,
        ##  todo: add num e.g. num == pos for round 1, round 2, etc. - why? why not??
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


  def try_parse_game( line )
    # note: clone line; for possible test do NOT modify in place for now
    # note: returns true if parsed, false if no match
    parse_game( line.dup )
  end

  def parse_game( line )
    logger.debug "parsing game (fixture) line: >#{line}<"

    @mapper_teams.map_teams!( line )
    team_keys = @mapper_teams.find_teams!( line ) 
    team1_key = team_keys[0]
    team2_key = team_keys[1]

    ## note: if we do NOT find two teams; return false - no match found
    if team1_key.nil? || team2_key.nil?
      logger.debug "  no game match (two teams required) found for line: >#{line}<"
      return false
    end

    date      = find_rsssf_date!( line, start_at: @event.start_at )

    ###
    # check if date found?
    #   note: ruby falsey is nil & false only (not 0 or empty array etc.)
    if date
      @last_date = date    # keep a reference for later use
    else
      date = @last_date    # no date found; (re)use last seen date
    end

    scores = find_rsssf_scores!( line )

    logger.debug "  line: >#{line}<"


    ### todo: cache team lookups in hash?
    team1 = Team.find_by!( key: team1_key )
    team2 = Team.find_by!( key: team2_key )

    round = @last_round

    ### check if games exists
    ##  with this teams in this round if yes only update
    ##
    ##  todo: add replay flag (true/false)    !!!!!!!!
    ##    allows same match fixture in round  !!!!!!!!
    game = Game.find_by( round_id: round.id,
                         team1_id: team1.id,
                         team2_id: team2.id )
                          
    game_attribs = {
      score1:    scores[0],
      score2:    scores[1],
      score1et:  scores[2],
      score2et:  scores[3],
      score1p:   scores[4],
      score2p:   scores[5],
      play_at:    date,
      play_at_v2: nil,
      postponed:  false,
      knockout:   false,  ## round.knockout, ## note: for now always use knockout flag from round - why? why not?? 
      ground_id: nil,
      group_id:  nil
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
    
    return true   # game match found
  end # method parse_game


  def try_parse_date_header( line )
    # note: clone line; for possible test do NOT modify in place for now
    # note: returns true if parsed, false if no match
    parse_date_header( line.dup )
  end

  def parse_date_header( line )
    # note: returns true if parsed, false if no match
 
    # line with NO teams  plus include date e.g.
    #   [Jun 17]  etc.

    @mapper_teams.map_teams!( line )
    team_keys= @mapper_teams.find_teams!( line )
    team1_key = team_keys[0]
    team2_key = team_keys[1]

    date  = find_rsssf_date!( line, start_at: @event.start_at )

    if date && team1_key.nil? && team2_key.nil?
      logger.debug( "date header line found: >#{line}<")
      logger.debug( "    date: #{date}")
      
      @last_date = date   # keep a reference for later use
      return true
    else
      return false
    end
  end



  def parse_fixtures( reader )
      
    reader.each_line do |line|

      if is_rsssf_round?( line )
        parse_round_header( line )
      elsif try_parse_game( line )
        # do nothing here
      elsif try_parse_date_header( line )
        # do nothing here
      else
        logger.info "skipping line (no match found): >#{line}<"
      end
    end # lines.each

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

end # class RsssfGameReader
end # module SportDb
