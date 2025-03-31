
module SportDb
class LeagueCodes 
    

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
    @leagues = SportDb::LeagueConfig.new
end    

def add( recs )
  @leagues.add( recs )
end

### step two - add alt(ernative) codes
def add_alt( recs )

    
end



def [](code) 
    @leagues[ code ] 
end



end # class LeagueCodes
end # module SportDb    
    