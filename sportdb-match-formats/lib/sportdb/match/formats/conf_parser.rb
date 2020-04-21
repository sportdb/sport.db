module SportDb

  class ConfParser

    def self.parse( lines )
      parser = new( lines )
      parser.parse
    end


    include LogUtils::Logging

    def initialize( lines )
      # for convenience split string into lines
      ##    note: removes/strips empty lines
      if lines.is_a?( String )
         @lines = []
         lines.each_line do |line|    ## preprocess
            line = line.strip

            next if line.empty? || line.start_with?('#')   ###  skip empty lines and comments
            line = line.sub( /#.*/, '' ).strip             ###  cut-off end-of line comments too
            @lines << line
         end
      else
        @lines        = lines     ## todo/check: change to text instead of array of lines - why? why not?
      end
    end



    COUNTRY_RE = %r{ [<>‹›,]
                     [ ]*
                     (?<country>[A-Z]{2,4})   ## todo/check: allow one-letter (motor vehicle plates) or 5 letter possible?
                    \b}xi

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
          line = line.sub( m[0], ' ' )  ## replace match with single (white)space
        end


        scan = StringScanner.new( line )

        if scan.check( /\d{1,2}[ ]+/ )    ## entry with standaning starts with ranking e.g. 1,2,3, etc.
          puts "  table entry >#{line}<"
          rank = scan.scan( /\d{1,2}[ ]+/ ).strip   # note: strip trailing spaces

          ## note: uses look ahead scan until we hit at least two spaces
          ##  or the end of string  (standing records for now optional)
          name = scan.scan_until( /(?=\s{2})|$/ ).strip  # note: strip trailing spaces
          if scan.eos?
            standing = nil
          else
            standing = scan.rest.strip   # note: strip leading and trailing spaces
          end
          puts "   rank: >#{rank}<, name: >#{name}<, standing: >#{standing}<"

          club = clubs[ name ] ||= { count: 0 }
          club[ :count ]    += 1    ## track double usage - why? why not? report/raise error/exception on duplicates?
          club[ :country ]   = country     if country
          club[ :rank ]      = rank
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
