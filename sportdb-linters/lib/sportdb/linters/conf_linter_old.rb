module SportDb

class ConfLinterOld   ### todo/check: rename to ??? - find a better name? why? why not?

  def self.read( path )   ## use - rename to read_file or from_file etc. - why? why not?
    txt = File.open( path, 'r:utf-8' ).read
    parse( txt )
  end

  def self.parse( txt )
    headings = []
    clubs   = nil   ## current clubs array   ## note: same as headings[-1][1]

    OutlineReader.parse( txt ).each do |node|
      if [:h1,:h2,:h3,:h4,:h5,:h6].include?( node[0] )
        heading_level  = node[0][1].to_i
        heading        = node[1]

        puts "heading #{heading_level} >#{heading}<"

        if heading_level != 1
          puts "** !! ERROR !! unsupported heading level; expected heading 1 for now only; sorry"
          pp line
          exit 1
        else
          puts "heading (#{heading_level}) >#{heading}<"
          ## todo/fix:  strip/remove season if present first - why? why not?
          clubs = []
          headings <<  [ heading, clubs ]
        end
      elsif node[0] == :l   ## regular (text) line; assume club name
        line = node[1]

        next if line =~ /^[ -]+$/         ## skip "decorative"  line e.g. --- or - - - -

        if clubs.nil?
          puts "** !!! ERROR !!! heading missing / expected; cannot add club; sorry - add heading"
          exit 1
        end

        scan = StringScanner.new( line )

        if scan.check( /\d{1,2}[ ]+/ )    ## entry with standaning starts with ranking e.g. 1,2,3, etc.
            puts "  table entry >#{line}<"
            rank = scan.scan( /\d{1,2}[ ]+/ ).strip   # note: strip trailing spaces

            ## note: uses look ahead scan until we hit at least two spaces
            ##  or the end of string  (standing records for now optional)
            name = scan.scan_until( /(?=\s{2})|$/ )
            if scan.eos?
              standing = nil
            else
              standing = scan.rest.strip   # note: strip leading and trailing spaces
            end
            puts "   rank: >#{rank}<, name: >#{name}<, standing: >#{standing}<"

            clubs << { rank:     rank,
                       name:     name,
                       standing: standing
                     }
         else
            ## assume club is full line
            clubs << { name: line }
         end
       else
         puts "** !!! ERROR !!! [conf lint reader] - unknown line type:"
         pp node
         exit 1
       end
    end
    headings
  end # method parse
end # class ConfLinterOld


end ## module SportDb

