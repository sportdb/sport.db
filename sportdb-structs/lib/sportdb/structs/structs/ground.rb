##
#  based on teams/clubs
#              


module Sports


class Ground
  ##  todo: use just names for alt_names - why? why not?
  attr_accessor :key, :name, :alt_names,
                :year, :year_end,   ## todo/fix: change year to start_year and end_year/year_end to end_year (like in season)!!!
                :country,
                :city, :district, 
                :geos,
                :address

  def names
    ## todo/check: add alt_names_auto too? - why? why not?
    [@name] + @alt_names
  end   ## all names

  def key
    ## note: auto-generate key "on-the-fly" if missing for now - why? why not?
    ## note: quick hack - auto-generate key, that is, remove all non-ascii chars and downcase
    ##  fix update - allow numbers (0-9)
    ##  add dash(-) plus parens () too!!  for (-1999) or (1999-2011) or such
    ##  add umlauts too for now - plus add more later!!!
    ##
    ## fix- add more (all) diacritics!!!
    ##  GÍ Gøta (1926-2008)
    ##  FC Suðuroy
    ## fix - remove dash(-) if not followed or preceded by year (four digits)!!!
    ##
    ##  use new (autogen)key rule
    ##   - 1st unaccent, 2nd downcase, 3rd remove space et al
    ##   use keygen or autokey function or such - why? why not?

    ##  note: ALWAYS auto-add city to key  to make unique!!!!!
    ##          e.g. Red Bull Arena,  Allianz Arena etc.

     @key ||=  begin 
                  fst = unaccent( @name ).downcase.gsub( /[^a-z0-9()-]/, '' )
                  snd = unaccent( city ).downcase.gsub( /[^a-z0-9]/, '' )
                  trd = country.key
                  ## use / as separator (or @ or ??) - why? why not?
                  fst + '_' + snd + '_' + trd
               end
     @key
  end


  ##  todo/check
  ##  check event_ifno  - for start_date, end_date ??
  ##           use same naming convention here too (start_year/end_year)
  def historic?()  @year_end ? true : false; end
  alias_method  :past?, :historic?


  def initialize( **kwargs )
    @alt_names      = []
  
    update( **kwargs )  unless kwargs.empty?
  end

  def update( **kwargs )
    @key         = kwargs[:key]        if kwargs.has_key?( :key )
    @name        = kwargs[:name]       if kwargs.has_key?( :name )
    @alt_names   = kwargs[:alt_names]  if kwargs.has_key?( :alt_names )

    @city        = kwargs[:city]       if kwargs.has_key?( :city )
    ## todo/fix:  use city struct - why? why not?
    ## todo/fix: add country too  or report unused keywords / attributes - why? why not?

    self   ## note - MUST return self for chaining
  end 
end   # class Ground
end   # module Sports
