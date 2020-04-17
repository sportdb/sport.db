# encoding: utf-8

module SportDb
  module Import

##
#  note: use our own (internal) club struct for now - why? why not?
#    - check that shape/structure/fields/attributes match
#      the Team struct in sportdb-text (in SportDb::Struct::Team)  !!!!


## more attribs - todo/fix - also add "upstream" to struct & model!!!!!
#   district, geos, year_end, country, etc.

class Club
  ##  todo: use just names for alt_names - why? why not?
  attr_accessor :key, :name, :alt_names,
                :code,    ## code == abbreviation e.g. ARS etc.
                :year, :year_end,
                :ground

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


  def initialize
    @alt_names      = []
    @alt_names_auto = []
  end


  ## helper methods for import only
  ## check for duplicates
  def duplicates?
    names = [name] + alt_names + alt_names_auto
    names = names.map { |name| normalize( sanitize(name) ) }

    names.size != names.uniq.size
  end

  def duplicates
    names = [name] + alt_names + alt_names_auto

    ## calculate (count) frequency and select if greater than one
    names.reduce( Hash.new ) do |h,name|
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


   ###################################
   # "global" helper - move to ___ ? why? why not?

   ## note: allow placeholder years to e.g. (-___) or (-????)
   ##    for marking missing (to be filled in) years
   YEAR_REGEX = /\([0-9, ?_-]+?\)/    # note: non-greedy (minimum/first) match
   def self.strip_year( name )
     ## check for year(s) e.g. (1887-1911), (-2013),
     ##                        (1946-2001, 2013-) etc.
     name.gsub( YEAR_REGEX, '' ).strip
   end

   def self.has_year?( name ) name =~ YEAR_REGEX; end

   LANG_REGEX = /\[[a-z]{1,2}\]/   ## note also allow [a] or [d] or [e] - why? why not?
   def self.strip_lang( name )
     name.gsub( LANG_REGEX, '' ).strip
   end

   def self.has_lang?( name ) name =~ LANG_REGEX; end

  def self.sanitize( name )
    ## check for year(s) e.g. (1887-1911), (-2013),
    ##                        (1946-2001,2013-) etc.
    name = strip_year( name )
    ## check lang codes e.g. [en], [fr], etc.
    name = strip_lang( name )
    name
  end


  ## note: also add (),’,−  etc. e.g.
  ##   Estudiantes (LP) => Estudiantes LP
  ##   Saint Patrick’s Athletic FC => Saint Patricks Athletic FC
  ##   Myllykosken Pallo −47 => Myllykosken Pallo 47

  NORM_REGEX =  %r{
                    [.'’º/()−-]
                  }x   # note: in [] dash (-) if last doesn't need to get escaped
  ## note: remove all dots (.), dash (-), ', º, /, etc.
  #   .  U+002E (46) - FULL STOP
  #   '  U+0027 (39) - APOSTROPHE
  #   ’  U+2019 (8217) - RIGHT SINGLE QUOTATION MARK
  #   º  U+00BA (186) - MASCULINE ORDINAL INDICATOR
  #   /  U+002F (47) - SOLIDUS
  #   (  U+0028 (40) - LEFT PARENTHESIS
  #   )  U+0029 (41) - RIGHT PARENTHESIS
  #   −  U+2212 (8722) - MINUS SIGN
  #   -  U+002D (45) - HYPHEN-MINUS

  ##         for norm(alizing) names
  def self.strip_norm( name )
    name.gsub( NORM_REGEX, '' )
  end

  def self.normalize( name )
    # note: do NOT call sanitize here (keep normalize "atomic" for reuse)
    name = strip_norm( name )
    name = name.gsub( ' ', '' )  # note: also remove all spaces!!!

    ## todo/fix: use our own downcase - why? why not?
    name = downcase_i18n( name )     ## do NOT care about upper and lowercase for now
    name
  end


  def self.strip_wiki( name )     # todo/check: rename to strip_wikipedia_en - why? why not?
    ## note: strip disambiguationn qualifier from wikipedia page name if present
    ##        note: only remove year and foot... for now
    ## e.g. FC Wacker Innsbruck (2002) => FC Wacker Innsbruck
    ##      Willem II (football club)  => Willem II
    ##
    ## e.g. do NOT strip others !! e.g.
    ##   América Futebol Clube (MG)
    ##  only add more "special" cases on demand (that, is) if we find more
    name = name.gsub( /\([12][^\)]+?\)/, '' ).strip  ## starting with a digit 1 or 2 (assuming year)
    name = name.gsub( /\(foot[^\)]+?\)/, '' ).strip  ## starting with foot (assuming football ...)
    name
  end


private
  ## private "shortcut" convenience helpers
  def sanitize( name )    self.class.sanitize( name ); end
  def normalize( name )   self.class.normalize( name ); end

  def variants( name )  Variant.find( name ); end
end # class Club

end   # module Import
end   # module SportDb
