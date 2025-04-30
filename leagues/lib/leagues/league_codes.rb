#####
#
#  quick & dirty league code lookup (and mapping)


module SportDb
class LeagueCodes 
    

####
## (public) api
def self.valid?( code )   
    ## check if code is valid
    builtin.valid?( code )
end

def self.find_by( code:, season: )
    ## return league code record/item or nil
    builtin.find_by( code: code, season: season )
end


#####
## (static) helpers
def self.builtin
   ## get builtin league code index (build on demand)
   @leagues ||= begin
        leagues = SportDb::LeagueCodes.new
        ['leagues',
         'leagues_more',
        ].each do |name|
           recs = read_csv( "#{SportDb::Module::Leagues.root}/config/#{name}.csv" )
           leagues.add( recs )
        end

        ['codes_alt',
        ].each do |name|
           recs = read_csv( "#{SportDb::Module::Leagues.root}/config/#{name}.csv" )
           leagues.add_alt( recs )
        end
        leagues
   end
   @leagues
end

def self.norm( code )      ## use norm_(league)code - why? why not?
  ## norm league code
  ##   downcase
  ##   and remove all non-letters/digits e.g. at.1 => at1, at 1 => at1 etc.
  ##                                            ö.1 => ö1
  ##   note - allow unicode letters!!! 
  ##    note - assume downcase works for unicode too e.g. Ö=>ö
  ##           for now no need to use our own downcase - why? why not?

  code.downcase.gsub( /[^\p{Ll}0-9]/, '' )
end




def initialize
    ## keep to separate (hash) table for now - why? why not?
    @leagues = {}
    @codes   = {}
end    


def add( recs )
  recs.each do |rec|
    key = LeagueCodes.norm( rec['code'] )
    @leagues[ key ] ||= []

    ## note: auto-change seasons to season object or nil
    @leagues[ key ] << {  'code'         => rec['code'],
                          'name'         => rec['name'],
                          'basename'     => rec['basename'],
                          'start_season' => rec['start_season'].empty? ? nil : Season.parse( rec['start_season'] ),
                          'end_season'   => rec['end_season'].empty?   ? nil : Season.parse( rec['end_season'] ),
                       }
  end
end

### step two - add alt(ernative) codes
def add_alt( recs )
  recs.each do |rec|
    key = LeagueCodes.norm( rec['alt'] )
    @codes[ key ] ||= []

  ### double check code reference 
  ##    MUST be present for now!!
     ref_key = LeagueCodes.norm( rec['code'] )
     unless @leagues.has_key?( ref_key )
       raise ArgumentError, "league code >#{rec['code']}< for alt code >#{rec['alt']}< not found; sorry" 
     end  

    ## note: auto-change seasons to season object or nil
    @codes[ key ] << {  'code'         => rec['code'],
                        'alt'          => rec['alt'],
                        'start_season' => rec['start_season'].empty? ? nil : Season.parse( rec['start_season'] ),
                        'end_season'   => rec['end_season'].empty?   ? nil : Season.parse( rec['end_season'] ),
                     }
 end
end


def valid?( code )
  ## check if code is valid
  ##   1) canonical codes  (check first - why? why not?)
  ##   2) alt codes
  raise ArgumentError, "league code as string|symbol expected"  unless code.is_a?(String) || code.is_a?(Symbol)

  key = LeagueCodes.norm( code )
  found = @leagues.has_key?( key )
  found = @codes.has_key?( key )   if found == false
  found
end


def find_by( code:, season: )
  raise ArgumentError, "league code as string|symbol expected"  unless code.is_a?(String) || code.is_a?(Symbol)

  ## return league code record/item or nil
  ## check for alt code first
  season = Season( season )
  key    = LeagueCodes.norm( code )
  rec    = nil

  if !@leagues.has_key?( key )    ## try alt codes
     key = _find_alt_code( key, season )
  end

  if key
    recs = @leagues[ key ] 
    if recs
      rec =  _find_by_season( recs, season )
    end
  end


  if rec   ## (quick hack for now) auto-add timezone
      ## use canoncial (league) code
      ##   note - if timezone changes MUST auto-create a NEW record
      ##              thus, for now always create a new copy (via dup)!!!
     rec = rec.dup  
     rec['tz'] = find_zone!( league: rec['code'], season: season )
  end


  rec   ## return nil if no code record/item found
end


def _find_alt_code( key, season )
     ## check alt keys
     ref_key = nil
     recs = @codes[key]
     if recs
        rec = _find_by_season( recs, season )
        ## norm code
        ref_key = LeagueCodes.norm( rec['code'] )  if rec  
     end

     ref_key    ## return nil if no mapping found
end


def _find_by_season( recs, season )
  recs.each do |rec|
      start_season = rec['start_season']
      end_season   = rec['end_season']
      return rec  if (start_season.nil? || start_season <= season) &&
                     (end_season.nil? || end_season >= season)
  end
  nil
end


end # class LeagueCodes
end # module SportDb    
    