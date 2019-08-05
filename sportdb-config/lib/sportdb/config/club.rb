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
    names = names.map { |name| normalize( name ) }

    names.size != names.uniq.size
  end

  def duplicates
    names = [name] + alt_names + alt_names_auto

    ## calculate (count) frequency and select if greater than one
    names.reduce( Hash.new ) do |h,name|
       norm = normalize( name )
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

   LANG_REGEX = /\[[a-z]{2}\]/
   def self.strip_lang( name )
     name.gsub( LANG_REGEX, '' ).strip
   end

   def self.has_lang?( name ) name =~ LANG_REGEX; end

   NORM_REGEX =  /[.'º\-\/]/
   ## note: remove all dots (.), dash (-), ', º, /, etc.
   ##         for norm(alizing) names
   def self.strip_norm( name )
     name.gsub( NORM_REGEX, '' )
   end

   def strip_year( name ) self.class.strip_year( name ); end
   def strip_lang( name ) self.class.strip_lang( name ); end
   def strip_norm( name ) self.class.strip_norm( name ); end

private
  def sanitize( name )
    ## check for year(s) e.g. (1887-1911), (-2013),
    ##                        (1946-2001,2013-) etc.
    name = strip_year( name )
    ## check lang codes e.g. [en], [fr], etc.
    name = strip_lang( name )
    name
  end

  def normalize( name )
    name = sanitize( name )

    ## remove all dots (.), dash (-), º, /, etc.
    name = strip_norm( name )
    name = name.gsub( ' ', '' )  # note: also remove all spaces!!!

    ## todo/fix: use our own downcase - why? why not?
    name = name.downcase     ## do NOT care about upper and lowercase for now
    name
  end

  def variants( name )  Variant.find( name ); end
end # class Club

end   # module Import
end   # module SportDb
