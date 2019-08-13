# frozen_string_literal: true

require 'pp'
require 'benchmark'


UNACCENT = {
  'Ä'=>'A',  'ä'=>'a',
  'Á'=>'A',  'á'=>'a',
  'É'=>'E',  'é'=>'e',
  'Í'=>'I',  'í'=>'i',
             'ï'=>'i',
  'Ñ'=>'N',  'ñ'=>'n',
  'Ö'=>'O',  'ö'=>'o',
  'Ó'=>'O',  'ó'=>'o',
             'ß'=>'ss',
  'Ü'=>'U',  'ü'=>'u',
  'Ú'=>'U',  'ú'=>'u',
}

UNACCENT_DE = {
  'Ä'=>'AE',  'ä'=>'ae',
  'Ö'=>'OE',  'ö'=>'oe',
  'Ü'=>'UE',  'ü'=>'ue',
}


def unaccent_each_char( text, mapping )
  buf = String.new
  text.each_char do |ch|
    buf << if mapping[ch]
                mapping[ch]
            else
                ch
            end
  end
  buf
end

def unaccent_each_char_v2( text, mapping )
  buf = String.new
  text.each_char do |ch|
    buf << (mapping[ch] || ch)
  end
  buf
end


def unaccent_each_char_reduce( text, mapping )
  text.each_char.reduce( String.new ) do |buf,ch|
    buf <<  if mapping[ch]
                mapping[ch]
            else
                ch
            end
    buf
  end
end


def unaccent_each_char_reduce_v2( text, mapping )
  text.each_char.reduce( String.new ) do |buf,ch|
    buf << (mapping[ch] || ch)
    buf
  end
end



ANY_CHAR_REGEX = /./  ## use/try constant for spped-up
def unaccent_scan( text, mapping )
  buf = String.new
  text.scan( ANY_CHAR_REGEX ) do |ch|
    buf << if mapping[ch]
                mapping[ch]
            else
                ch
            end
  end
  buf
end

NON_ALPHA_CHAR_REGEX = /[^A-Za-z0-9 ]/    ## use/try constant for speed-up
def unaccent_gsub( text, mapping )
  ## todo/fix: use all ascii (basic latin) chars below 0x7F - why? why not?
  text.gsub( NON_ALPHA_CHAR_REGEX ) do |ch|
    if mapping[ch]
      mapping[ch]
    else
      ch
    end
  end
end

def unaccent_gsub_v2( text, mapping )
  text.gsub( NON_ALPHA_CHAR_REGEX ) do |ch|
    mapping[ch] || ch
  end
end



def benchmark( str, mapping, n: 20_000 )
  puts "text=>#{str}<, n=#{n}:"
  Benchmark.bm do |benchmark|
    benchmark.report( 'each_char' ) do
      n.times { unaccent_each_char( str, mapping ) }
    end

    benchmark.report( 'each_char_v2' ) do
      n.times { unaccent_each_char_v2( str, mapping ) }
    end

    benchmark.report( 'each_char_reduce' ) do
      n.times { unaccent_each_char_reduce( str, mapping ) }
    end

    benchmark.report( 'each_char_reduce_v2' ) do
      n.times { unaccent_each_char_reduce_v2( str, mapping ) }
    end

    benchmark.report( 'gsub' ) do
      n.times { unaccent_gsub( str, mapping ) }
    end

    benchmark.report( 'gsub_v2' ) do
      n.times { unaccent_gsub_v2( str, mapping ) }
    end

    benchmark.report( 'scan' ) do
      n.times { unaccent_scan( str, mapping ) }
    end
  end
end



factor = 5
str1 = 'AÄÁaäá EÉeé IÍiíï NÑnñ OÖÓoöó Ssß UÜÚuüú' * factor
str2 = 'Aa Ee Ii Oo Uu' * factor   ## no accents / diacritic marks
str3 = 'jazmín vïuda pingüino cuestión náutico esdrújula'



benchmark( str1, UNACCENT )
benchmark( str1, UNACCENT_DE )
puts "------------"
benchmark( str2, UNACCENT )
benchmark( str2, UNACCENT_DE )



pp unaccent_each_char( str1, UNACCENT )
pp unaccent_each_char( str1, UNACCENT_DE )

pp unaccent_each_char_v2( str1, UNACCENT )
pp unaccent_each_char_v2( str1, UNACCENT_DE )

pp unaccent_each_char_reduce( str1, UNACCENT )
pp unaccent_each_char_reduce( str1, UNACCENT_DE )

pp unaccent_each_char_reduce_v2( str1, UNACCENT )
pp unaccent_each_char_reduce_v2( str1, UNACCENT_DE )

pp unaccent_gsub( str1, UNACCENT )
pp unaccent_gsub( str1, UNACCENT_DE )

pp unaccent_gsub_v2( str1, UNACCENT )
pp unaccent_gsub_v2( str1, UNACCENT_DE )

pp unaccent_scan( str1, UNACCENT )
pp unaccent_scan( str1, UNACCENT_DE )

