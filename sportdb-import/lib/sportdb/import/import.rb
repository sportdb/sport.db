
## todo/fix: rename to CsvEventImporter or EventImporter  !!! returns Event!!
class CsvEventImporter    ## todo/fix/check: rename to CsvMatchReader and CsvMatchReader to CsvMatchParser - why? why not?

  def self.read( path, league:, season:,
                       headers: nil )
    txt = File.open( path, 'r:utf-8' ).read
    parse( txt, league: league, season: season,
                headers: headers )
  end

  def self.parse( txt, league:, season:,
                       headers: nil  )
    new( txt, league: league, season: season,
              headers: headers ).parse
  end


  def initialize( txt, league:, season:, headers: nil )
    @txt     = txt
    @headers = headers

    raise ArgumentError("string expected for league; got #{league.class.name}")  unless league.is_a? String
    raise ArgumentError("string expected for season; got #{season.class.name}")  unless season.is_a? String

    ## try mapping of league here - why? why not?
    @league  = search_league!( league )
    @season  = SportDb::Import::Season.new( season )
  end


  def parse
    ## todo/fix: add headers options (pass throughto CsvMatchReader)
    ##    add filters too why? why not?

    ##  todo/fix:
    ##     add normalize: false/mapping: false  flag for NOT mapping club/team names
    ##       make normalize: false the default, anyways - why? why not?
    opts = {}
    opts[:headers] = @headers  if @headers

    matches = CsvMatchReader.parse( @txt, **opts )

    matchlist = SportDb::Import::Matchlist.new( matches )

    team_names = matchlist.teams           ## was: find_teams_in_matches_txt( matches_txt )
    puts "#{team_names.size} teams:"
    pp team_names

    ## note: allows duplicates - will return uniq struct recs in teams
    team_mappings = map_teams!( team_names, league: @league,
                                            season: @season )
    pp team_mappings


    #######
    # start with database updates / sync here

    event_rec = SportDb::Sync::Event.find_or_create_by( league: @league,
                                                        season: @season )

    ## todo/fix:
    ##   add check if event has teams
    ##   if yes - only double check and do NOT create / add teams
    ##    number of teams must match (use teams only for lookup/alt name matches)

    ## note: allows duplicates - will return uniq db recs in teams
    ##                            and mappings from names to uniq db recs

    ## todo/fix: rename to team_recs_cache or team_cache - why? why not?
    team_recs = {}    # maps struct record "canonical" team name to active record db record!!

    teams = team_mappings.values.uniq
    teams.each do |team|
      ## note: use "canonical" team name as hash key for now (and NOT the object itself) - why? why not?
      team_recs[ team.name ] = SportDb::Sync::Team.find_or_create( team )
    end

    ## todo/fix/check:
    ##   add check if event has teams
    ##   if yes - only double check and do NOT create / add teams
    ##    number of teams must match (use teams only for lookup/alt name matches)

    ## add teams to event
    ##   todo/fix: check if team is alreay included?
    ##    or clear/destroy_all first!!!
    team_recs.values.each do |team_rec|
      event_rec.teams << team_rec
    end

    ## add catch-all/unclassified "dummy" round
    round_rec = SportDb::Model::Round.create!(
      event_id: event_rec.id,
      title:    'Matchday ??? / Missing / Catch-All',   ## find a better name?
      pos:      999,
      start_at: event_rec.start_at.to_date
    )

    ## add matches
    matches.each do |match|
      team1_rec = team_recs[ team_mappings[match.team1].name ]
      team2_rec = team_recs[ team_mappings[match.team2].name ]

      if match.date.nil?
        puts "!!! WARN: skipping match - play date missing!!!!!"
        pp match
      else
        rec = SportDb::Model::Game.create!(
                team1_id: team1_rec.id,
                team2_id: team2_rec.id,
                round_id: round_rec.id,
                pos:      999,    ## make optional why? why not? - change to num?
                play_at:  Date.strptime( match.date, '%Y-%m-%d' ),
                score1:   match.score1,
                score2:   match.score2,
                score1i:  match.score1i,
                score2i:  match.score2i,
              )
      end
    end # each match

    event_rec  # note: return event database record
  end # method parse


  #############################
  # helpers - make private (or better make shared and move for (re)use!!!!) - why? why not?

  def search_league!( q )
    leagues = SportDb::Import.catalog.leagues.match( q )
    if leagues.nil? || leagues.empty?
      puts "!! ERROR: no league match found for >#{q}<; sorry - add to leagues"
      exit 1
    elsif leagues.size > 1
      puts "!! ERROR: too many league (#{leagues.size}) matches found for >#{q}<; sorry - use a unique key"
      exit 1
    else
      ## bingo! match - fall/pass through
    end
    leagues[0]
  end

  def map_teams!( team_names, league:, season: )
    mapping = {}
    if league.clubs?
      team_names.each do |name|
         club = SportDb::Import.catalog.clubs.find_by!( name: name, country: league.country )
         mapping[ name ] = club
      end
    else
      team_names.each do |name|
        ## todo/fix: search national teams !!!
      end
    end
    mapping
  end  # method map_teams!
end # class CsvEventImporter

