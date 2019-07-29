
require 'pp'

## 1) create variants for dots
## 2) create variants for umlauts  (two versions)
## 3)  combine 1+2 if both present


def frequency_table( name )   ## todo/check: use/rename to char_frequency_table
  ## calculate the frequency table of letters, digits, etc.
  freq = Hash.new(0)
  ## note: do NOT process (skip) substring enclosed in [] e.g. [1.] FC Köln
  process = true
  name.each_char do |ch|
     if ch == '['   ## turn off processing
       process = false; next
     end
     if ch == ']'   ## turn (back) on processing
       process = true; next
     end
     freq[ch] += 1    if process
  end
  freq
end


ALPHA_SPECIALS = %w[
  ä ö ü ß
  Ä Ö Ü
]

##  "simple" translation
SUB_ALPHA_SPECIALS1 = {
  'ö'=>'o',
  'ü'=>'u',
  'ß'=>'ss',
}

##  de,at,ch translation for umlauts
SUB_ALPHA_SPECIALS2 = {
  'ö'=>'oe',
  'ü'=>'ue',
  'ß'=>'ss',
}

SUB_DOTS = {
  '.'=>''
}


def alpha_specials_count( freq )
  ALPHA_SPECIALS.reduce(0) do |count,ch|
    count += freq[ch]
    count
  end
end

def tr( name, *mappings )
  buf = String.new
  process = true
  name.each_char do |ch|
    if ch == '['   ## turn off processing
      process = false;  next
    end
    if ch == ']'   ## turn (back) on processing
      process = true; next
    end

    if process
       buf << mappings.reduce(ch) do |ch,mapping|
          if ch.size == 0   ## empty string  (char got deleted)
            ch
          elsif ch.size == 1   ## char
            if mapping[ch]
              mapping[ch]
            else
              ch
            end
          else  ## assume size > 1
            puts "** !!! ERROR !!! - sorry can't process more than one char for now:"
            pp ch
            exit 1
          end
       end
    else
      buf << ch
    end
  end
  buf
end


def protect_name( name )
  ## use [] to "protect" substring from processing
  ##  e.g. 1. FC Köln  => [1.] FC Köln
  name = name.sub( /^(1\.)/, "[\\1]" )
  name
end



def variants( name )
  alt_names = []

  name = protect_name( name )
  freq = frequency_table( name )

  has_dots           = freq['.'] > 0     # check if includes dots (.)
  has_alpha_specials = alpha_specials_count( freq )

  if has_dots
    alt_names <<  tr( name, SUB_DOTS )
  end

  if has_alpha_specials
    alt_names <<  tr( name, SUB_ALPHA_SPECIALS1 )
    alt_names <<  tr( name, SUB_ALPHA_SPECIALS2 )
  end

  if has_dots && has_alpha_specials
    alt_names <<  tr( name, SUB_DOTS, SUB_ALPHA_SPECIALS1 )
    alt_names <<  tr( name, SUB_DOTS, SUB_ALPHA_SPECIALS2 )
  end

  ## todo - make uniq  e.g. Preußen is Preussen, Preussen 2x
  alt_names = alt_names.uniq
  alt_names
end



name1 = '1. FC Köln'
name2 = 'St. Pölten'
name3 = 'Bayern München'
name4 = 'F. Düsseldorf'
name5 = 'Preußen'
name6 = 'Münster Preußen'
name7 = 'Rot-Weiß Oberhausen'

freq = frequency_table( protect_name(name1) )
pp freq
pp alpha_specials_count( freq )
pp variants( name1 )

freq = frequency_table( name2 )
pp freq
pp alpha_specials_count( freq )
pp variants( name2 )

freq = frequency_table( name3 )
pp freq
pp alpha_specials_count( freq )
pp variants( name3 )

freq = frequency_table( name4 )
pp freq
pp alpha_specials_count( freq )
pp variants( name4 )
pp variants( name5 )
pp variants( name6 )
pp variants( name7 )
