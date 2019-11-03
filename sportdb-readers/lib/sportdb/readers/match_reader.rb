# encoding: utf-8

module SportDb

class MatchReaderV2    ## todo/check: rename to MatchReaderV2 (use plural?) why? why not?

  def self.read( path )   ## use - rename to read_file or from_file etc. - why? why not?
    txt = File.open( path, 'r:utf-8' ).read
    parse( txt )
  end

  def self.parse( txt )
    recs = LeagueOutlineReader.parse( txt )
    pp recs

    recs.each do |rec|
      league = Sync::League.find!( rec[:league] )
      season = Sync::Season.find!( rec[:season] )

      event  = Sync::Event.find!( league: league, season: season )
      if rec[:stage]
        stage = Sync::Stage.find!( rec[:stage], event: event )
        teams = stage.teams
      else
        teams = event.teams
      end

      ## hack for now: switch lang
      if ['at', 'de'].include?( league.country.key )
        SportDb.lang.lang = 'de'
      else
        SportDb.lang.lang = 'en'
      end

      ## todo/fix: set lang for now depending on league country!!!
      parser = MatchParserSimpleV2.new( rec[:lines],
                                teams,  ## note: use event OR stage teams (if stage is present)
                                event.start_at )   ## note: keep season start_at date for now (no need for more specific stage date need for now)
      round_recs, match_recs = parser.parse
      pp round_recs

      round_recs.each do |round_rec|
        round = Sync::Round.find_or_create( round_rec, event: event )  ## check: use/rename to EventRound why? why not?
      end
      match_recs.each do |match_rec|
        ## todo/fix: pass along stage (if present): stage  - optional!!!!
        match = Sync::Match.create_or_update( match_rec, event: event )
      end
    end

    recs
  end # method read
end # class MatchReaderV2
end # module SportDb
