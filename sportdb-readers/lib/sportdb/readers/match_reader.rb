###
# todo/fix:
#    add optional stage to
#           group, round to make uniquie
#     same group or round name is different (record) if differant stage !!!!


module SportDb
class MatchReader    ## todo/check: rename to MatchReaderV2 (use plural?) why? why not?


  def self.read( path, season: nil )   ## use - rename to read_file or from_file etc. - why? why not?
    txt = File.open( path, 'r:utf-8' ) {|f| f.read }
    parse( txt, season: season )
  end

  def self.parse( txt, season: nil )
    new( txt ).parse( season: season )
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

      ## -- check & map; replace inline (string with data struct record)

      ####
      ## find leage_rec
  
      ## first try by period
      period = Import::LeaguePeriod.find_by( code:   sec.league,
                                             season: season  )
      league =  if period
         ## find league by qname (assumed to be unique!!)
         ##    todo/fix - use League.find_by!( name: ) !!!!
         ##      make more specifi
                   Import::League.find!( period.qname )
                else
                   Import::League.find!( sec.league )
                end
 ##
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
              
      ### check if event info available - use start_date;
      ##    otherwise we have to guess (use a "synthetic" start_date)
      ## event_info = Import::EventInfo.find_by( season: season,
      ##                                        league: league )
=begin      
      start = if event_info && event_info.start_date
                  puts "event info found:"
                  puts "  using start date from event: "
                  pp event_info
                  pp event_info.start_date
                  event_info.start_date
              else
                if season.year?
                  Date.new( season.start_year, 1, 1 )
                else
                  Date.new( season.start_year, 7, 1 )
                end
              end
=end

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
      pp league

    

      ##################################
      ## step 1: map/find teams

      ## note: loop over keys (holding the names); values hold the usage counter!! e.g. 'Arsenal' => 2, etc.
       # puts " [debug] auto_conf_teams:"
       # pp auto_conf_teams

       teams = Import::Team.find_by!( name:   auto_conf_teams,
                                      league: league )

       puts " [debug] teams:"
       pp teams


       ## build mapping - name => team struct record
       team_mapping =  auto_conf_teams.zip( teams ).to_h

       puts " [debug] team_mapping:"
       pp team_mapping


        ## quick (and dirty) hack
        ##   update all team strings with mapped records
        matches.each do |match|
            match.update( team1: team_mapping[ match.team1 ] )
            match.update( team2: team_mapping[ match.team2 ] )
        end

        ## quick hack cont.
        ##  rebuild groups with all team strings with mapped records
        groups = groups.map do |old_group|
                                group = Import::Group.new(
                                          name: old_group.name,
                                          teams: old_group.teams.map {|team| team_mapping[team] }
                                        )
                                group
                            end
        puts "groups:"
        pp groups

## fix
##  !! ERROR - no (cached) team rec found for team in group >Group A<
##   for >#<Sports::Club:0x000002c7e1686040><
###    update sync group to check for records (use .name) !!!


     ######################################################
     ## step 2: add to database

     event_rec = Sync::Event.find_or_create_by( league: league,
                                                season: season )

     stage_rec = if stage
                  Sync::Stage.find_or_create( stage, event: event_rec )
                 else
                   nil
                 end

     team_recs  =  stage_rec ? stage_rec.teams    : event_rec.teams
     team_ids   =  stage_rec ? stage_rec.team_ids : event_rec.team_ids

      ## todo/fix: check if all teams are unique
      ##   check if uniq works for club record (struct) - yes,no ??
      new_team_recs = Sync::Team.find_or_create( team_mapping.values.uniq )

     new_team_recs.each do |team_rec|
       ## add teams to event
       ##   for now check if team is alreay included
       ##   todo/fix: clear/destroy_all first - why? why not!!!
       team_recs << team_rec    unless team_ids.include?( team_rec.id )
     end


       ## build a lookup cache for team_recs  (used by group lookup)
       ##   lookup by "canonical" name
       cache_team_recs = new_team_recs.reduce({}) { |h,rec| h[rec.name] = rec; h }

      groups.each do |group|
        group_rec = Sync::Group.find_or_create( group, event: event_rec )   ## check: use/rename to EventGroup why? why not?

        ########
        ## add/update teams  - todo/fix/clean-up - find a better way or move to sync? - possible?
        ##   e.g. group.teams assumes an array of team names e.g.
        ##      ["Spain", "Czech Republic", "Turkey", "Croatia"]
        group_team_ids = []
        group.teams.each do |team|
          team_rec = cache_team_recs[ team.name ]
          if team_rec.nil? ## assume team MUST always be present/known in mapping (via autoconfig parser)
            puts "!! ERROR - no (cached) team rec found for team in group >#{group.name}< for >#{team}<"
            exit 1
          end
          group_team_ids << team_rec.id
        end
        group_rec.team_ids = group_team_ids   ## reset/update all teams at once (via ids)
      end


      rounds.each do |round|
        round_rec = Sync::Round.find_or_create( round, event: event_rec )  ## check: use/rename to EventRound why? why not?
      end


      matches.each do |match|
        ## note: pass along stage (if present): stage  - optional from heading!!!!
        match = match.update( stage: stage )    if stage
        match_rec = Sync::Match.create!( match, event: event_rec )
      end
    end

    true   ## success/ok
  end # method parse





#####
#  filter by season helpers
  def filter_secs( secs, season: )
    filtered_secs = []
    filter = norm_seasons( season )
    secs.each do |sec|
      if filter.include?( Season.parse( sec[:season] ).key )
        filtered_secs << sec
      else
        puts "  skipping season >#{sec[:season]}< NOT matched by filter"
      end
    end
    filtered_secs
  end

  def norm_seasons( season_or_seasons )     ## todo/check: add alias norm_seasons - why? why not?
      seasons = if season_or_seasons.is_a?( Array )  # is it an array already
                  season_or_seasons
                elsif season_or_seasons.is_a?( Range )  # e.g. Season(1999)..Season(2001) or such
                  season_or_seasons.to_a
                else  ## assume - single entry - wrap in array
                  [season_or_seasons]
                end

      seasons.map { |season| Season( season ).key }
  end
end # class MatchReader
end # module SportDb
