# encoding: utf-8


## 3rd party gemss
require 'sportdb/text'
require 'sportdb/models'   ## add sql database support


###
# our own code
require 'sportdb/import/version' # let version always go first

require 'sportdb/import/finder_db_i'
require 'sportdb/import/finder_db_ii'



def import_matches_txt( path, season:, league:, country: )

  matches_txt = CsvMatchReader.read( path )

  ## note: allow keys (as string) or records
  season  = SportDb::Importer::Season.find( season )     if season.is_a? String
  league  = SportDb::Importer::League.find!( league )    if league.is_a? String
  country = SportDb::Importer::Country.find!( country )  if country.is_a? String

  update_matches_txt( matches_txt,
                        season:  season,
                        league:  league,
                        country: country )
end


def update_matches_txt( matches_txt, season:, league:, country: )

  matchlist = SportDb::Struct::Matchlist.new( matches_txt )
  teams_txt = matchlist.teams           ## was: find_teams_in_matches_txt( matches_txt )
  puts "#{teams_txt.size} teams:"
  pp teams_txt


  ## note: assume for now team all from same country
  ##   fix!!! - english premier league has teams from wales
  ##            french ligue 1 from monaco
  teams = find_teams( teams_txt, country: country )

  ## build hash lookup table e.g.
  #  { 'Liverpool' => obj, ... }
  teams_mapping = Hash[ teams_txt.zip( teams ) ]



  event   = find_event( season: season, league: league )

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
    team1 = teams_mapping[match_txt.team1]
    team2 = teams_mapping[match_txt.team2]

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

  entries = @pack.find_entries_by_season_n_division
  pp entries

  entries.each_with_index do |(season_key, divisions),i|
    puts "season [#{i+1}/#{entries.size}] >#{season_key}<:"

    if start && SeasonUtils.start_year( season_key ) < SeasonUtils.start_year( start )
      puts "skip #{season_key} before #{start}"
      next
    end

    season  = SportDb::Importer::Season.find( season_key )

    divisions.each_with_index do |(division_key, datafile),j|
      puts "league [#{j+1}/#{divisions.size}] >#{datafile}<:"

      basename = File.basename( datafile, '.csv' )
      ## get country code
      m = /^([a-z]{2,3})\./.match( basename )   ## e.g. eng.1, de.1, etc.
      if m
        country_key = m[1]
      else
        puts "!! country key expected in datafile base e.g. eng.1, de.1, etc."
        exit 1
      end
      country = SportDb::Importer::Country.find!( country_key )

      ## todo/fix: check for divsion_key is unknown e.g. ? and report error and exit!!
      ## todo/fix: check for eng special case (and convert to en for league key) why? why not?
      level = division_key.to_i
      league_key =  if level == 1
                       country_key
                    else
                       "#{country_key}.#{division_key}"
                    end


      path = @pack.expand_path( datafile )
      pp [path, season_key, league_key, country_key]

      league_auto_name = "#{country.name} League #{division_key}"   ## "fallback" auto-generated league name
      pp league_auto_name
      league = SportDb::Importer::League.find_or_create( league_key, name: league_auto_name )

      import_matches_txt( path,
              season:  season,
              league:  league,
              country: country )
    end
  end
end
end  # class CsvMatchImporter



puts SportDb::Import.banner   # say hello
