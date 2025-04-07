
module SportDbV2
class MatchReader   
  

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


  def parse( season: nil )
    ## note: every (new) read call - resets errors list to empty
    @errors = []

    ### todo/fix - add back season filter - maybe upstream to outline - why? why not?
    ########
    #  step 1 - prepare secs
    # -- filter seasons if filter present
    #
    # secs = filter_secs( sec, season: season )   if season


    @outline.each_sec do |sec|   ## sec(tion)s
      ### move season parse into outline upstream - why? why not?
      season = Season.parse( sec.season )   ## convert (str) to season obj!!!
      lines  = sec.lines

 ## quick hack - assume "Regular" or "Regular Season"
 ##    as default stage (thus, no stage)
      stage = sec.stage   ## check if returns nil or empty string?
  
       stage = nil   if stage && ['regular',
                                  'regular season',
                                  'regular stage',
                                 ].include?( stage.downcase )

     
      ### todo/fix - remove "legacy/old" requirement for start date!!!!
        start = if season.year?
                  Date.new( season.start_year, 1, 1 )
                else
                  Date.new( season.start_year, 7, 1 )
                end
              

      parser = MatchParser.new( lines,
                                start )   ## note: keep season start_at date for now (no need for more specific stage date need for now)

      auto_conf_teams,  matches, rounds, groups = parser.parse

      ## auto-add "upstream" errors from parser
      @errors += parser.errors  if parser.errors?

      puts ">>> #{auto_conf_teams.size} teams:"
      pp auto_conf_teams
      puts ">>> #{matches.size} matches:"
      ## pp matches
      puts ">>> #{rounds.size} rounds:"
      pp rounds
      puts ">>> #{groups.size} groups:"
      pp groups


      puts "league:"
      league_rec = Sync::League.find_or_create( name: sec.league )
      pp league_rec

      event_rec = Sync::Event.find_or_create( league_rec: league_rec,
                                                  season: season )
      pp event_rec                                               

  
  
      matches.each do |match|
        ## note: pass along stage (if present): stage  - optional from heading!!!!
           ### use | instead of comma (,) for stage separator in (full) round - why? why not?
          match = match.update( stage: stage )    if stage
 
        match_rec = Sync::Match.create!( match, event_rec: event_rec )
        pp match
        pp match_rec       
      end
    end

    true   ## success/ok
  end # method parse


end # class MatchReader
end # module SportDbV2
