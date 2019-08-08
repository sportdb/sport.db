# encoding: utf-8

module SportDb
  module Import

##
#  note: use our own (internal) club struct for now - why? why not?
#    - check that shape/structure/fields/attributes match
#      the Team struct in sportdb-text (in SportDb::Struct::Team)  !!!!
class Club
  ##  todo: use just names for alt_names - why? why not?
  attr_accessor :name, :alt_names,
                :year, :ground, :city

  ## more attribs - todo/fix - also add "upstream" to struct & model!!!!!
  attr_accessor :district, :geos, :year_end, :country

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

   YEAR_REGEX = /\([0-9,\- ]+?\)/
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


  NORM_REGEX =  /[.'º\-\/]/
  ## note: remove all dots (.), dash (-), ', º, /, etc.
  ##         for norm(alizing) names
  def self.strip_norm( name )
    name.gsub( NORM_REGEX, '' )
  end

  def self.normalize( name )
    # note: do NOT call sanitize here (keep normalize "atomic" for reuse)

    ## remove all dots (.), dash (-), º, /, etc.
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
