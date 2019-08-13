# encoding: utf-8

class Alphabet   ## todo/fix: add alias Abc  and Alpha too? why? why not?
  def self.frequency_table( name )   ## todo/check: use/rename to char_frequency_table
    ## calculate the frequency table of letters, digits, etc.
    freq = Hash.new(0)
    name.each_char do |ch|
       freq[ch] += 1
    end
    freq
  end


  def self.count( freq, mapping_or_chars )
    chars = if mapping_or_chars.is_a?( Hash )
              mapping_or_chars.keys
            else   ## todo/fix: check for is_a? Array and if is String split into Array (on char at a time?) - why? why not?
              mapping_or_chars  ## assume it's an array/list of characters
            end

    chars.reduce(0) do |count,ch|
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


  class Unaccenter #Worker    ## todo/change - find a better name - why? why not?
    def initialize( mapping )
      @mapping = mapping
    end

    def count( name )      Alphabet.count( name, @mapping ); end
    def unaccent( name )   Alphabet.tr( name, @mapping );    end
  end  # class Unaccent Worker


  def self.find_unaccenter( key )
    if key == :de
      @de ||= Unaccenter.new( UNACCENT_DE )
      @de
    else
      ## use uni(versal) or unicode or something - why? why not?
      ##  use all or int'l (international) - why? why not?
      ##  use en  (english) - why? why not?
      @default ||= Unaccenter.new( UNACCENT )
      @default
    end
  end

  def self.unaccent( name )
    @default ||= Unaccenter.new( UNACCENT )
    @default.unaccent( name )
  end


  def self.downcase_i18n( name )    ## our very own downcase for int'l characters / letters
    tr( name, DOWNCASE )
  end
  ## add downcase_uni  - univeral/unicode - why? why not?


  ##  "simple" unaccent (remove accents/diacritics and unfold ligatures) translation table / mapping
  UNACCENT = {
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
               'þ'=>'th',   #### fix!!!! use p - why? why not?

    'Ü'=>'U',  'ü'=>'u',
    'Ú'=>'U',  'ú'=>'u',
               'ū'=>'u',

               'ý'=>'y',

               'ź'=>'z',
               'ż'=>'z',
    'Ž'=>'Z',  'ž'=>'z',
  }


  ##  de,at,ch translation for umlauts
  UNACCENT_DE = {
    'Ä'=>'Ae',  'ä'=>'ae',  ### Use AE, OE, UE and NOT Ae, Oe, Ue - why? why not? e.g.VÖST => VOEST or Ö => OE
    'Ö'=>'Oe',  'ö'=>'oe',
    'Ü'=>'Ue',  'ü'=>'ue',
                'ß'=>'ss',
  }

  ## add UNACCENT_ES - why? why not?  is Espanyol catalan spelling or spanish (castillian)?
  # 'ñ'=>'ny',    ## e.g. Español => Espanyol

  DOWNCASE = %w[A B C D E F G H I J K L M N O P Q R S T U V W X Y Z].reduce({}) do |h,ch|
    h[ch] = ch.downcase
    h
  end.merge(
    'Ä'=>'ä',
    'Á'=>'á',
    'Å'=>'å',

    'Ç'=>'ç',
    'Č'=>'č',

    'É'=>'é',

    'İ'=>'?',   ## fix - add lowercase
    'Í'=>'í',

    'Ł'=>'ł',

    'Ö'=>'ö',

    'Ś'=>'?',   ## fix - add lowercase
    'Ş'=>'ş',
    'Š'=>'š',

    'Ü'=>'ü',
    'Ú'=>'ú',

    'Ž'=>'ž',
  )

end  # class Alphabet
