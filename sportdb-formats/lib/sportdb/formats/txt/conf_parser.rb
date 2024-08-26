module SportDb

  class ConfParser

    def self.parse( lines )
      parser = new( lines )
      parser.parse
    end

    include Logging         ## e.g. logger#debug, logger#info, etc.

    def _read_lines( txt )   ## todo/check:  add alias preproc_lines or build_lines or prep_lines etc. - why? why not?
      ## returns an array of lines with comments and empty lines striped / removed
      lines = []
      txt.each_line do |line|    ## preprocess
         line = line.strip

         next if line.empty? || line.start_with?('#')   ###  skip empty lines and comments
         line = line.sub( /#.*/, '' ).strip             ###  cut-off end-of line comments too
         lines << line
      end
      lines
    end


    def initialize( lines )
      # for convenience split string into lines
      ##    note: removes/strips empty lines
      ## todo/check: change to text instead of array of lines - why? why not?
      @lines        = lines.is_a?( String ) ? _read_lines( lines ) : lines
    end



    COUNTRY_RE = %r{ [<>‹›,]
                     [ ]*
                     (?<country>[A-Z]{2,4})   ## todo/check: allow one-letter (motor vehicle plates) or 5 letter possible?
                    \b}xi


    ## standings table row regex matcher e.g.
    ##     1  Manchester City         38  32  4  2 106-27 100
    ## or  1. Manchester City         38  32  4  2 106:27 100
    TABLE_RE = %r{ ^
                    (?:
                      (?<rank>\d+)\.?
                         |
                        [-]
                     )
                    [ ]+
                      (?<team>.+?)   ## note: let's use non-greedy (MINIMUM length) match for now
                    [ ]+
                      (?<pld>\d+)    ## (pl)aye(d)
                    [ ]+
                      (?<w>\d+)      ## (w)ins
                    [ ]+
                      (?<d>\d+)     ## (d)raws
                    [ ]+
                      (?<l>\d+)      ## (l)ost
                    [ ]+
                      (?<gf>\d+)     ## (g)oal (f)or
                        [ ]*
                        [:-]    ## note: allow 10-10 or 10:10 or 10 - 10 or 10 : 10 etc.
                        [ ]*
                      (?<ga>\d+)      ## (g)oal (a)gainst
                     (?:          ## allow optional (g)oal (d)ifference
                        [ ]+
                        (?<gd>[±+-]?\d+)  ## (g)oal (d)ifference
                      )?
                     [ ]+
                      (?<pts>\d+)      ## (p)oin(ts)
                         (?:     ## allow optional deductions e.g. [-7]
                               [ ]+
                            \[(?<deduction>-\d+)\]
                         )?
                      $}x

    def parse
      teams = {}    ## convert lines to teams

      @lines.each do |line|
        next if line =~ /^[ -]+$/   ## skip decorative lines with dash only (e.g. ---- or - - - -) etc.


        ## quick hack - check for/extract (optional) county code (for teams) first
        ##  allow as separators <>‹›,  NOTE: includes (,) comma for now too
        m = nil
        country = nil
        if m=COUNTRY_RE.match( line )
          country = m[:country]
          line = line.sub( m[0], '' )  ## replace match with nothing for now
        end

        if m=TABLE_RE.match( line )
          puts "  matching table entry >#{line}<"

          name = m[:team]
          rank = m[:rank] ? Integer(m[:rank]) : nil

          standing = {
            pld: Integer(m[:pld]),
            w:   Integer(m[:w]),
            d:   Integer(m[:d]),
            l:   Integer(m[:l]),
            gf:  Integer(m[:gf]),
            ga:  Integer(m[:ga]),
          }
          standing[ :gd ]        = Integer(m[:gd].gsub(/[±+]/,''))    if m[:gd]
          standing[ :pts ]       = Integer(m[:pts])
          standing[ :deduction ] = Integer(m[:deduction])  if m[:deduction]


          ## todo/fix: track double usage - why? why not? report/raise error/exception on duplicates?
          team = teams[ name ] ||= { }
          team[ :country ]   = country     if country

          team[ :rank ]      = rank        if rank
          team[ :standing ]  = standing    if standing
        else
          ## assume team is full line
          name = line.strip  # note: strip leading and trailing spaces

          team = teams[ name ] ||= { }
          team[ :country ]  = country     if country
        end
      end

      teams
    end # method parse

  end # class ConfParser
end # module SportDb
