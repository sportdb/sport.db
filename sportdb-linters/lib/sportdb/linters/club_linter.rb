module SportDb


class ClubLinter

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

        ## note if line starts with pipe (just delete for now)
        ##   in future bundle together names!!!!
        if line.start_with?( '|' )
           line = line.sub( '|', '' )
           names = parse_names( line )

           club = clubs[-1]  ## get last entry
           if club.nil?
             puts "** !!! ERROR !!! missing required main club line for additional optional name line starting with pipe (|)"
             exit 1
           end
        else
           ## check if starts with number e.g.   1   Liverpool
           line = line.sub( /^[0-9]{1,3}[ ]+/, '' )   if line =~ /^[0-9]{1,3}[ ]+/

           values = line.split( '@' )   ## allow (optinal) geos as 2nd part in line for now
           names = parse_names( values[0] )

           club = { names: [],
                    geos:  []  }
           clubs << club

           if values[1]   ## check for geos; note: for now assume single geo value (no further parsing/splitting)
              club[:geos] <<  values[1].strip
           end
        end
        ## note: add one-by-one to preserve array reference
        names.each {|name| club[:names] << name }
      else
        puts "** !!! ERROR !!! [club lint reader] - unknown line type:"
        pp node
        exit 1
      end
    end
    headings
  end # method parse


  def self.parse_names( line )
    ## check for multiple clubs entries / names
    values = line.split( '|' )
    values = values.map {|value| value.strip }
    values
  end

end # class ClubLinter

end ## module SportDb
