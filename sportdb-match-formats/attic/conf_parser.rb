

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
        end