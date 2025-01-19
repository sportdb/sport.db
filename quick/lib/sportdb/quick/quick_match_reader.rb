#####
## quick match reader for datafiles with league outlines

module SportDb
class QuickMatchReader

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
    @outline = QuickLeagueOutline.parse( txt )
  end

  attr_reader :errors
  def errors?() @errors.size > 0; end


  ###
  #  helpers get matches & more after parse; all stored in data
  #
  ## change/rename to event - why? why not?
  def league_name
     league = @data.keys[0]
     season = @data[ league ].keys[0]

     "#{league} #{season}"
  end

  def matches
    league = @data.keys[0]
    season = @data[ league ].keys[0]
    @data[league][season]
  end



  def parse
    ## note: every (new) read call - resets errors list to empty
    @errors = []

    @data = {}   # return data hash with leagues
                 #    and seasons
                 #   for now merge stage into matches

    @outline.each_sec do |sec|   ## sec(tion)s
      ### move season parse into outline upstream - why? why not?
      season = Season.parse( sec.season )   ## convert (str) to season obj!!!
      league = sec.league
      stage  = sec.stage
      lines  = sec.lines

      start =  if season.year?
                  Date.new( season.start_year, 1, 1 )
                else
                  Date.new( season.start_year, 7, 1 )
                end

     # if debug?
     #   puts "  (sec) lines:"
     #   pp lines
     # end

      ### note - skip section if no lines !!!!!
      next if lines.empty?     ## or use lines.size == 0


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

      ## note: pass along stage (if present): stage  - optional from heading!!!!
      if stage
        matches.each do |match|
          match = match.update( stage: stage )
        end
      end

      @data[ league ] ||= {}
      @data[ league ][ season.key ] ||= []

      @data[ league ][ season.key ] += matches
      ## note - skip teams, rounds, and groups for now
    end

## check - only one league and one season
##             allowed in quick style


    leagues = @data.keys
    if leagues.size != 1
        puts "!! (QUICK) PARSE ERROR - expected one league only; got #{leagues.size}:"
        pp leagues
        exit 1
    end

    seasons = @data[ leagues[0] ].keys
    if seasons.size != 1
        puts "!! (QUICK) PARSE ERROR - expected one #{leagues[0]} season only; got #{seasons.size}:"
        pp seasons
        exit 1
    end

    @data[ leagues[0] ][ seasons[0] ]
  end # method parse

end # class QuickMatchReader
end # module SportDb

