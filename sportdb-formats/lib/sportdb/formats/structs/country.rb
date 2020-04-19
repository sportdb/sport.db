# encoding: utf-8

module SportDb
  module Import

##
#  note: check that shape/structure/fields/attributes match
#            the ActiveRecord model !!!!

class Country

  ## note: is read-only/immutable for now - why? why not?
  ##          add cities (array/list) - why? why not?
  attr_reader :key, :name, :fifa, :tags
  attr_accessor :alt_names

  def initialize( key:, name:, fifa:, tags: [] )
    @key, @name, @fifa = key, name, fifa
    @alt_names      = []
    @tags           = tags
  end

  ## add csv-like access by hash key for compatibility - why? why not? - check where used? remove!!!
  def []( key ) send( key ); end


  ###################################
  # "global" helper - move to ___ ? why? why not?
  ##   todo/fix: use shared helpers for country, club, etc. (do NOT duplicate)!!!
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
end  # class Country


end   # module Import
end   # module SportDb

