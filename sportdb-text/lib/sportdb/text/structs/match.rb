# encoding: utf-8



module SportDb
  module Struct


class Match

  attr_reader :date,
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
              :conf1,    :conf2,      ## special case for mls e.g. conference1, conference2 (e.g. west, east, central)
              :country1, :country2,    ## special case for champions league etc. - uses FIFA country code
              :comments

  def initialize( **kwargs )
    update( kwargs )  unless kwargs.empty?
  end

  def self.create( **kwargs )    ## keep using create why? why not?
    self.new.update( kwargs )
  end


  def update( **kwargs )
    ## note: check with has_key?  because value might be nil!!!
    @date     = kwargs[:date]     if kwargs.has_key? :date
    @team1    = kwargs[:team1]    if kwargs.has_key? :team1
    @team2    = kwargs[:team2]    if kwargs.has_key? :team2
    @conf1    = kwargs[:conf1]    if kwargs.has_key? :conf1
    @conf2    = kwargs[:conf2]    if kwargs.has_key? :conf2
    @country1 = kwargs[:country1]  if kwargs.has_key? :country1
    @country2 = kwargs[:country2]  if kwargs.has_key? :country2

    ## note: round is a string!!!  e.g. '1', '2' for matchday or 'Final', 'Semi-final', etc.
    ##   todo: use to_s - why? why not?
    @round    = kwargs[:round]    if kwargs.has_key? :round
    @stage    = kwargs[:stage]    if kwargs.has_key? :stage
    @leg      = kwargs[:leg]      if kwargs.has_key? :leg
    @group    = kwargs[:group]    if kwargs.has_key? :group
    @comments = kwargs[:comments] if kwargs.has_key? :comments


    @score1     = kwargs[:score1]      if kwargs.has_key? :score1
    @score1i    = kwargs[:score1i]     if kwargs.has_key? :score1i
    @score1et   = kwargs[:score1et]    if kwargs.has_key? :score1et
    @score1p    = kwargs[:score1p]     if kwargs.has_key? :score1p
    @score1agg  = kwargs[:score1agg]   if kwargs.has_key? :score1agg

    @score2     = kwargs[:score2]      if kwargs.has_key? :score2
    @score2i    = kwargs[:score2i]     if kwargs.has_key? :score2i
    @score2et   = kwargs[:score2et]    if kwargs.has_key? :score2et
    @score2p    = kwargs[:score2p]     if kwargs.has_key? :score2p
    @score2agg  = kwargs[:score2agg]   if kwargs.has_key? :score2agg

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


    ## todo/fix:
    ##  gr-greece/2014-15/G1.csv:
    ##     G1,10/05/15,Niki Volos,OFI,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
    ##

    ##  for now score1 and score2 must be present
    if @score1.nil? || @score2.nil?
      puts "*** missing scores for match:"
      pp kwargs
      ## exit 1
    end

    ## todo/fix: auto-calculate winner
    # return 1,2,0   1 => team1, 2 => team2, 0 => draw/tie
    ### calculate winner - use 1,2,0
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


  def score_str    # pretty print (full time) scores; convenience method
    "#{@score1}-#{@score2}"
  end

  def scorei_str    # pretty print (half time) scores; convenience method
    "#{@score1i}-#{@score2i}"
  end

end  # class Match
end # module Struct

end # module SportDb
