
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