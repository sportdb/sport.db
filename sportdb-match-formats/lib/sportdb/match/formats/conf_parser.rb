module SportDb

  class ConfParser

    def self.parse( lines )
      parser = new( lines )
      parser.parse
    end

    include Logging         ## e.g. logger#debug, logger#info, etc.
    include ParserHelper    ## e.g. read_lines, etc.


    def initialize( lines )
      # for convenience split string into lines
      ##    note: removes/strips empty lines
      ## todo/check: change to text instead of array of lines - why? why not?
      @lines        = lines.is_a?( String ) ? read_lines( lines ) : lines
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
                      (?<club>.+?)   ## note: let's use non-greedy (MINIMUM length) match for now
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
      clubs = {}    ## convert lines to clubs

      @lines.each do |line|
        next if line =~ /^[ -]+$/   ## skip decorative lines with dash only (e.g. ---- or - - - -) etc.


        ## quick hack - check for/extract (optional) county code (for clubs) first
        ##  allow as separators <>‹›,  NOTE: includes (,) comma for now too
        m = nil
        country = nil
        if m=COUNTRY_RE.match( line )
          country = m[:country]
          line = line.sub( m[0], '' )  ## replace match with nothing for now
        end

        if m=TABLE_RE.match( line )
          puts "  matching table entry >#{line}<"

          name = m[:club]
          rank = m[:rank]

          standing = {
            pld: m[:pld],
            w:   m[:w],
            d:   m[:d],
            l:   m[:l],
            gf:  m[:gf],
            ga:  m[:ga],
          }
          standing[ :gd ]        = m[:gd]         if m[:gd]
          standing[ :pts ]       = m[:pts]
          standing[ :deduction ] = m[:deduction]  if m[:deduction]


          club = clubs[ name ] ||= { count: 0 }
          club[ :count ]    += 1    ## track double usage - why? why not? report/raise error/exception on duplicates?
          club[ :country ]   = country     if country

          club[ :rank ]      = rank        if rank
          club[ :standing ]  = standing    if standing
        else
          ## assume club is full line
          name = line.strip  # note: strip leading and trailing spaces

          club = clubs[ name ] ||= { count: 0 }
          club[ :count ]   += 1
          club[ :country ]  = country     if country
        end
      end

      clubs
    end # method parse

  end # class ConfParser
end # module SportDb
