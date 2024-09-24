#####
## quick match linter for datafiles with league outlines


module SportDb
class QuickMatchLinter

  def self.debug=(value) @@debug = value; end
  def self.debug?() @@debug ||= false; end  ## note: default is FALSE
  def debug?()  self.class.debug?; end



  def self.read( path )   ## use - rename to read_file or from_file etc. - why? why not?
    txt = File.open( path, 'r:utf-8' ) {|f| f.read }
    parse( txt )
  end

  def self.parse( txt )
    new( txt ).parse
  end


  include Logging

  def initialize( txt )
    @errors = []
    @txt = txt
  end

  attr_reader :errors
  def errors?() @errors.size > 0; end



  CLUB_NAME_RE =  %r{^
          (?<name>[^()]+?)     ## non-greedy
          (?:
             \s+
             \(
               (?<code>[A-Z][A-Za-z]{2,3})    ## optional (country) code; support single code e.g. (A) - why? why not?
             \)
          )?
        $}x   ## note - allow (URU) and (Uru) - why? why not


  def parse
    ## note: every (new) read call - resets errors list to empty
    @errors = []

    data = {}   # return data hash with leagues
                #    and seasons
                #   for now merge stage into matches

    secs = QuickLeagueOutlineReader.parse( @txt )
    pp secs    if debug?

    secs.each do |sec|   ## sec(tion)s
      season = Season.parse( sec[:season] )   ## convert (str) to season obj!!!
      league = sec[:league]
      stage  = sec[:stage]
      lines  = sec[:lines]

      start =  if season.year?
                  Date.new( season.start_year, 1, 1 )
                else
                  Date.new( season.start_year, 7, 1 )
                end

###
##      db check - check league
##       fix/fix - add season to match_by   !!!!!!!
      recs =  Import::League.match_by( name: league )
      league_rec = nil
      if recs.size == 1
        league_rec = recs[0]
        puts "     OK #{league} => #{league_rec.name}"
      elsif recs.size == 0
        msg = "NAME ERROR - no league match found for >#{league}<"
        @errors << [msg]
        puts "!! #{msg}"
    else
        msg = "NAME ERROR - ambigous; too many league matches (#{recs.size}) found for >#{league}<"
        @errors << [msg]
        puts "!! #{msg}"
    end


      parser = MatchParser.new( lines,
                                start )   ## note: keep season start_at date for now (no need for more specific stage date need for now)

      auto_conf_teams,  matches, rounds, groups = parser.parse

      ## auto-add "upstream" errors from parser
      @errors += parser.errors  if parser.errors?


      if debug?
        puts ">>> #{auto_conf_teams.size} teams:"
        pp auto_conf_teams
        puts ">>> #{matches.size} matches:"
        ## pp matches
        puts ">>> #{rounds.size} rounds:"
        pp rounds
        puts ">>> #{groups.size} groups:"
        pp groups
      end

###
##      db check - check teams
##     only clubs for now
##       fix add better support for champs etc
##               and national teams!!!
    auto_conf_teams.each do |team|
      recs =  if league_rec && !league_rec.intl?
                 Import::Club.match_by( name: team, league: league_rec )
              else
                 ###
                 ##  get country code from name
                 ##    e.g. Liverpool FC (ENG) or
                 ##         Liverpool FC (URU) etc.

                 ## check for country code
                 if m=CLUB_NAME_RE.match( team )
                   if m[:code]
                     Import::Club.match_by( name:    m[:name],
                                            country: m[:code] )
                   else
                      msg = "PARSE ERROR - country code missing for club name in int'l tournament; may not be unique >#{team}<"
                      @errors << [msg]
                      Import::Club.match_by( name: team )
                    end
                 else
                   msg = "PARSE ERROR - invalid club name; cannot match with CLUB_NAME_RE >#{team}<"
                   @errors << [msg]
                   []
                 end
              end
        team_rec = nil
        if recs.size == 1
          team_rec = recs[0]
          puts "     OK #{team} => #{team_rec.name}, #{team_rec.country.name}"
        elsif recs.size == 0
          msg = "NAME ERROR - no team match found for >#{team}<"
          @errors << [msg]
          puts "!! #{msg}"
        else
          msg = "NAME ERROR - ambigous; too many team matches (#{recs.size}) found for >#{team}<"
          @errors << [msg]
          puts "!! #{msg}"
        end
    end





      ## note: pass along stage (if present): stage  - optional from heading!!!!
      if stage
        matches.each do |match|
          match = match.update( stage: stage )
        end
      end

      data[ league ] ||= {}
      data[ league ][ season.key ] ||= []

      data[ league ][ season.key ] += matches
      ## note - skip teams, rounds, and groups for now
    end

## check - only one league and one season
##             allowed in quick style


    leagues = data.keys
    if leagues.size != 1
        puts "!! (QUICK) PARSE ERROR - expected one league only; got #{leagues.size}:"
        pp leagues
        exit 1
    end

    seasons = data[ leagues[0] ].keys
    if seasons.size != 1
        puts "!! (QUICK) PARSE ERROR - expected one #{leagues[0]} season only; got #{seasons.size}:"
        pp seasons
        exit 1
    end

    data[ leagues[0] ][ seasons[0] ]
  end # method parse

end # class QuickMatchLinter
end # module SportDb

