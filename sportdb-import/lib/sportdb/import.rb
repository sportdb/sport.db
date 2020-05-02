# encoding: utf-8


## 3rd party gemss
require 'sportdb/text'

require 'sportdb/models'    ## add sql database support
require 'sportdb/config'
# require 'sportdb/sync'


###
# our own code
require 'sportdb/import/version' # let version always go first




def import_matches_txt( path, league:, season: )   ## todo/check: rename to import_matches - why? why not?
  ## todo/fix: add headers options (pass throughto CsvMatchReader)
  ##    add filters too why? why not?

  ## note: allow keys (as string) or records
  league  = SportDb::Importer::League.find_or_create_builtin!( league )    if league.is_a? String
  season  = SportDb::Importer::Season.find_or_create_builtin( season )     if season.is_a? String

  ##  todo/fix:
  ##     add normalize: false/mapping: false  flag for NOT mapping club/team names
  ##       make normalize: false the default, anyways - why? why not?
  matches_txt = CsvMatchReader.read( path )

  update_matches_txt( matches_txt,
                        league:  league,
                        season:  season )
end


def update_matches_txt( matches_txt, league:, season: )   ## todo/check: rename to update_matches/insert_matches - why? why not?

  event   = find_or_create_event( league: league, season: season )

  matchlist = SportDb::Struct::Matchlist.new( matches_txt )
  teams_txt = matchlist.teams           ## was: find_teams_in_matches_txt( matches_txt )
  puts "#{teams_txt.size} teams:"
  pp teams_txt

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




class CsvMatchImporter

def initialize( path )
  @pack = CsvPackage.new( path )
end


def import_leagues( start: nil )
  ## start - season e.g. 1993/94 to start (skip older seasons)
  ## note: assume package holds country/national (club) league
  #  use for importing german bundesliga, english premier league, etc.

  entries = @pack.find_entries_by_code_n_season_n_division
  pp entries

  entries.each_with_index do |(code_key, seasons),i|

    if code_key == '?'
      puts "!! error - country key expected in datafile base e.g. eng.1, de.1, etc. - sorry"
      exit 1
    end
    ## note: for now assume code_key is (always) a country code (key)
    ##    todo: make more flexible later
    country_key = code_key
    country = SportDb::Importer::Country.find_or_create_builtin!( country_key )

    seasons.each_with_index do |(season_key, divisions),j|
    puts "season [#{j+1}/#{seasons.size}] >#{season_key}<:"

    if start && SeasonUtils.start_year( season_key ) < SeasonUtils.start_year( start )
      puts "skip #{season_key} before #{start}"
      next
    end

    season = SportDb::Importer::Season.find_or_create_builtin( season_key )

    divisions.each_with_index do |(division_key, datafiles),k|
      puts "league [#{k+1}/#{divisions.size}] (#{datafiles.size}) #{datafiles.join(', ')}:"

      ## todo/fix: check for divsion_key is unknown e.g. ? and report error and exit!!
      ## todo/fix: check for eng special case (and convert to en for league key) why? why not?
      level = division_key.to_i
      league_key =  if level == 1
                      country_key
                    else
                      "#{country_key}.#{division_key}"
                    end

      datafiles.each do |datafile|
        path = @pack.expand_path( datafile )
        pp [path, season_key, league_key, country_key]

        league_auto_name = "#{country.name} League #{division_key}"   ## "fallback" auto-generated league name
        pp league_auto_name
        league = SportDb::Importer::League.find_or_create( league_key,
                                                             name:       league_auto_name,
                                                             country_id: country.id )

        import_matches_txt( path,
              league:  league,
              season:  season )
      end  # each datafiles
      end
    end
  end
end # method import_leagues

end  # class CsvMatchImporter



puts SportDb::Import.banner   # say hello
