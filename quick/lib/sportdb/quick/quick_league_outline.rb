

module SportDb

## shared "higher-level" outline reader
###   quick version WITHOUT any (database) validation/mapping/normalization !!!


class QuickLeagueOutline

  def self.read( path )
    nodes = OutlineReader.read( path ) 
    new( nodes )
  end    

  def self.parse( txt )
    nodes = OutlineReader.parse( txt )
    new( nodes )
  end



  def initialize( nodes )
    @nodes = nodes
  end


  ###
  # use Section struct for easier access - why? why not?
  ##     e.g. sec.league instead of sec[:league] etc.

  Section = Struct.new( :league, :season, :stage, :lines )  do
     def text  ## for alternate line access (all-in-text string)
        txt = lines.reduce( String.new ) do |mem,line| 
                 mem << line; mem << "\n"; mem 
              end
        txt
     end
  end

  def each_sec( &blk )
     @secs ||= _parse

     @secs.each do |sec|
        blk.call( sec )
     end 
  end
  alias_method :each_section, :each_sec


  def _parse
    secs=[]     # sec(tion)s
    @nodes.each do |node|
      if node[0] == :h1
        ## check for league (and stage) and season
        heading = node[1]
        values = _split_league( heading )
        if m=values[0].match( LEAGUE_SEASON_HEADING_RE )
          puts "league >#{m[:league]}<, season >#{m[:season]}<"

           secs << Section.new( league: m[:league],
                                season: m[:season],
                                stage:  values[1],   ## note: defaults to nil if not present
                                lines:  [] 
                              )
        else
          puts "** !!! ERROR - cannot match league and season in heading; season missing?"
          pp heading
          exit 1
        end
      elsif node[0] == :h2
         ## todo/check - make sure parsed h1 first
         heading = node[1]
         ## note - reuse league, season from h1
         secs << Section.new( league: secs[-1].league,
                              season: secs[-1].season,
                              stage:  heading,
                              lines:  [] 
                            )
      elsif node[0] == :p   ## paragraph with (text) lines
        lines = node[1]
        ## note: skip lines if no heading seen
        if secs.empty?
          puts "** !!! WARN - skipping lines (no heading):"
          pp lines
        else
          ## todo/check: unroll paragraphs into lines or pass along paragraphs - why? why not?
          ##    add paragraphs not unrolled lines - why? why not?
          secs[-1].lines += lines
        end
      else
        puts "** !!! ERROR - unknown line type; for now only heading 1 for leagues supported; sorry:"
        pp node
        exit 1
      end
    end
    secs
  end # method _parse


  ## split into league + season
  ##  e.g. Österr. Bundesliga 2015/16   ## or 2015-16
  ##       World Cup 2018
  LEAGUE_SEASON_HEADING_RE =  %r{^
         (?<league>.+?)     ## non-greedy
            \s+
         (?<season>\d{4}
            (?:[\/-]\d{1,4})?     ## optional 2nd year in season
         )
            $}x

  def _split_league( str )   ## todo/check: rename to parse_league(s) - why? why not?
    ## split into league / stage / ... e.g.
    ##  => Österr. Bundesliga 2018/19, Regular Season
    ##  => Österr. Bundesliga 2018/19, Championship Round
    ##  etc.
    ## note limit split to two parts only!!!!
    values = str.split( /[,<>‹›]/, 2 )  ## note: allow , > < or › ‹ for now
    values = values.map { |value| value.strip }   ## remove all whitespaces
    values
  end
 end # class QuickLeagueOutline
end # module SportDb
