
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
    @txt = txt
  end

  def parse( season: nil )
    secs = LeagueOutlineReader.parse( @txt, season: season )
    pp secs

    secs.each do |sec|   ## sec(tion)s
      season = sec[:season]
      league = sec[:league]
      stage  = sec[:stage]
      lines  = sec[:lines]

      ### check if event info availabe - use start_date;
      ##    otherwise we have to guess (use a "synthetic" start_date)
      event_info = catalog.events.find_by( season: season,
                                           league: league )

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


      parser = MatchParser.new( lines,
                                start )   ## note: keep season start_at date for now (no need for more specific stage date need for now)

      auto_conf_teams,  matches, rounds, groups = parser.parse

      puts ">>> #{auto_conf_teams.size} teams:"
      pp auto_conf_teams
      puts ">>> #{matches.size} matches:"
      ## pp matches
      puts ">>> #{rounds.size} rounds:"
      pp rounds
      puts ">>> #{groups.size} groups:"
      pp groups



      ## step 1: map/find teams

      ## note: loop over keys (holding the names); values hold the usage counter!! e.g. 'Arsenal' => 2, etc.
      mods = nil
      if league.clubs? && league.intl?    ## todo/fix: add intl? to ActiveRecord league!!!

        ## quick hack - use "dynamic" keys for keys
          uefa_el_q = catalog.leagues.match_by( code: 'uefa.el.quali' )[0]
          uefa_cl_q = catalog.leagues.match_by( code: 'uefa.cl.quali' )[0]
          uefa_cl   = catalog.leagues.match_by( code: 'uefa.cl' )[0]
          uefa_el   = catalog.leagues.match_by( code: 'uefa.el' )[0]

          pp [uefa_el_q, uefa_cl_q, uefa_cl, uefa_el]

                ### quick hack mods for popular/known ambigious club names
                ##    todo/fix: make more generic / reuseable!!!!
                mods = {}
                ## europa league uses same mods as champions league
                mods[ uefa_el_q.key ] =
                mods[ uefa_cl_q.key ] =
                mods[ uefa_el.key ] =
                mods[ uefa_cl.key ] = catalog.clubs.build_mods(
                  { 'Liverpool | Liverpool FC' => 'Liverpool FC, ENG',
                    'Arsenal  | Arsenal FC'    => 'Arsenal FC, ENG',
                    'Barcelona'                => 'FC Barcelona, ESP',
                    'Valencia'                 => 'Valencia CF, ESP',
                    'Rangers FC'               => 'Rangers FC, SCO',
                  })
       end

       # puts " [debug] auto_conf_teams:"
       # pp auto_conf_teams


 ## todo/fix
 ##  ** !!! ERROR - too many matches (2) for club >Barcelona<:
 ## [<Club: FC Barcelona (ESP)>, <Club: Barcelona Guayaquil (ECU)>]

       puts "league:"
       pp league

       teams = catalog.teams.find_by!( name:   auto_conf_teams,
                                       league: league,
                                       mods:   mods )

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
        match = match.update( stage: stage )   if stage
        match_rec = Sync::Match.create_or_update( match, event: event_rec )
      end
    end

    true   ## success/ok
  end # method parse


  ######################
  # (convenience) helpers

  def catalog() Import.catalog; end

end # class MatchReader
end # module SportDb
