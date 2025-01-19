
module Sports


class Match

  attr_reader :num,
              :date,
              :time,
              :team1,     :team2,      ## todo/fix: use team1_name, team2_name or similar - for compat with db activerecord version? why? why not?
              :score1,    :score2,     ## full time
              :score1i,   :score2i,    ## half time (first (i) part)
              :score1et,  :score2et,   ## extra time
              :score1p,   :score2p,    ## penalty
              :score1agg, :score2agg,  ## full time (all legs) aggregated
              :winner,    # return 1,2,0   1 => team1, 2 => team2, 0 => draw/tie
              :round,     ## todo/fix:  use round_num or similar - for compat with db activerecord version? why? why not?
              :leg,      ## e.g. '1','2','3','replay', etc.   - use leg for marking **replay** too - keep/make leg numeric?! - why? why not?
              :stage,
              :group,
              :status,    ## e.g. replay, cancelled, awarded, abadoned, postponed, etc.
              :conf1,    :conf2,      ## special case for mls e.g. conference1, conference2 (e.g. west, east, central)
              :country1, :country2,    ## special case for champions league etc. - uses FIFA country code
              :comments,
              :league,      ## (optinal) added as text for now (use struct?)
              :ground,       ## (optional) add as text line for now (incl. city, timezone etc.)
              :timezone      ## (optional) as a string

  attr_accessor :goals  ## todo/fix: make goals like all other attribs!!

  def initialize( **kwargs )
    @score1    =  @score2    = nil  ## full time
    @score1i   =  @score2i   = nil  ## half time (first (i) part)
    @score1et  =  @score2et  = nil  ## extra time
    @score1p   =  @score2p   = nil  ## penalty
    @score1agg =  @score2agg = nil  ## full time (all legs) aggregated


    update( **kwargs )  unless kwargs.empty?
  end


  def update( **kwargs )
    @num      = kwargs[:num]     if kwargs.has_key?( :num )

    ## note: check with has_key?  because value might be nil!!!
    @date     = kwargs[:date]     if kwargs.has_key?( :date )
    @time     = kwargs[:time]     if kwargs.has_key?( :time )

    ## todo/fix: use team1_name, team2_name or similar - for compat with db activerecord version? why? why not?
    @team1    = kwargs[:team1]    if kwargs.has_key?( :team1 )
    @team2    = kwargs[:team2]    if kwargs.has_key?( :team2 )

    @conf1    = kwargs[:conf1]    if kwargs.has_key?( :conf1 )
    @conf2    = kwargs[:conf2]    if kwargs.has_key?( :conf2 )
    @country1 = kwargs[:country1]  if kwargs.has_key?( :country1 )
    @country2 = kwargs[:country2]  if kwargs.has_key?( :country2 )

    ## note: round is a string!!!  e.g. '1', '2' for matchday or 'Final', 'Semi-final', etc.
    ##   todo: use to_s - why? why not?
    @round    = kwargs[:round]    if kwargs.has_key?( :round )
    @stage    = kwargs[:stage]    if kwargs.has_key?( :stage )
    @leg      = kwargs[:leg]      if kwargs.has_key?( :leg )
    @group    = kwargs[:group]    if kwargs.has_key?( :group )
    @status   = kwargs[:status]   if kwargs.has_key?( :status )
    @comments = kwargs[:comments] if kwargs.has_key?( :comments )

    @league   = kwargs[:league]   if kwargs.has_key?( :league )
    @ground   = kwargs[:ground]   if kwargs.has_key?( :ground )
    @timezone = kwargs[:timezone] if kwargs.has_key?( :timezone )


    if kwargs.has_key?( :score )   ## check all-in-one score struct for convenience!!!
      score = kwargs[:score]
      if score.nil?   ## reset all score attribs to nil!!
        @score1     = nil
        @score1i    = nil
        @score1et   = nil
        @score1p    = nil
        ## @score1agg  = nil

        @score2     = nil
        @score2i    = nil
        @score2et   = nil
        @score2p    = nil
        ## @score2agg  = nil
      else
        @score1     = score.score1
        @score1i    = score.score1i
        @score1et   = score.score1et
        @score1p    = score.score1p
        ## @score1agg  = score.score1agg

        @score2     = score.score2
        @score2i    = score.score2i
        @score2et   = score.score2et
        @score2p    = score.score2p
        ## @score2agg  = score.score2agg
      end
    else
      @score1     = kwargs[:score1]      if kwargs.has_key?( :score1 )
      @score1i    = kwargs[:score1i]     if kwargs.has_key?( :score1i )
      @score1et   = kwargs[:score1et]    if kwargs.has_key?( :score1et )
      @score1p    = kwargs[:score1p]     if kwargs.has_key?( :score1p )
      @score1agg  = kwargs[:score1agg]   if kwargs.has_key?( :score1agg )

      @score2     = kwargs[:score2]      if kwargs.has_key?( :score2 )
      @score2i    = kwargs[:score2i]     if kwargs.has_key?( :score2i )
      @score2et   = kwargs[:score2et]    if kwargs.has_key?( :score2et )
      @score2p    = kwargs[:score2p]     if kwargs.has_key?( :score2p )
      @score2agg  = kwargs[:score2agg]   if kwargs.has_key?( :score2agg )

      ## note: (always) (auto-)convert scores to integers
      @score1     = @score1.to_i      if @score1
      @score1i    = @score1i.to_i     if @score1i
      @score1et   = @score1et.to_i    if @score1et
      @score1p    = @score1p.to_i     if @score1p
      @score1agg  = @score1agg.to_i   if @score1agg

      @score2     = @score2.to_i      if @score2
      @score2i    = @score2i.to_i     if @score2i
      @score2et   = @score2et.to_i    if @score2et
      @score2p    = @score2p.to_i     if @score2p
      @score2agg  = @score2agg.to_i   if @score2agg
    end

    ## todo/fix:
    ##  gr-greece/2014-15/G1.csv:
    ##     G1,10/05/15,Niki Volos,OFI,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
    ##

    ##  for now score1 and score2 must be present
    ## if @score1.nil? || @score2.nil?
    ##  puts "** WARN: missing scores for match:"
    ##  pp kwargs
    ##  ## exit 1
    ## end

    ## todo/fix: auto-calculate winner
    # return 1,2,0   1 => team1, 2 => team2, 0 => draw/tie
    ### calculate winner - use 1,2,0
    ##
    ##  move winner calc to score class - why? why not?
    if @score1 && @score2
       if @score1 > @score2
          @winner = 1
       elsif @score2 > @score1
          @winner = 2
       elsif @score1 == @score2
          @winner = 0
       else
       end
    else
      @winner = nil   # unknown / undefined
    end

    self   ## note - MUST return self for chaining
  end



  def over?()      true; end  ## for now all matches are over - in the future check date!!!
  def complete?()  true; end  ## for now all scores are complete - in the future check scores; might be missing - not yet entered


  def score
    Score.new( @score1i,   @score2i,    ## half time (first (i) part)
               @score1,    @score2,     ## full time
               @score1et,  @score2et,   ## extra time
               @score1p,   @score2p )   ## penalty
  end


  ####
  ##  deprecated - use score.to_s and friends - why? why not?
  # def score_str    # pretty print (full time) scores; convenience method
  #  "#{@score1}-#{@score2}"
  # end

  # def scorei_str    # pretty print (half time) scores; convenience method
  #  "#{@score1i}-#{@score2i}"
  # end


def as_json
  #####
  ##  note - use string keys (NOT symbol for data keys)
  ##            for easier json compatibility
  data = {}

  ## check round
  if @round
    data['round'] = if round.is_a?( Integer )
                      "Matchday #{@round}"
                    else ## assume string
                      @round
                    end
  end


  data['num'] = @num    if @num
  if @date
    ## assume 2020-09-19 date format!!
    data['date']  = @date.is_a?( String ) ? @date : @date.strftime('%Y-%m-%d')

    data['time'] = @time  if @time
  end

  data['team1'] =  @team1.is_a?( String ) ? @team1 : @team1.name
  data['team2'] =  @team2.is_a?( String ) ? @team2 : @team2.name

  data['score'] = {}

  data['score']['ht'] = [@score1i,   @score2i]     if @score1i && @score2i
  data['score']['ft'] = [@score1,    @score2]      if @score1 && @score2
  data['score']['et'] = [@score1et,  @score2et]    if @score1et && @score2et
  data['score']['p']  = [@score1p,   @score2p]     if @score1p && @score2p

  ### check for goals
  if @goals && @goals.size > 0
    data['goals1'] = []
    data['goals2'] = []

    @goals.each do |goal|
          node = {}
          node['name']    = goal.player
          node['minute']  = goal.minute
          node['offset']  = goal.offset  if goal.offset
          node['owngoal'] = true         if goal.owngoal
          node['penalty'] = true         if goal.penalty
          
          if goal.team == 1
            data['goals1']  << node   
          else  ## assume 2
            data['goals2']  << node
          end
     end  # each goal
  end


  data['status'] = @status  if @status

  data['group']  = @group   if @group
  data['stage']  = @stage   if @stage

  if @ground
       ## note: might be array of string e.g. ['Wembley', 'London']
       data['ground'] = {}
       data['ground']['name']      = @ground
       data['ground']['timezone']  = @timezone   if @timezone
  end
  
  data
end


end  # class Match
end # module Sports


