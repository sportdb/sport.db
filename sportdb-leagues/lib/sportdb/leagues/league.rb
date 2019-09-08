# encoding: utf-8

module SportDb
  module Import

class League
  attr_reader   :key, :name, :country, :intl
  attr_accessor :alt_names

  def initialize( key:, name:, alt_names: [], country: nil, intl: false )
    @key       = key
    @name      = name
    @alt_names = alt_names
    @country   = country
    @intl      = intl
  end
  def intl?()      @intl == true; end
  def national?()  @intl == false; end



  ## todo/fix: (re)use helpers from clubs - how? why? why not?
  LANG_REGEX = /\[[a-z]{1,2}\]/   ## note also allow [a] or [d] or [e] - why? why not?
  def self.strip_lang( name )
    name.gsub( LANG_REGEX, '' ).strip
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
end   # class League

end   # module Import
end   # module SportDb
