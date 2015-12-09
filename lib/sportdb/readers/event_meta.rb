# encoding: UTF-8

module SportDb


class EventMetaReader

  include LogUtils::Logging

## make models available by default with namespace
#  e.g. lets you use Usage instead of Model::Usage
  include Models

  attr_reader :event           # returns event record; call read first
  attr_reader :fixtures        #  fixtures/sources entry from event config

  def self.from_zip( zip_file, entry_path, more_attribs={} )
    ## get text content from zip
    entry = zip_file.find_entry( entry_path )

    text = entry.get_input_stream().read()
    text = text.force_encoding( Encoding::UTF_8 )

    config = File.basename( entry_path, File.extname(entry_path) )  # name a of .yml file

    self.from_string( text, config, more_attribs )
  end

  def self.from_file( path, more_attribs={} )
    ## note: assume/enfore utf-8 encoding (with or without BOM - byte order mark)
    ## - see textutils/utils.rb
    text = File.read_utf8( path )
    
    config = File.basename( path, File.extname(path) )  # name a of .yml file
    
    self.from_string( text, config, more_attribs )
  end

  def self.from_string( text, config, more_attribs={} )
    self.new( text, config, more_attribs )
  end  

  def initialize( text, config, more_attribs={} )
    ## todo/fix: how to add opts={} ???
    ##  todo/check: more_attribs used ???
    @text = text
    @more_attribs = more_attribs

    # name of  event configuration (relative basename w/o path or string)
    @config   = config
    
    @event    = nil
    @fixtures = []
  end


  def read
    @fixtures = []    # reset cached fixtures
    @event    = nil   # reset cached event rec

    reader = HashReader.from_string( @text )

    league = nil
    season = nil

    reader.each_typed do |key, value|

      ## puts "processing event attrib >>#{key}<< >>#{value}<<..."

      if key.downcase == 'league'   ## note: allow league, League, etc.
        league_key = value.to_s.strip
        ## check if league_key includes uppercase letters (e.g. Deutsche Bundesliga and NOT de etc.)
        if league_key =~ /[A-Z]/
          ## assume league name (NOT league key); try to lookup leauge key in database
          league = League.find_by( title: league_key )
          ##  todo: add synonyms/alt names - why? why not??
        else
          ## assume "verbatim/literal" team_key (use as is 1:1)
          league = League.find_by( key: league_key )
        end       
    
        ## check if it exists
        if league.nil?
          logger.error "league with key >>#{league_key}<< missing"
          exit 1
        end
      elsif key.downcase == 'season'   ## note: allow season, Season, etc.
        season_key = value.to_s.strip
        season = Season.find_by( key: season_key )        

        ## check if it exists
        if season.nil?
          logger.error "season with key >>#{season_key}<< missing"
          exit 1
        end
      elsif key.downcase == 'fixtures' || key.downcase == 'sources'
        ### todo: check for mulitiple fixtures/sources ?? allow disallow?? why? why not?
        if value.kind_of?(Array)
          @fixtures += value
        else # assume plain (single fixture) string
          @fixtures << value.to_s
        end
      else
        ## todo: add a source location struct to_s or similar (file, line, col)
        logger.error "unknown event attrib #{key}; skipping attrib"
      end
    end # each key,value

    # check fixtures - if nothing specified; use basename of config (this) file
    if @fixtures.empty?
      logger.debug "  add default fixture (assume same basename as config file) e.g. >#{@config}<"
      @fixtures << @config  
    end

    logger.debug "find event - league.id: #{league.id}, season.id: #{season.id}"

    ## note: for now event MUST exist (read-only access)
    # keep a "cached" reference for later use
    @event = Event.find_by!( league_id: league.id,
                             season_id: season.id )
    
    @event
    
    ## todo/check:
    ##   return a "simple" hash in new (next) version - why? why not??
    ##    add fixtures (defaults) if missing
  end  # method read


end # class EventMetaReader
end # module SportDb
