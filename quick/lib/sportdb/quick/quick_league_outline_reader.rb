

module SportDb

## shared "higher-level" outline reader
###   quick version WITHOUT any validation/mapping !!!

class QuickLeagueOutlineReader

  def self.read( path )
    txt = File.open( path, 'r:utf-8' ) {|f| f.read }
    parse( txt )
  end

  def self.parse( txt )
    new( txt ).parse
  end


  def initialize( txt )
    @txt = txt
  end

  def parse
    secs=[]     # sec(tion)s
    OutlineReader.parse( @txt ).each do |node|
      if node[0] == :h1
        ## check for league (and stage) and season
        heading = node[1]
        values = split_league( heading )
        if m=values[0].match( LEAGUE_SEASON_HEADING_RE )
          puts "league >#{m[:league]}<, season >#{m[:season]}<"

           secs << { league: m[:league],
                     season: m[:season],
                     stage:  values[1],     ## note: defaults to nil if not present
                     lines:  []
                   }
        else
          puts "** !!! ERROR - cannot match league and season in heading; season missing?"
          pp heading
          exit 1
        end
      elsif node[0] == :p   ## paragraph with (text) lines
        lines = node[1]
        ## note: skip lines if no heading seen
        if secs.empty?
          puts "** !!! WARN - skipping lines (no heading):"
          pp lines
        else
          ## todo/check: unroll paragraphs into lines or pass along paragraphs - why? why not?
          secs[-1][:lines] += lines
        end
      else
        puts "** !!! ERROR - unknown line type; for now only heading 1 for leagues supported; sorry:"
        pp node
        exit 1
      end
    end
    secs
  end # method parse


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

  def split_league( str )   ## todo/check: rename to parse_league(s) - why? why not?
    ## split into league / stage / ... e.g.
    ##  => Österr. Bundesliga 2018/19, Regular Season
    ##  => Österr. Bundesliga 2018/19, Championship Round
    ##  etc.
    values = str.split( /[,<>‹›]/ )  ## note: allow , > < or › ‹ for now
    values = values.map { |value| value.strip }   ## remove all whitespaces
    values
  end
 end # class QuickLeagueOutlineReader
end # module SportDb
