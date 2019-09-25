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
    ##  e.g Eupen        => KAS Eupen,    ## [de]
    ##   => Eupen        => KAS Eupen,
    line = line.sub( /#.*/, '' ).strip
    pp line


    if line.start_with?( '|' )
      ## assume continuation with line of alternative names
      ##  note: skip leading pipe
      values = line[1..-1].split( '|' )   # team names - allow/use pipe(|)
      ## strip and  squish (white)spaces
      #   e.g. New York FC      (2011-)  => New York FC (2011-)
      values = values.map { |value| value.strip.gsub( /[ \t]+/, ' ' ) }
      last_country.alt_names += values
    else
      ## assume "regular" line
      ##  check if starts with id  (todo/check: use a more "strict"/better regex capture pattern!!!)
      if line =~ /^([a-z]{2,3})[ ]+(.+)$/
        key    = $1
        values = $2.split( ',' )
        ## strip and squish (white)spaces
        #   e.g. New York FC      (2011-)  => New York FC (2011-)
        values = values.map { |value| value.strip.gsub( /[ \t]+/, ' ' ) }

        ## note: remove territory of marker e.g. (UK), (US), etc. from name
        ##    e.g. England (UK)     => England
        ##         Puerto Rico (US) => Puerto Rico
        name = values[0].sub( /\([A-Z]{2}\)/, '' ).strip
        fifa = values[1]  ## todo: check if fifa is nil - why? why not?

        last_country = country = Country.new( key, name, fifa )
        countries << country
      else
        puts "** !! ERROR !! missing key for (canonical) country name"
        exit 1
      end
    end
  end  # each_line
  countries
end  # method parse


end  # class CountryReader

end   # module Import
end   # module SportDb
