# encoding: UTF-8


require 'sportdb/config'


## use (switch to) "external" datasets
SportDb::Import.config.clubs_dir   = "../../../openfootball/clubs"
SportDb::Import.config.leagues_dir = "../../../openfootball/leagues"



LEAGUES   = SportDb::Import.config.leagues
CLUBS     = SportDb::Import.config.clubs
COUNTRIES = SportDb::Import.config.countries


require 'sportdb/models'   ## add sql database support

SportDb.connect( adapter: 'sqlite3', database: ':memory:' )
SportDb.create_all   ## build schema

## turn on logging to console
ActiveRecord::Base.logger = Logger.new(STDOUT)



module SportDb

module Sync
  class Country
    def self.find_or_create( country )
       rec = WorldDb::Model::Country.find_by( key: country.key )
       if rec.nil?
         attribs = {
           key:  country.key,
           name: country.name,
           code: country.fifa,  ## fix:  uses fifa code now (should be iso-alpha3 if available)
           fifa: country.fifa,
           area: 1,
           pop:  1
         }
         rec = WorldDb::Model::Country.create!( attribs )
       end
       rec
    end
  end # class Country

  class League
    def self.find_or_create( league )
       rec = SportDb::Model::League.find_by( key: league.key )
       if rec.nil?
         ## use title and not name - why? why not?
         ##  quick fix:  change name to title
         attribs = { key:   league.key,
                     title: league.name }
         if league.country
           attribs[ :country_id ] = Country.find_or_create( league.country ).id
         end

         rec = SportDb::Model::League.create!( attribs )
       end
       rec
    end
  end # class League

  class Season
    def self.find_or_create( key )  ## e.g. key = '2017-18'

      ## note:  "normalize" season key
      ##   always use 2017/18  (and not 2017-18 or 2017-2018 or 2017/2018)
      ## 1) change 2017-18 to 2017/18
      key = key.tr( '-', '/' )
      ## 2) check for 2017/2018 - change to 2017/18
      if key.length == 9
        key = "#{key[0..3]}/#{key[7..8]}"
      end

      rec = SportDb::Model::Season.find_by( key: key )
      if rec.nil?
         attribs = { key:   key,
                     title: key  }
         rec = SportDb::Model::Season.create!( attribs )
      end
      rec
    end
  end # class Season

  class Club
    def self.find_or_create( club )
      rec = SportDb::Model::Team.find_by( title: club.name )
      if rec.nil?
        ## remove all non-ascii a-z chars
        key  = club.name.downcase.gsub( /[^a-z]/, '' )
        puts "add club: #{key}, #{club.name}, #{club.country.name} (#{club.country.key})"

        attribs = {
          key:       key,
          title:     club.name,
          country_id: Country.find_or_create( club.country ).id,
          club:       true,
          national:   false  ## check -is default anyway - use - why? why not?
          ## todo/fix: add city if present - why? why not?
        }
        if club.alt_names.empty? == false
          attribs[:synonyms] = club.alt_names.join(',')
        end

        rec = SportDb::Model::Team.create!( attribs )
      end
      rec
    end
  end # class Club

  class Event
    def self.find_or_create( league:, season: )
      rec = SportDb::Model::Event.find_by( league_id: league.id, season_id: season.id  )
      if rec.nil?
        ## quick hack/change later !!
        ##  todo/fix: check season  - if is length 4 (single year) use 2017, 1, 1
        ##                               otherwise use 2017, 7, 1
        ##  start_at use year and 7,1 e.g. Date.new( 2017, 7, 1 )
        ## hack:  fix/todo1!!
        ##   add "fake" start_at date for now
        if season.key.size == '4'   ## e.g. assume 2018 etc.
          year = season.key.to_i
          start_at = Date.new( year, 1, 1 )
        else  ## assume 2014/15 etc.
          year = season.key[0..3].to_i
          start_at = Date.new( year, 7, 1 )
        end

        attribs = {
          league_id: league.id,
          season_id: season.id,
          start_at:  start_at  }

        rec = SportDb::Model::Event.create!( attribs )
      end
      rec
    end
  end  # class Event
end # module Sync




class EventReaderV2    ## todo/check: rename to EventsReaderV2 (use plural?) why? why not?

  def self.read( path )   ## use - rename to read_file or from_file etc. - why? why not?
    txt = File.open( path, 'r:utf-8' ).read
    parse( txt )
  end


  ## split into league + season
  ##  e.g. Österr. Bundesliga 2015/16   ## or 2015-16
  ##       World Cup 2018
  LEAGUE_SEASON_HEADING_REGEX =  /^
         (?<league>.+?)     ## non-greedy
            \s+
         (?<season>\d{4}
            (?:[\/-]\d{2})?     ## optional 2nd year in season
         )
            $/x


  def self.parse( txt )

    recs=[]

    txt.each_line do |line|
        line = line.strip

        next if line.empty?
        break if line == '__END__'

        next if line.start_with?( '#' )   ## skip comments too
        ## strip inline (until end-of-line) comments too
        ##  e.g Eupen        => KAS Eupen,    ## [de]
        ##   => Eupen        => KAS Eupen,
        line = line.sub( /#.*/, '' ).strip
        pp line

        next if line =~ /^={1,}$/          ## skip "decorative" only heading e.g. ========

         ## note: like in wikimedia markup (and markdown) all optional trailing ==== too
         ##  todo/check:  allow ===  Text  =-=-=-=-=-=   too - why? why not?
        if line =~ /^(={1,})       ## leading ======
                     ([^=]+?)      ##  text   (note: for now no "inline" = allowed)
                     =*            ## (optional) trailing ====
                     $/x
           heading_marker = $1
           heading_level  = $1.length   ## count number of = for heading level
           heading        = $2.strip

           puts "heading #{heading_level} >#{heading}<"


             if heading_level == 1
               ## check for league and season
               if m=heading.match( LEAGUE_SEASON_HEADING_REGEX )
                 puts "league >#{m[:league]}<, season >#{m[:season]}<"

                  recs << { league: m[:league],
                            season: m[:season],
                            clubs:  []
                          }
               else
                 puts "** !! ERROR !! - CANNOT match league and season in heading; season missing?"
                 pp line
                 exit 1
               end
             else
               puts "** !! ERROR !! - unsupported heading level #{heading_level}; for now only heading 1 for leagues supported; sorry"
               pp line
               exit 1
             end
        else
           ## assume it's a club / team
           recs[-1][:clubs] << line
        end
      end
    pp recs



    ## pass 2 - check & map; replace inline (string with record)
    recs.each do |rec|
      league = find_league( rec[:league] )
      rec[:league] = league

      club_recs = []
      rec[:clubs].each do |name|
        club_recs << find_club( name, league.country )
      end
      rec[:clubs] = club_recs
    end

    ## pass 3 - import (insert/update) into db
    recs.each do |rec|
       league = Sync::League.find_or_create( rec[:league] )
       season = Sync::Season.find_or_create( rec[:season] )

       event  = Sync::Event.find_or_create( league: league, season: season )

       rec[:clubs].each do |club_rec|
         club = Sync::Club.find_or_create( club_rec )
         ## add teams to event
         ##   todo/fix: check if team is alreay included?
         ##    or clear/destroy_all first!!!
         event.teams << club
       end
    end

    recs
  end # method read


  def self.find_league( name )
    league = nil
    m = LEAGUES.match( name )
    # pp m

    if m.nil?
      puts "** !!! ERROR !!! no league match found for >#{name}<, add to leagues table; sorry"
      exit 1
    elsif m.size > 1
      puts "** !!! ERROR !!! ambigious league name; too many leagues (#{m.size}) found:"
      pp m
      exit 1
    else
      league = m[0]
    end

    league
  end

  def self.find_club( name, country )   ## todo/fix: add international or league flag?
    club = nil
    m = CLUBS.match_by( name: name, country: country )

    if m.nil?
      ## (re)try with second country - quick hacks for known leagues
      ##  todo/fix: add league flag to activate!!!
      m = CLUBS.match_by( name: name, country: COUNTRIES['wal'])  if country.key == 'eng'
      m = CLUBS.match_by( name: name, country: COUNTRIES['nir'])  if country.key == 'ie'
      m = CLUBS.match_by( name: name, country: COUNTRIES['mc'])   if country.key == 'fr'
      m = CLUBS.match_by( name: name, country: COUNTRIES['li'])   if country.key == 'ch'
      m = CLUBS.match_by( name: name, country: COUNTRIES['ca'])   if country.key == 'us'
    end

    if m.nil?
      puts "** !!! ERROR !!! no match for club >#{name}<"
      exit 1
    elsif m.size > 1
      puts "** !!! ERROR !!! too many matches (#{m.size}) for club >#{name}<:"
      pp m
      exit 1
    else   # bingo; match - assume size == 1
      club = m[0]
    end

    club
  end

end # class EventReaderV2
end # module SportDb



path = "../../../openfootball/eng-england/2017-18/1-premierleague.conf.txt"
recs = SportDb::EventReaderV2.read( path )
## pp recs
