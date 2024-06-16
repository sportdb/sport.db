
module SportDb
module Import


class NationalSquadReader

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

          ## note - heading split in country and league
          ##   note - for now divider is dash " - " with leading/trailing spaces!!!
          values = heading.split( ' - ' )
          puts " ==> league - #{values[1]}"   ## note - gets ignored for now

          country = world.countries.parse( values[0].strip )

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
         values = values.map {|value| _squish( value ) }  ## squish/strip etc.

         ## assume "strict" order for now
         ##  make more flexible later
         ##  e.g.
         ##   1,  Péter Gulácsi,   GK,   53/0,  RB Leipzig (GER)

         num_str    = values[0]
         name       = values[1] 
         pos        = values[2]   ## required for now
         caps_str   = values[3]   ## split into caps & goals
         born_str   = values[4]
         club_str   = values[5]   ## split into club name & club nat/country

         ## check for n/a - not available markers
         num =  ['','-'].include?( num_str ) ? nil : num_str.to_i(10) 

         caps, goals =  if ['','-'].include?( caps_str ) 
                            [nil,nil]
                        else
                            caps_str.split( '/' ).map do |value| 
                                                   _squish(value).to_i(10) 
                                                 end
                        end
                    
         club, club_nat = if ['','-'].include?( club_str ) 
                           [nil,nil]
                          else
                              ## quick hack - replace (AUT) with ,AUT
                             club_str.sub( /\(
                                              ([A-Z]{3,4})
                                             \)$/x, ',\1' ).split( ',').map do |value|
                                   _squish( value )
                             end
                          end


         ## norm club_nat
         if club_nat
           club_country = world.countries.find_by_code( club_nat )
           if club_country
             club_nat = club_country.key
           else 
            puts "!!! error [national squad reader] - unknown country >#{club_nat}< for club >#{club}< - sorry - add country to config to fix"
            exit 1
           end 
          end

         # height    = nil
         # birthdate  = nil
         # birthplace = nil
       

         ## use fifa codes for nat?
         ##  or use internet codes for nat?
         ##  note - to allow "auto-magic" joins with catalog.db
         ##   use country keys for now (e.g. internet codes mostly)
         ##   same with leagues - use internet codes mostly
         ##    reuse for consistency - why? why not?

      
         ##
         ## todo/fix: 
         ##   add birthyear 
         ###   change struct to NationalSquadPlayer !!!!!
         ##       add birthyear!!!!

         rec = Player.new(  num: num,
                            name:       name,
                            pos:        _norm_pos( pos ),
                            nat:        country.key,
                            caps:       caps,
                            goals:      goals,
                            club:       club,
                            club_nat:   club_nat,
                            )
          recs << rec
          last_rec = rec
      end  # each line
    else
      puts "** !!! ERROR !!! [national squad reader] - unknown line type:"
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


NORM_POS = {
  'g' => 'g',  'gk' => 'g',
  'd' => 'd',  'df' => 'd',
  'm' => 'm',  'mf' => 'm',
  'f' => 'f',  'fw' => 'f'
}

def _norm_pos( str )
   pos = NORM_POS[str.downcase]
   if pos.nil?
     puts "!! ERROR - unknown (player) position;  g|d|m|f or gk|df|mf|fw expected; sorry"
     exit 1
   end
   pos
end

end # class NationalSquadReader

end ## module Import
end ## module SportDb
