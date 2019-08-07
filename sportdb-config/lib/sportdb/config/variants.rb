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


##  "simple" translation
ALPHA_SPECIALS = {
  'Ä'=>'A',  'ä'=>'a',
  'Á'=>'A',  'á'=>'a',
             'à'=>'a',
             'ã'=>'a',
             'â'=>'a',
  'Å'=>'A',  'å'=>'a',
             'æ'=>'ae',
             'ā'=>'a',
             'ă'=>'a',
             'ą'=>'a',
             
  'Ç' =>'C', 'ç'=>'c',
             'ć'=>'c',
  'Č'=>'C',  'č'=>'c',
  
  'É'=>'E',  'é'=>'e',
             'è'=>'e',
             'ê'=>'e',
             'ë'=>'e',
             'ė'=>'e',
             'ę'=>'e',

             'ğ'=>'g',
              
  'İ'=>'I',
  'Í'=>'I',  'í'=>'i',
             'î'=>'i',
             'ī'=>'i',
             'ı'=>'i',

  'Ł'=>'L', 'ł'=>'l',
             
             'ñ'=>'n',
             'ń'=>'n',
             'ň'=>'n',
             
  'Ö'=>'O',  'ö'=>'o',
             'ó'=>'o',
             'õ'=>'o',
             'ô'=>'o',
             'ø'=>'o',
             'ő'=>'o',

              'ř'=>'r',
        
  'Ś'=>'S',
  'Ş'=>'S',  'ş'=>'s',
  'Š'=>'S',  'š'=>'s',
             'ș'=>'s',  ## U+0219
             'ß'=>'ss',

             'ţ'=>'t',  ## U+0163
             'ț'=>'t',  ## U+021B
             'þ'=>'th',

  'Ü'=>'U',  'ü'=>'u',
  'Ú'=>'U',  'ú'=>'u',
             'ū'=>'u',
             
             'ý'=>'y',

             'ź'=>'z',
             'ż'=>'z',
  'Ž'=>'Z',  'ž'=>'z',
}


##  de,at,ch translation for umlauts
ALPHA_SPECIALS_DE = {
  'Ä'=>'Ae',  'ä'=>'ae',
  'Ö'=>'Oe',  'ö'=>'oe',
  'Ü'=>'Ue',  'ü'=>'ue',
              'ß'=>'ss',
}

## add ALPHA_SPECIALS_ES - why? why not?  is Espanyol catalan spelling or spanish (castillian)?
# 'ñ'=>'ny',    ## e.g. Español => Espanyol



def self.alpha_specials_count( freq, mapping )
  mapping.keys.reduce(0) do |count,ch|
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

  if alpha_specials_count( freq, ALPHA_SPECIALS  ) > 0    # check if includes äöü etc.
    alt_names <<  tr( name, ALPHA_SPECIALS )
  end

  if alpha_specials_count( freq, ALPHA_SPECIALS_DE  ) > 0   ## todo/fix: add / pass-in language/country code and check - why? why not?
    alt_names <<  tr( name, ALPHA_SPECIALS_DE )
  end

  ## todo - make uniq  e.g. Preußen is Preussen, Preussen 2x
  alt_names = alt_names.uniq
  alt_names
end
end   # Variant


end ## module Import
end ## module SportDb
