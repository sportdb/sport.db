

module SportDb
class CsvEventImporter

  def self.read( path, league:, season:,
                       headers: nil )
    txt = File.open( path, 'r:utf-8' ) {|f| f.read }
    parse( txt, league:  league,
                season:  season,
                headers: headers )
  end

  def self.parse( txt, league:, season:,
                       headers: nil  )
    new( txt, league:  league,
              season:  season,
              headers: headers ).parse
  end


  def initialize( txt, league:, season:, headers: nil )
    @txt     = txt
    @headers = headers

    raise ArgumentError("string expected for league; got #{league.class.name}")  unless league.is_a? String
    raise ArgumentError("string expected for season; got #{season.class.name}")  unless season.is_a? String

    ## try mapping of league here - why? why not?
    @league  = Import.catalog.leagues.find!( league )
    @season  = Season.parse( season )
  end


  def parse
    ## todo/fix: add headers options (pass throughto CsvMatchReader)
    ##    add filters too why? why not?

    ##  todo/fix:
    ##     add normalize: false/mapping: false  flag for NOT mapping club/team names
    ##       make normalize: false the default, anyways - why? why not?
    opts = {}
    opts[:headers] = @headers  if @headers

    matches = CsvMatchParser.parse( @txt, **opts )

    matchlist = Import::Matchlist.new( matches )

    team_names = matchlist.teams           ## was: find_teams_in_matches_txt( matches_txt )
    puts "#{team_names.size} teams:"
    pp team_names

    ## note: allows duplicates - will return uniq struct recs in teams
    teams = Import.catalog.teams.find_by!( name: team_names,
                                           league: @league )
    ## build mapping - name => team struct record
    team_mappings =  team_names.zip( teams ).to_h

    pp team_mappings


    #######
    # start with database updates / sync here

    event_rec = Sync::Event.find_or_create_by( league: @league,
                                               season: @season )

    ## todo/fix:
    ##   add check if event has teams
    ##   if yes - only double check and do NOT create / add teams
    ##    number of teams must match (use teams only for lookup/alt name matches)

    ## note: allows duplicates - will return uniq db recs in teams
    ##                            and mappings from names to uniq db recs

    ## todo/fix: rename to team_recs_cache or team_cache - why? why not?

    # maps struct record "canonical" team name to active record db record!!
    ## note: use "canonical" team name as hash key for now (and NOT the object itself) - why? why not?
    team_recs = Sync::Team.find_or_create( team_mappings.values.uniq )

    ## todo/fix/check:
    ##   add check if event has teams
    ##   if yes - only double check and do NOT create / add teams
    ##    number of teams must match (use teams only for lookup/alt name matches)

    ## add teams to event
    ##   todo/fix: check if team is alreay included?
    ##    or clear/destroy_all first!!!
    event_rec.teams = team_recs   ## todo/check/fix: use team_ids instead - why? why not?



    ## add catch-all/unclassified "dummy" round
    # round_rec = Model::Round.create!(
    #  event_id: event_rec.id,
    #  title:    'Matchday ??? / Missing / Catch-All',   ## find a better name?
    #  pos:      999,
    #  start_at: event_rec.start_at.to_date
    # )

    ## add matches
    matches.each do |match|
      team1_rec = Sync::Team.cache[ team_mappings[match.team1].name ]
      team2_rec = Sync::Team.cache[ team_mappings[match.team2].name ]

      if match.date.nil?
        puts "!!! WARN: skipping match - play date missing!!!!!"
        pp match
      else
        ## find last pos - check if it can be nil?  yes, is nil if no records found
        max_pos = Model::Match.where( event_id: event_rec.id ).maximum( 'pos' )
        max_pos = max_pos ? max_pos+1 : 1

        rec = Model::Match.create!(
                event_id: event_rec.id,
                team1_id: team1_rec.id,
                team2_id: team2_rec.id,
                ## round_id: round_rec.id,  -- note: now optional
                pos:      max_pos,
                date:     Date.strptime( match.date, '%Y-%m-%d' ),
                score1:   match.score1,
                score2:   match.score2,
                score1i:  match.score1i,
                score2i:  match.score2i,
              )
      end
    end # each match

    event_rec  # note: return event database record
  end # method parse

end # class CsvEventImporter
end # module SportDb
