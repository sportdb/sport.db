
module SportDb
module Import

class PlayerUpdate
      attr_reader :names,
                  :birthyear,
                  :nat
        
    def initialize( names:,
                    birthyear:,
                    nat:)  
        @names      = names
        @nat        = nat
        @birthyear  = birthyear
    end
end  # class PlayerUpdate
    
  

class PlayerUpdateReader

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
            puts "!!! error [national squad reader] - unknown country >#{heading}< - sorry - add country to config to fix"
            exit 1
          end
      end
    elsif node[0] == :p   ## paragraph with (text) lines
      lines = node[1]
      lines.each do |line|

         ## one line type for now only
         ##   split by comman
         values = line.split( ',' )
     
         ## assume "strict" order for now
         ##  make more flexible later
         ##  e.g.
         ##   Max Wöber | Maximilian Wöber,  b. 1998

         names_str     = values[0]
         birthyear_str = values[1] 

         names     = names_str.split( '|' )
         names     = names.map {|name| _squish( name ) }
         birthyear = _squish( birthyear_str.sub( 'b.', '' )).to_i( 10 ) 

         ## use fifa codes for nat?
         ##  or use internet codes for nat?
         ##  note - to allow "auto-magic" joins with catalog.db
         ##   use country keys for now (e.g. internet codes mostly)
         ##   same with leagues - use internet codes mostly
         ##    reuse for consistency - why? why not?

         rec = PlayerUpdate.new(  names:      names,
                                  birthyear:  birthyear,   
                                  nat:        country.key,
                               )
          recs << rec
      end  # each line
    else
      puts "** !!! ERROR !!! [player update reader] - unknown line type:"
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

end # class PlayerUpdateReader

end ## module Import
end ## module SportDb
