# encoding: utf-8


class Variant    ## (spelling) variant finder / builder for names

  EN_UNACCENTER = Alphabet.find_unaccenter( :en ) ## assume english (en) as default for know - change to universal/int'l/default or something - why? why not?
  DE_UNACCENTER = Alphabet.find_unaccenter( :de )

def self.find( name )
  alt_names = []

  freq = Alphabet.frequency_table( name )

  en = EN_UNACCENTER
  if en.count( freq ) > 0    # check if includes äöü (that is, character with accents or diacritics) etc.
    alt_names <<  en.unaccent( name )
  end

  de = DE_UNACCENTER
  if de.count( freq ) > 0
    alt_names <<  de.unaccent( name )
  end

  ## todo - make uniq  e.g. Preußen is Preussen, Preussen 2x
  alt_names = alt_names.uniq
  alt_names
end

end  # class Variant



######################################
#  expiremental class - use (just) Name or NameQ or NameVariant or NameAnalyzer/Query or similar - why? why not?
##   let's wait for now with usage - let's add more methods as we go along and find more - why? why not?
class NameQuery
  def initialize( name )
    @name = name
  end

  def frequency_table
    @freq ||= Alphabet.frequency_table( @name )
  end

  def variants
    @variants ||= find_variants
  end

private
  EN_UNACCENTER = Alphabet.find_unaccenter( :en ) ## assume english (en) as default for know - change to universal/int'l/default or something - why? why not?
  DE_UNACCENTER = Alphabet.find_unaccenter( :de )

  def find_variants
    alt_names = []

    freq = frequency_table

    en = EN_UNACCENTER
    if en.count( freq ) > 0    # check if includes äöü (that is, character with accents or diacritics) etc.
      alt_names <<  en.unaccent( @name )
    end

    de = DE_UNACCENTER
    if de.count( freq ) > 0
      alt_names <<  de.unaccent( @name )
    end

    ## todo - make uniq  e.g. Preußen is Preussen, Preussen 2x
    alt_names = alt_names.uniq
    alt_names
  end
end  ## class VariantName
