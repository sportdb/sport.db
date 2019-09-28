# encoding: utf-8


module SportDb
module Import


class CountryReader


def self.read( path )   ## use - rename to read_file or from_file etc. - why? why not?
  txt = File.open( path, 'r:utf-8' ).read
  parse( txt )
end

def self.parse( txt )
  countries    = []
  last_country = nil    ## note/check/fix: use countries[-1] - why? why not?

  txt.each_line do |line|
    line = line.strip

    next if line.empty?
    break if line == '__END__'


    next if line.start_with?( '#' )   ## skip comments too

    ## strip inline (until end-of-line) comments too
    ##  e.g bq   Bonaire,  BOE        # CONCACAF
    ##   => bq   Bonaire,  BOE
    line = line.sub( /#.*/, '' ).strip
    pp line

    ## skip headings (and headings) for now too
    next if line.start_with?( '=' )



    if line.start_with?( '|' )
      ## assume continuation with line of alternative names
      ##  note: skip leading pipe
      values = line[1..-1].split( '|' )   # team names - allow/use pipe(|)
      ## strip and squish (white)spaces
      #   e.g. East Germany        (-1989)  => East Germany (-1989)
      values = values.map { |value| value.strip.gsub( /[ \t]+/, ' ' ) }
      last_country.alt_names += values
    else
      ## assume "regular" line
      ##  check if starts with id  (todo/check: use a more "strict"/better regex capture pattern!!!)
      if line =~ /^([a-z]{2,3})[ ]+(.+)$/
        key    = $1
        values = $2.split( ',' )
        ## strip and squish (white)spaces
        #   e.g. East Germany        (-1989)  => East Germany (-1989)
        values = values.map { |value| value.strip.gsub( /[ \t]+/, ' ' ) }

        ## note: remove "overlords" from geo-tree marked territories  e.g. UK, US, etc. from name
        ##    e.g. England › UK      => England
        ##         Puerto Rico › US  => Puerto Rico
        geos = split_geo( values[0] )
        name = geos[0]    ## note: ignore all other geos for now

        fifa = if values[1] && values[1] =~ /^[A-Z]{3}$/   ## note: also check format
                 values[1]
               else
                 if values[1]
                   puts "** !!! ERROR !!! wrong fifa code format >#{values[1]}<; expected three-letter all up-case"
                 else
                   puts "** !!! ERROR !!! missing fifa code for (canonical) country name"
                 end
                 exit 1
               end

        tags = if values[2]   ## check if tags presents
                 split_tags( values[2] )
               else
                 []
               end

        last_country = country = Country.new( key, name, fifa: fifa, tags: tags )
        countries << country
      else
        puts "** !! ERROR !! missing key for (canonical) country name"
        exit 1
      end
    end
  end  # each_line
  countries
end  # method parse


#######################################
##  helpers
def self.split_tags( str )
  tags = str.split( /[|<>‹›]/ )   ## allow pipe (|) and (<>‹›) as divider for now - add more? why? why not?
  tags = tags.map { |tag| tag.strip }
  tags
end

def self.split_geo( str )   ## todo/check: rename to parse_geo(s) - why? why not?
  ## split into geo tree
  geos = str.split( /[<>‹›]/ )          ## note: allow > < or › ‹ for now
  geos = geos.map { |geo| geo.strip }   ## remove all whitespaces
  geos
end

end  # class CountryReader

end   # module Import
end   # module SportDb
