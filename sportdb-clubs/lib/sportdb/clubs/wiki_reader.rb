# encoding: utf-8


module SportDb
module Import

class WikiClub
  attr_reader :name, :country
  def initialize( name, country )
    @name, @country = name, country
  end
end



class WikiReader    ## todo/check: rename to WikiClubReader - why? why not?

##
## todo/check: make countries a method arg and NOT a global setting - why? why not?
##
def self.config=( value )  @config=value; end
def self.config     ## todo/check: rename to find_country( ) or something - why? why not?
  if @config
    @config
  else
    puts "** !! ERROR !! - country index required for club reader; sorry; use ClubReader.config to set/configure"
    exit 1
  end
end



def self.read( path )   ## use - rename to read_file or from_file etc. - why? why not?
  txt = File.open( path, 'r:utf-8' ).read
  parse( txt )
end


def self.parse( txt )
  recs = []
  last_country = nil  ## note: supports only one level of headings for now (and that is a country)

  txt.each_line do |line|
    line = line.strip

    next if line.empty?
    next if line.start_with?( '#' )   ## skip comments too

    ## strip inline (until end-of-line) comments too
    ##  e.g Eupen        => KAS Eupen,    ## [de]
    ##   => Eupen        => KAS Eupen,
    line = line.sub( /#.*/, '' ).strip
    pp line


    next if line =~ /^={1,}$/          ## skip "decorative" only heading e.g. ========

     ## note: like in wikimedia markup (and markdown) all optional trailing ==== too
     ##  todo/check:  allow ===  Text  =-=-=-=-=-=   too - why? why not?
    if line =~ /^(={1,})       ## leading ======
                 ([^=]+?)      ##  text   (note: for now no "inline" = allowed)
                 =*            ## (optional) trailing ====
                 $/x
       heading_marker = $1
       heading_level  = $1.length   ## count number of = for heading level
       heading        = $2.strip

       puts "heading #{heading_level} >#{heading}<"

       if heading_level > 1
         puts "** !!! ERROR [wiki reader] !!! -  - headings level too deep - only top / one level supported for now; sorry"
         exit 1
       end

      ## assume country in heading; allow all "formats" supported by parse e.g.
      ##   Österreich • Austria (at)
      ##   Österreich • Austria
      ##   Austria
      ##   Deutschland (de) • Germany
      country = config.countries.parse( heading )
      ## check country code - MUST exist for now!!!!
      if country.nil?
        puts "!!! error [wiki reader] - unknown country >#{heading}< - sorry - add country to config to fix"
        exit 1
      end

      last_country = country
      pp last_country
    else
      ## strip and  squish (white)spaces
      #   e.g. New York FC      (2011-)  => New York FC (2011-)
      value = line.strip.gsub( /[ \t]+/, ' ' )

      ## normalize (allow underscore (-) - replace with space)
      ##  e.g. Cercle_Brugge_K.S.V. =>  Cercle Brugge K.S.V.
      value = value.gsub( '_', ' ' )

      if last_country.nil?
        puts "** !!! ERROR [wiki reader] !!! - country heading missing for club name; sorry - add country heading to fix"
        exit 1
      end

      rec = WikiClub.new( value, last_country )
      recs << rec
    end
  end  # each_line
  recs
end  # method read

end  # class WikiReader

end ## module Import
end ## module SportDb
