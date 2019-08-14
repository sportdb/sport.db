
class Alphabet

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


  def self.sub( name, mapping )   ## todo/check: use a different/better name - gsub/map/replace/fold/... - why? why not?
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

    def count( freq )      Alphabet.count( freq, @mapping ); end
    def unaccent( name )   Alphabet.sub( name, @mapping );   end
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
    sub( name, DOWNCASE )
  end
  ## add downcase_uni  - univeral/unicode - why? why not?

end  # class Alphabet
