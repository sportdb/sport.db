# encoding: utf-8

module SportDb
  module Import



class Variant    ## (spelling) variant finder / builder for names


def self.frequency_table( name )   ## todo/check: use/rename to char_frequency_table
  ## calculate the frequency table of letters, digits, etc.
  freq = Hash.new(0)
  name.each_char do |ch|
     freq[ch] += 1
  end
  freq
end

ALPHA_SPECIALS = %w[
  Ä Ö Ü
  ä ö ü ß
]

##  "simple" translation
SUB_ALPHA_SPECIALS = {
  'Ä'=>'A',  'ä'=>'a',
  'Ö'=>'O',  'ö'=>'o',
  'Ü'=>'U',  'ü'=>'u',
             'ß'=>'ss',
}

##  de,at,ch translation for umlauts
SUB_ALPHA_SPECIALS_DE = {
  'Ä'=>'Ae',  'ä'=>'ae',
  'Ö'=>'Oe',  'ö'=>'oe',
  'Ü'=>'Ue',  'ü'=>'ue',
              'ß'=>'ss',
}


def self.alpha_specials_count( freq )
  ALPHA_SPECIALS.reduce(0) do |count,ch|
    count += freq[ch]
    count
  end
end

def self.tr( name, mapping )
  buf = String.new
  name.each_char do |ch|
    buf << if mapping[ch]
              mapping[ch]
            else
              ch
            end
  end
  buf
end



def self.find( name )
  alt_names = []

  freq = frequency_table( name )

  if alpha_specials_count( freq ) > 0    # check if includes äöü etc.
    alt_names <<  tr( name, SUB_ALPHA_SPECIALS )
    alt_names <<  tr( name, SUB_ALPHA_SPECIALS_DE )
  end

  ## todo - make uniq  e.g. Preußen is Preussen, Preussen 2x
  alt_names = alt_names.uniq
  alt_names
end
end   # Variant


end ## module Import
end ## module SportDb
