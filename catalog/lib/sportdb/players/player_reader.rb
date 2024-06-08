
module SportDb
module Import


### derive subclass e.g. National(Squad)Player or 
##                        Club(Squad)Player or such
###                       why? why not?  
class Player
  attr_reader :name,
              :pos,      # position (g/d/m/f) for now
              :nat,      # nationality
              :height,   # in cm!! (integer) expected
              :birthdate,
              :birthplace

   ## for national team squads            
   attr_reader :num,        ## jersey/shirt number
               :club,       ## current club
               :club_nat,   ## current club nationality
               :caps,       ## caps
               :goals       ## goals

  attr_accessor :alt_names

def initialize( name:,
                pos:    nil,
                nat:    nil,  
                height: nil,
                birthdate: nil,
                birthplace: nil,
                num: nil,
                club: nil,
                club_nat: nil,
                caps: nil,
                goals: nil )
    @name       = name
    @alt_names  = []
    @pos        = pos
    @nat        = nat
    @height     = height
    @birthdate  = birthdate
    @birthplace = birthplace

    @num  = num
    @club = club
    @club_nat = club_nat
    @caps  = caps
    @goals = goals
end
end  # class Player




class PlayerReader

  def world() Import.world; end


def self.read( path )   ## use - rename to read_file or from_file etc. - why? why not?
  txt = File.open( path, 'r:utf-8' ) { |f| f.read }
  parse( txt )
end

def self.parse( txt )
  new( txt ).parse
end



include Logging

def initialize( txt )
  @txt = txt
end


def parse
  recs = []
  last_rec = nil
  country  = nil    # last country

  OutlineReader.parse( @txt ).each do |node|
    if [:h1,:h2,:h3,:h4,:h5,:h6].include?( node[0] )
      heading_level  = node[0][1].to_i
      heading        = node[1]

      logger.debug "heading #{heading_level} >#{heading}<"

      if heading_level != 1
        puts "** !!! ERROR !!! unsupported heading level; expected heading 1 for now only; sorry"
        pp line
        exit 1
      else
        logger.debug "heading (#{heading_level}) >#{heading}<"
        last_heading = heading
        ## map to country or international / int'l or national teams
          ## assume country in heading; allow all "formats" supported by parse e.g.
          ##   Österreich • Austria (at)
          ##   Österreich • Austria
          ##   Austria
          ##   Deutschland (de) • Germany
          country = world.countries.parse( heading )

          ## check country code - MUST exist for now!!!!
          if country.nil?
            puts "!!! error [player reader] - unknown country >#{heading}< - sorry - add country to config to fix"
            exit 1
          end
      end
    elsif node[0] == :p   ## paragraph with (text) lines
      lines = node[1]
      lines.each do |line|

         ## one line type for now only
         ##   split by comman
         values = line.split( ',' )
         values = values.map {|value| _squish( value ) }  ## squish/strip etc.

         ## assume "strict" order for now
         ##  make more flexible later
         ##  e.g.
         ##  David Alaba,  D,  1.75 m,  b. 24 Jun 1992 @ Vienna
         name   = values[0]
         pos    = values[1]   ## required for now
         height = values[2]
         born   = values[3] 

         ## check for n/a - not available markers
         height = nil   if ['','-'].include?( height ) 
         born   = nil   if ['','-'].include?( born ) 

         if height
            ## auto-convert to cm (integer)
            ## e.g. 1.75 m   to 175 (cm)
            height =  height.gsub( /[^0-9]/, '' ).to_i( 10 )
         end

         ## split in birthdate (and birthplace)
         birthdate  = nil
         birthplace = nil
         if born
             ## cut-off  (optional)  b. prefix
             born = born.sub( /^b\./, '' ).strip
             values = born.split( '@' )
             values = values.map {|value| _squish( value ) }  ## squish/strip etc.

             ## assume format is 24 Jun 1992
             ## for now
             birthdate  = Date.strptime( values[0], '%d %b %Y' )
             birthplace = values[1]  if values.size > 1
         end

         ## use fifa codes for nat?
         ##  or use internet codes for nat?
         ##  note - to allow "auto-magic" joins with catalog.db
         ##   use country keys for now (e.g. internet codes mostly)
         ##   same with leagues - use internet codes mostly
         ##    reuse for consistency - why? why not?

         rec = Player.new(  name:       name,
                            pos:        pos.downcase,
                            nat:        country.key,
                            height:     height,
                            birthdate:  birthdate,
                            birthplace: birthplace
                            )
          recs << rec
          last_rec = rec
      end  # each line
    else
      puts "** !!! ERROR !!! [player reader] - unknown line type:"
      pp node
      exit 1
    end
    ## pp line
  end
  recs
end # method parse


#######################
###  helpers

## norm(alize) helper  - squish (spaces) 
##                      and remove dollars ($$$)
##                      and remove leading and trailing spaces
def _squish( str )
  str.gsub( /[ \t\u00a0]+/, ' ' ).strip
end


end # class PlayereReader

end ## module Import
end ## module SportDb
