
module SportDb
module Import


class ClubReader

  def world() Import.world; end



def self.read( path )   ## use - rename to read_file or from_file etc. - why? why not?
  txt = File.open( path, 'r:utf-8' ) { |f| f.read }
  parse( txt )
end

def self.parse( txt )
  new( txt ).parse
end

def initialize( txt )
  @txt = txt
end

##  pattern for b (child) team / club marker e.g.
##    (ii) or ii) or ii.) or (ii.) or (II)
##    (b)  or b)  or b.)  or (b.)  or (B)
##    (2)  or 2)  or 2.)  or (2.)
B_TEAM_MARKER_RE = %r{^  \(?     # optional opening bracket
                          (?: ii|b|2 )
                          \.?     # optional dot - keep and allow dot - why? why not?
                          \)      # required closing bracket
                     }xi   ## note: add case-insenstive (e.g. II/ii or B/b)

## pattern for checking for address line e.g.
##    use just one style / syntax - why? why not?
##  Fischhofgasse 12 ~ 1100 Wien or
##  Fischhofgasse 12 // 1100 Wien   or Fischhofgasse 12 /// 1100 Wien
##  Fischhofgasse 12 ++ 1100 Wien   or Fischhofgasse 12 +++ 1100 Wien
ADDR_MARKER_RE =  %r{ (?: ^|[ ] )                # space or beginning of line
                        (?: ~ | /{2,} | \+{2,} )
                      (?: [ ]|$)                 # space or end of line
                       }x



def parse
  recs = []
  last_rec  = nil
  headings = []   ## headings stack

  OutlineReader.parse( @txt ).each do |node|
    if [:h1,:h2,:h3,:h4,:h5,:h6].include?( node[0] )
      heading_level  = node[0][1].to_i
      heading        = node[1]

      puts "heading #{heading_level} >#{heading}<"

      ## 1) first pop headings if present
      while headings.size+1 > heading_level
        headings.pop
      end

      ## 2) add missing (hierarchy) level if
      while headings.size+1 < heading_level
        ##  todo/fix: issue warning about "skipping" hierarchy level
        puts "!!! warn [team reader] - skipping hierarchy level in headings "
        headings.push( nil )
      end

      if heading =~ /^\?+$/    ## note: use ? or ?? or ?? to reset level to nil
        ## keep level empty
      else
        ## note: if level is 1 assume country for now
        if heading_level == 1
            ## assume country in heading; allow all "formats" supported by parse e.g.
            ##   Österreich • Austria (at)
            ##   Österreich • Austria
            ##   Austria
            ##   Deutschland (de) • Germany
            country = world.countries.parse( heading )
            ## check country code - MUST exist for now!!!!
            if country.nil?
              puts "!!! error [club reader] - unknown country >#{heading}< - sorry - add country to config to fix"
              exit 1
            end

            headings.push( country.key )
        else
         ## quick hack:
         ##   remove known fill/dummy words incl:
         ##     Provincia San Juan  =>  San Juan   (see argentina, for example)
         ##
         ##   use geo tree long term with alternative names - why? why not?
          words = ['Provincia']
          words.each { |word| heading = heading.gsub( word, '' ) }
          heading = heading.strip

          headings.push( heading )
        end

        ## assert that hierarchy level is ok
        if headings.size != heading_level
          puts "!!! error - headings hierarchy/stack out of order - #{heading.size}<=>#{heading_level}"
          exit 1
        end
      end

      pp headings

    elsif node[0] == :p   ## paragraph with (text) lines
      lines = node[1]
      lines.each do |line|
      if line.start_with?( '|' )
        ## assume continuation with line of alternative names
        ##  note: skip leading pipe
        values = line[1..-1].split( '|' )   # team names - allow/use pipe(|)
        values = values.map {|value| _norm(value) }  ## squish/strip etc.

        last_rec.alt_names += values 

      ## check for b (child) team / club marker e.g.
      ##    (ii) or ii) or ii.) or (ii.)
      ##    (b)  or b)  or b.)  or (b.)
      ##    (2)  or 2)  or 2.)  or (2.)
      elsif line =~ B_TEAM_MARKER_RE
         line = line.sub( B_TEAM_MARKER_RE, '' ).strip   ## remove (leading) b team marker

         ## todo/fix: move into "regular" club branch - (re)use, that is, use the same code
         #                                                for both a and b team / club
         rec = Club.new
         ## note: assume / allow just canonical name for now
         ## strip and  squish (white)spaces
         #   e.g. New York FC      (2011-)  => New York FC (2011-)
         rec.name = _norm( line )            # canoncial name (global unique "beautiful/long" name)

         ### link a and b team / clubs
         ##   assume last_rec is the a team
         ##   todo/fix: check last_rec required NOT null
         rec.a      = last_rec
         last_rec.b = rec

         last_rec = rec
         recs << rec

       ## check for address line e.g.
       ##    use just one style / syntax - why? why not?
       ##  Fischhofgasse 12 ~ 1100 Wien or
       ##  Fischhofgasse 12 // 1100 Wien or Fischhofgasse 12 /// 1100 Wien
       ##  Fischhofgasse 12 ++ 1100 Wien or Fischhofgasse 12 +++ 1100 Wien
      elsif line =~ ADDR_MARKER_RE
         last_rec.address = _squish( line )
      else
        values = line.split( ',' )

        rec = Club.new

        col  = values.shift    ## get first item
        ## note: allow optional alt names for convenience with required canoncial name
        names = col.split( '|' )   # team names - allow/use pipe(|)
        names = names.map {|name| _norm(name) }  ## squish/strip etc.

        value     = names[0]         ## canonical name
        alt_names = names[1..-1]     ## optional (inline) alt names

        rec.name = value            # canoncial name (global unique "beautiful/long" name)
        ## note: add optional (inline) alternate names if present
        rec.alt_names += alt_names    if alt_names.size > 0

        ## note:
        ##   check/todo!!!!!!!!!!!!!!!!!-
        ##  strip year if to present e.g. (2011-)
        ##
        ##  do NOT strip for defunct / historic clubs e.g.
        ##    (1899-1910)
        ## or (-1914) or (-2011) etc.

        ###
        ##  todo: move year out of canonical team name - why? why not?

        ## check if canonical name include (2011-) or similar in name
        ##   if yes, remove (2011-) and add to (alt) names
        ##   e.g. New York FC (2011) => New York FC
        if rec.name =~ /\(.+?\)/   ## note: use non-greedy (?) match
          name = rec.name.gsub( /\(.+?\)/, '' ).strip

          if rec.name =~ /\(([0-9]{4})-\)/            ## e.g. (2014-)
            rec.year     = $1.to_i
          elsif  rec.name =~ /\(-([0-9]{4})\)/            ## e.g. (-2014)
            rec.year_end = $1.to_i
          elsif  rec.name =~ /\(([0-9]{4})-([0-9]{4})\)/  ## e.g. (2011-2014)
            rec.year     = $1.to_i
            rec.year_end = $2.to_i
          else
            ## todo/check: warn about unknown year format
          end
        end

        ##  todo/check - check for unknown format values
        ##    e.g. too many values, duplicate years, etc.
        ##         check for overwritting, etc.

        ##  strip and squish (white)spaces
        #   e.g. León     › Guanajuato     => León › Guanajuato
        values = values.map {|value| _squish(value) }

        while values.size > 0
          value = values.shift
          if value =~/^\d{4}$/   # e.g 1904
            ## todo/check: issue warning if year is already set!!!!!!!
            if rec.year
              puts "!!! error - year already set to #{rec.year} - CANNOT overwrite with #{value}:"
              pp rec
              exit 1
            end
            rec.year  = value.to_i
          elsif value.start_with?( '@' )   # e.g. @ Anfield
            ## cut-off leading @ and spaces
            rec.ground  = value[1..-1].strip
          else
            ## assume city / geo tree
            ## split into geo tree
            geos = split_geo( value )
            city = geos[0]
            ## check for "embedded" district e.g. London (Fulham) or Hamburg (St. Pauli) etc.
            if city =~ /\((.+?)\)/   ## note: use non-greedy (?) match
              rec.district  = $1.strip
              city          = city.gsub( /\(.+?\)/, '' ).strip
            end
            rec.city = city

            if geos.size > 1
               ## cut-off city and keep the rest (of geo tree)
               rec.geos = geos[1..-1]
            end
          end
        end  ## while values


        ###############
        ## use headings text for geo tree

        ## 1) add country if present
        if headings.size > 0 && headings[0]
          country = world.countries.find( headings[0] )
          rec.country = country
        else
          ## make it an error - why? why not?
          puts "!!! error - country missing in headings hierarchy - sorry - add to quicklist"
          exit 1
        end

        ## 2) check geo tree with headings hierarchy
        if headings.size > 1 && headings[1]
           geos = split_geo( headings[1] )
           if rec.geos
             if rec.geos[0] != geos[0]
               puts "!!! error - geo tree - headings mismatch >#{rec.geos[0]}< <=> >#{geos[0]}<"
               exit 1
             end
             if rec.geos[1] && rec.geos[1] != geos[1]   ## check optional 2nd level too
               puts "!!! error - geo tree - headings mismatch >#{rec.geos[1]}< <=> >#{geos[1]}<"
               exit 1
             end
           else
             ## add missing region (state/province) from headings hierarchy
             rec.geos = geos
           end
        end

        last_rec = rec

        recs << rec
      end
      end  # each line (in paragraph)
    else
      puts "** !!! ERROR !!! [club reader] - unknown line type:"
      pp node
      exit 1
    end
  end

  recs
end  # method read

#######################
###  helpers
def split_geo( str )
  ## assume city / geo tree
  ##  strip and squish (white)spaces
  #   e.g. León     › Guanajuato     => León › Guanajuato
  str = _squish( str ) 
  
  ## split into geo tree
  geos = str.split( /[<>‹›]/ )   ## note: allow > < or › ‹
  geos = geos.map { |geo| geo.strip }   ## remove all whitespaces
  geos
end


## norm(alize) helper  - squish (spaces) 
##                      and remove dollars ($$$)
##                      and remove leading and trailing spaces
def _norm( str )
  ## only extra clean-up of dollars for now ($$$)
  _squish( str.gsub( '$', '' ) )
end

def _squish( str )
  str.gsub( /[ \t\u00a0]+/, ' ' ).strip
end


end  # class ClubReader


end ## module Import
end ## module SportDb
