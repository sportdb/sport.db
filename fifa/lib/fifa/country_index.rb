
module Fifa


## built-in countries for (quick starter) auto-add
class CountryIndex

  def self.read( *paths )
    recs = []
    paths.each do |path|
      recs += CountryReader.read( path )
    end
    new( recs )
  end


  def initialize( recs=nil )
    @countries  = []
    @by_code    = {}  ## countries by codes (fifa, internet, etc)
    @by_name    = {}  ##  normalized name
    @orgs       = OrgIndex.new

    add( recs )   if recs
  end

  def countries() @countries; end
  def size()  @countries.size; end
  def each( &blk ) @countries.each { |country| blk.call( country ) }; end



  def members( key=:fifa )   ## default to fifa members
    @orgs.members( key )
  end

  ## for testing/debugging return org keys
  ##   return OrgIndex instead - why? why not?
  def orgs() @orgs.keys; end


  def find( q )
    ## todo/fix - add find by name (find_by_name_and_code) - why? why not?
    find_by_code( q )
  end

  def find_by_code( code )
    key = code.to_s.downcase   ## allow symbols (and always downcase e.g. AUT to aut etc.)
    @by_code[ key ]
  end
  alias_method :[], :find_by_code

  def find_by_name( name )
     key = normalize( unaccent( name.to_s ))
     @by_name[ key ]
  end



  include SportDb::NameHelper
  ## strip_year, strip_lang, normalize etc.


  def add( recs )
    @countries += recs

    _add( recs)              ## step one add to our own index
    @orgs.add( recs )   ## step two add to orgs (helper) index (for members)
  end


  def _add( recs )
    recs.each do |rec|
      ## step 1 - add code lookups - key, fifa, ...
      rec.codes.each do |code|
        if @by_code.has_key?( code )
          puts "** !!! ERROR - country code already in use >#{code}<; sorry - no duplicates allowed!!"
          pp rec
          pp @by_code[ code ]
          exit 1
        else
          @by_code[ code ] = rec
        end
      end

      ## step 2 - add name lookups
      names = rec.names
      ## remove year and norm
      names = names.map { |name| normalize( unaccent( strip_year( name ))) }

      ## note - allow duplicates only if same country
      ##   e.g Panama, Panamá
      names = names.uniq

      names.each do |name|
        if @by_name.has_key?( name )
          puts "** !!! ERROR - country (norm) name already in use >#{name}<; sorry - no duplicates allowed!!"
          pp rec
          pp @by_name[ name ]
          exit 1
        else
          @by_name[ name ] = rec
        end
      end
    end
  end # method add
end   # class CountryIndex
end   # module Fifa
