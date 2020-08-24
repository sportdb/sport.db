
module SportDb
  module NameHelper


  ## note: allow placeholder years to e.g. (-___) or (-????)
  ##    for marking missing (to be filled in) years
  ##  e.g. (1887-1911), (-2013),
  ##      (1946-2001, 2013-) etc.
  ##  todo/check: make more strict  e.g. only accept 4-digit years? - why? why not?
  YEAR_RE =  %r{\(
                  [0-9, ?_-]+?     # note: non-greedy (minimum/first) match
              \)}x

  def strip_year( name )
    ## check for year(s) e.g. (1887-1911), (-2013),
    ##                        (1946-2001, 2013-) etc.
    ##  todo/check: only sub once (not global) - why? why not?
    name.gsub( YEAR_RE, '' ).strip
  end

  def has_year?( name ) name =~ YEAR_RE; end


  LANG_RE =  %r{\[
                [a-z]{1,2}    # note also allow single-letter [a] or [d] or [e] - why? why not?
                \]}x
  def strip_lang( name )
     name.gsub( LANG_RE, '' ).strip
  end

  def has_lang?( name ) name =~ LANG_RE; end


  def sanitize( name )
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
  ##
  ##  add & too!!
  ##   e.g. Brighton & Hove Albion => Brighton Hove Albion  -- and others in England

  NORM_RE =  %r{
                    [.'’º/()&_−-]
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
  def strip_norm( name )
    name.gsub( NORM_RE, '' )
  end

  def normalize( name )
    # note: do NOT call sanitize here (keep normalize "atomic" for reuse)
    name = strip_norm( name )
    name = name.gsub( ' ', '' )  # note: also remove all spaces!!!

    ## todo/check: use our own downcase - why? why not?
    name = downcase_i18n( name )     ## do NOT care about upper and lowercase for now
    name
  end


  def variants( name )  Variant.find( name ); end

  end  # module NameHelper
end   # module SportDb

