

class CsvMatchImporter    ## todo/fix/check: rename to CsvMatchReader and CsvMatchReader to CsvMatchParser - why? why not?

  def self.read( path, league:, season: )
    txt = File.open( path, 'r:utf-8' ).read
    parse( txt, league: league, season: season )
  end

  def self.parse( txt, league:, season: )
    new( txt, league: league, season: season).parse
  end


  def initialize( txt, league:, season: )
    @txt = txt
    ## try mapping of league here - why? why not?

    raise ArgumentError("string expected for league; got #{league.class.name}")  unless league.is_a? String
    raise ArgumentError("string expected for season; got #{season.class.name}")  unless season.is_a? String

    @league  = search_league!( league )
    @season  = SportDb::Import::Season.new( season )
  end


  def parse
    ## todo/fix: add headers options (pass throughto CsvMatchReader)
    ##    add filters too why? why not?

    ##  todo/fix:
    ##     add normalize: false/mapping: false  flag for NOT mapping club/team names
    ##       make normalize: false the default, anyways - why? why not?
    matches = CsvMatchReader.parse( @txt )

    matchlist = SportDb::Import::Matchlist.new( matches )

    team_names = matchlist.teams           ## was: find_teams_in_matches_txt( matches_txt )
    puts "#{team_names.size} teams:"
    pp team_names

    ## note: allows duplicates - will return uniq db recs in teams
    ##                            and mappings from names to uniq db recs
    team_mappings = map_teams!( team_names, league: @league,
                                            season: @season )
    pp team_mappings
  end # method parse


  #####
  # helpers - make private - why? why not?

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
end # class CsvMatchImporter




  def update_matches_txt( matches_txt, league:, season: )   ## todo/check: rename to update_matches/insert_matches - why? why not?

    event   = find_or_create_event( league: league, season: season )


    ## todo/fix:
    ##   add check if event has teams
    ##   if yes - only double check and do NOT create / add teams
    ##    number of teams must match (use teams only for lookup/alt name matches)

    ## note: allows duplicates - will return uniq db recs in teams
    ##                            and mappings from names to uniq db recs
    teams, team_mappings = find_or_create_clubs!( teams_txt, league: league, season: season )

    ## add teams to event
    ##   todo/fix: check if team is alreay included?
    ##    or clear/destroy_all first!!!
    teams.each do |team|
      event.teams << team
    end

    ## add catch-all/unclassified "dummy" round
    round = SportDb::Model::Round.create!(
      event_id: event.id,
      title:    'Matchday ??? / Missing / Catch-All',   ## find a better name?
      pos:      999,
      start_at: event.start_at.to_date
    )

    ## add matches
    matches_txt.each do |match_txt|
      team1 = team_mappings[match_txt.team1]
      team2 = team_mappings[match_txt.team2]

      if match_txt.date.nil?
        puts "!!! skipping match - play date missing!!!!!"
        pp match_txt
      else
        match = SportDb::Model::Game.create!(
          team1_id: team1.id,
          team2_id: team2.id,
          round_id: round.id,
          pos:      999,    ## make optional why? why not? - change to num?
          play_at:  Date.strptime( match_txt.date, '%Y-%m-%d' ),
          score1:   match_txt.score1,
          score2:   match_txt.score2,
          score1i:  match_txt.score1i,
          score2i:  match_txt.score2i,
        )
      end
    end
  end
