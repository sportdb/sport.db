# encoding: UTF-8


require 'sportdb/config'


## use (switch to) "external" datasets
# SportDb::Import.config.clubs_dir   = "../../../openfootball/clubs"
# SportDb::Import.config.leagues_dir = "../../../openfootball/leagues"



LEAGUES   = SportDb::Import.config.leagues
CLUBS     = SportDb::Import.config.clubs
COUNTRIES = SportDb::Import.config.countries


module SportDb


class EventReaderV2    ## todo/check: rename to EventsReaderV2 (use plural?) why? why not?

  def self.read( path )   ## use - rename to read_file or from_file etc. - why? why not?
    txt = File.open( path, 'r:utf-8' ).read
    parse( txt )
  end


  ## split into league + season
  ##  e.g. Österr. Bundesliga 2015/16
  ##       World Cup 2018
  LEAGUE_SEASON_HEADING_REGEX =  /^
         (?<league>.+?)     ## non-greedy
            \s+
         (?<season>\d{4}
            (?:\/\d{2})?     ## optional 2nd year in season
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


    ## pass 2 - check & map
    recs.each do |rec|
      ## leagues = LEAGUES.match( rec[:league] )
      ## pp leagues

      rec[:clubs].each do |name|
        clubs = CLUBS.match( name )
        pp clubs
      end
    end

    ## pass 3 - import (insert/update) into db


    recs
  end # method read

end # class EventReaderV2
end # module SportDb


recs = SportDb::EventReaderV2.read( 'eng.txt' )
pp recs


__END__


  def read
    @event    = nil   # reset cached event rec
    event_attribs={}

    reader = LineReader.from_string( @text )

    header = false
    season = nil
    league = nil

    reader.each_line do |line|
      puts "  line: >#{line}<"

      ## assume first line is event header (league+season)
      ##  e.g. Österr. Bundesliga 2015/16
      ##       World Cup 2018
      if header == false
         line = line.strip
         m = EVENT_HEADER_REGEX.match( line )
         if m
           league_title = m[:league]
           season_key   = m[:season]
           puts "  trying event lookup - league: >#{league_title}<, season: >#{season_key}<"

           season = Season.find_by( key: season_key )

           ## check if it exists
           if season.present?
             event_attribs['season_id'] = season.id
           else
             logger.error "season with key >>#{season_key}<< missing"
             exit 1
           end

           league = League.find_by( title: league_title )

           ## check if it exists
           if league.present?    ## todo: just use if league  (no present?) ???
             event_attribs['league_id'] = league.id
           else
             logger.error "league with title >>#{league_title}<< missing"
             exit 1
           end
         else
           fail "[EventTableReader] event header must match league+season pattern: >#{line}<"
         end
         header = true
      else
        ### process regular team lines

        line = line.strip
        scan = StringScanner.new( line )

        if scan.check( /-/ )               # option 1) list entry  e.g.  - Rapid Wien
          puts "  list entry >#{line}<"
          scan.skip( /-\s+/)
          team_title = scan.rest.strip      ## assume the rest is the team name
        elsif scan.check( /\d{1,2}\./ )    ## option 2) table entry  e.g.   1. Rapid Wien
          puts "  table entry >#{line}<"
          rank = scan.scan( /\d{1,2}/ )
          scan.skip( /\.\s+/)

          ## note: uses look ahead scan until we hit at least two spaces
          ##  or the end of string  (standing records for now optional)
          team_title = scan.scan_until( /(?=\s{2})|$/ )
          if scan.eos?
            standing = nil
          else
            scan.skip( /\s+/ )
            standing = scan.rest
          end
          puts "   rank: >#{rank}<, standing: >#{standing}<"
        else
           fail "[EventTableReader] event line must match team pattern: >#{line}<"
        end

        puts "  team: >#{team_title}<"

        team = Team.find_by( title: team_title )
        ## next try synonyms (if not found/no match)
        team = Team.where( "synonyms LIKE ?", "%#{team_title}%" ).first    if team.nil?


        if team.nil?
          ### print better error message than just
          ##  *** error: Couldn't find SportDb::Model::Team
          puts "[fatal] event reader - record for team title >#{team_title}< not found"
          exit 1
          ### fix/todo: throw exception/error
        end

        team_ids = event_attribs['team_ids'] || []
        team_ids << team.id
        event_attribs['team_ids'] = team_ids
      end
    end  # each_line

    pp event_attribs


    league_id = event_attribs['league_id']
    season_id = event_attribs['season_id']

    logger.debug "find event - league_id: #{league_id}, season_id: #{season_id}"

    event = Event.find_by( league_id: league_id,
                           season_id: season_id )

    ## check if it exists
    if event.present?
      logger.debug "*** update event #{event.id}-#{event.key}:"
    else
      logger.debug "*** create event:"
      event = Event.new

      ## hack:  fix/todo1!!
      ##   add "fake" start_at date for now
      if season.key.size == '4'   ## e.g. assume 2018 etc.
        year = season.key.to_i
        start_at = Date.new( year, 1, 1 )
      else  ## assume 2014/15 etc.
        year = season.key[0..3].to_i
        start_at = Date.new( year, 7, 1 )
      end
      event_attribs['start_at'] = start_at
    end

    logger.debug event_attribs.to_json

    event.update_attributes!( event_attribs )

    # keep a cached reference for later use
    @event = event
  end  # method read
