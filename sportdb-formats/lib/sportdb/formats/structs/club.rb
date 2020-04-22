# encoding: utf-8

module SportDb
  module Import


##
##  todo/fix:  remove self.create in structs!!!  use just new!!!




########
# more attribs - todo/fix - also add "upstream" to struct & model!!!!!
#   district, geos, year_end, country, etc.

class Club


  ##  todo: use just names for alt_names - why? why not?
  attr_accessor :key, :name, :alt_names,
                :code,    ## code == abbreviation e.g. ARS etc.
                :year, :year_end,   ## todo/fix: change year_end to end_year (like in season)!!!
                :ground


  alias_method :title, :name  ## add alias/compat - why? why not

  def names
    ## todo/check: add alt_names_auto too? - why? why not?
    [@name] + @alt_names
  end   ## all names


  ## special import only attribs
  attr_accessor :alt_names_auto    ## auto-generated alt names
  attr_accessor :wikipedia   # wikipedia page name (for english (en))


  def historic?()  @year_end ? true : false; end
  alias_method  :past?, :historic?


  attr_accessor :a, :b
  def a?()  @a == nil; end  ## is a (1st) team / club (i)?            if a is NOT set
  def b?()  @a != nil; end  ## is b (2nd/reserve/jr) team / club (ii) if a is     set

  ## note: delegate/forward all geo attributes for team b for now (to team a) - keep - why? why not?
  attr_writer  :city, :district, :country, :geos
  def city()      @a == nil ?  @city     : @a.city;     end
  def district()  @a == nil ?  @district : @a.district; end
  def country()   @a == nil ?  @country  : @a.country;  end
  def geos()      @a == nil ?  @geos     : @a.geos;     end


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

    update( kwargs )  unless kwargs.empty?
  end

  def update( **kwargs )
    @name        = kwargs[:name]       if kwargs.has_key? :name
    @alt_names   = kwargs[:alt_names]  if kwargs.has_key? :alt_names
    @city        = kwargs[:city]       if kwargs.has_key? :city
    ## todo/fix:  use city struct - why? why not?
    ## todo/fix: add country too  or report unused keywords / attributes - why? why not?

    self   ## note - MUST return self for chaining
  end


  ## helper methods for import only
  ## check for duplicates
  include NameHelper

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
end # class Club



############
#  convenience
#   Club and Team are for now alias
#     in the future make
#        Club > Team
#        NationalTeam > Team  - why? why not?
Team = Club


end   # module Import
end   # module SportDb
