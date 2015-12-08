# encoding: UTF-8

module SportDb


class EventTableReader

  include LogUtils::Logging

## make models available by default with namespace
#  e.g. lets you use Usage instead of Model::Usage
  include Models

  attr_reader :event           # returns event record; call read first


  ## todo/fix: add from_zip()

  def self.from_file( path, more_attribs={} )
    ## note: assume/enfore utf-8 encoding (with or without BOM - byte order mark)
    ## - see textutils/utils.rb
    text = File.read_utf8( path )
        
    self.from_string( text, more_attribs )
  end

  def self.from_string( text, more_attribs={} )
    self.new( text, more_attribs )
  end  

  def initialize( text, more_attribs={} )
    ## todo/fix: how to add opts={} ???
    @text = text
    @more_attribs = more_attribs

    @event    = nil
  end


  ## split into league + season
  ##  e.g. Österr. Bundesliga 2015/16        
  ##       World Cup 2018
  EVENT_HEADER_REGEX =  /^
         (?<league>.+?)     ## non-greedy
            \s
         (?<season>\d{4}
            (?:\/\d{2})?     ## optional 2nd date in season
         )
            $/x   

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


end # class EventTableReader
end # module SportDb
