
module Sports

##
##  todo/fix:  remove self.create in structs!!!  use just new!!!

class Team
  ##  todo: use just names for alt_names - why? why not?
  attr_accessor :key, :name, :alt_names,
                :code,    ## code == abbreviation e.g. ARS etc.
                :year, :year_end,   ## todo/fix: change year to start_year and year_end to end_year (like in season)!!!
                :country


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

     @key || unaccent( @name ).downcase.gsub( /[^a-z0-9()-]/, '' )
  end


  ## special import only attribs
  attr_accessor :alt_names_auto    ## auto-generated alt names
  attr_accessor :wikipedia   # wikipedia page name (for english (en))


  def historic?()  @year_end ? true : false; end
  alias_method  :past?, :historic?

  def wikipedia?()  @wikipedia; end
  def wikipedia_url
    if @wikipedia
      ##  note: replace spaces with underscore (-)
      ##  e.g. Club Brugge KV => Club_Brugge_KV
      ##  todo/check/fix:
      ##    check if "plain" dash (-) needs to get replaced with typographic dash??
      "https://en.wikipedia.org/wiki/#{@wikipedia.gsub(' ','_')}"
    else
      nil
    end
  end


  def initialize( **kwargs )
    @alt_names      = []
    @alt_names_auto = []

    update( **kwargs )  unless kwargs.empty?
  end

  def update( **kwargs )
    @key         = kwargs[:key]        if kwargs.has_key? :key
    @name        = kwargs[:name]       if kwargs.has_key? :name
    @code        = kwargs[:code]       if kwargs.has_key? :code
    @alt_names   = kwargs[:alt_names]  if kwargs.has_key? :alt_names
    self   ## note - MUST return self for chaining
  end



  ##############################
  ## helper methods for import only??
  ## check for duplicates
  include SportDb::NameHelper

  def duplicates?
    names = [name] + alt_names + alt_names_auto
    names = names.map { |name| normalize( sanitize(name) ) }

    names.size != names.uniq.size
  end

  def duplicates
    names = [name] + alt_names + alt_names_auto

    ## calculate (count) frequency and select if greater than one
    names.reduce( {} ) do |h,name|
       norm = normalize( sanitize(name) )
       h[norm] ||= []
       h[norm] << name; h
    end.select { |norm,names| names.size > 1 }
  end


  def add_variants( name_or_names )
    names = name_or_names.is_a?(Array) ? name_or_names : [name_or_names]
    names.each do |name|
      name = sanitize( name )
      self.alt_names_auto += variants( name )
    end
  end
end   # class Team



class NationalTeam < Team
  def initialize( **kwargs )
    super
  end

  def update( **kwargs )
    super
    self   ## note - MUST return self for chaining
  end

end  # class NationalTeam


########
# more attribs - todo/fix - also add "upstream" to struct & model!!!!!
#   district, geos, year_end, country, etc.

class Club < Team
  attr_accessor  :ground

  attr_accessor :a, :b
  def a?()  @a == nil; end  ## is a (1st) team / club (i)?            if a is NOT set
  def b?()  @a != nil; end  ## is b (2nd/reserve/jr) team / club (ii) if a is     set

  ## note: delegate/forward all geo attributes for team b for now (to team a) - keep - why? why not?
  attr_writer  :city, :district, :geos
  def city()      @a == nil ?  @city     : @a.city;     end
  def district()  @a == nil ?  @district : @a.district; end
  def country()   @a == nil ?  @country  : @a.country;  end
  def geos()      @a == nil ?  @geos     : @a.geos;     end


  def initialize( **kwargs )
    super
  end

  def update( **kwargs )
    super
    @city        = kwargs[:city]       if kwargs.has_key? :city
    ## todo/fix:  use city struct - why? why not?
    ## todo/fix: add country too  or report unused keywords / attributes - why? why not?

    self   ## note - MUST return self for chaining
  end
end # class Club

end   # module Sports
