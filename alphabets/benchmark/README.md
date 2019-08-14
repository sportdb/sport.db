# Alphabets Benchmarks


## How many ways to unaccent a text string?

How to turn `AÄÁaäá EÉeé IÍiíï NÑnñ OÖÓoöó Ssß UÜÚuüú`
into `AAAaaa EEee IIiii NNnn OOOooo Ssss UUUuuu`?

Let's say you have German football club names such as:
Bayern München · 1. FC Köln · Preußen Münster.
Or Spanish club names such as:
Atlético Madrid · Málaga CF · Sporting Gijón.

What's the fastest way to remove all accents and diacritic marks
from the char(acter)s?
Let's count the way
and let's turn
`Bayern München` into `Bayern Munchen` or `Bayern Muenchen`.

Let's use a character mapping table:

``` ruby
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
```

And in the first version let's loop with `each_char`
over the string and rebuild the unaccented version:

``` ruby
def unaccent_each_char( text, mapping=UNACCENT )
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
```

Try:

``` ruby
unaccent_each_char( 'Bayern München · 1. FC Köln · Preußen Münster' )
#=> "Bayern Munchen · 1. FC Koln · Preussen Munster"
unaccent_each_char( 'Atlético Madrid · Málaga CF · Sporting Gijón' )
#=> "Atletico Madrid · Malaga CF · Sporting Gijon"
```

Can we make it faster? Let's optimize the duplicated `mapping[ch]` lookup:

``` ruby
def unaccent_each_char_v2( text, mapping=UNACCENT )
  buf = String.new
  text.each_char do |ch|
    buf << (mapping[ch] || ch)
  end
  buf
end
```

Are you more of a functional type? Let's try `reduce`:

``` ruby
def unaccent_each_char_reduce( text, mapping=UNACCENT )
  text.each_char.reduce( String.new ) do |buf,ch|
    buf <<  if mapping[ch]
                mapping[ch]
            else
                ch
            end
    buf
  end
end

# -or-

def unaccent_each_char_reduce_v2( text, mapping=UNACCENT )
  text.each_char.reduce( String.new ) { |buf,ch| buf << (mapping[ch] || ch); buf }
end
```


Or better let's try `map` (and `join`):

``` ruby
def unaccent_chars_map_join( text, mapping=UNACCENT )
  text.chars.map { |ch| mapping[ch] || ch }.join
end
```


Maybe using a regular expression with `gsub` is faster? Let's try:

``` ruby
NON_ALPHA_CHAR_REGEX = /[^A-Za-z0-9 ]/    # use/try regex constant for speed-up
def unaccent_gsub( text, mapping=UNACCENT )
  text.gsub( NON_ALPHA_CHAR_REGEX ) do |ch|
    if mapping[ch]
      mapping[ch]
    else
      ch
    end
  end
end
```

Or is `scan` faster? Let's try:

``` ruby
ANY_CHAR_REGEX = /./      # use/try regex constant for speed-up
def unaccent_scan( text, mapping=UNACCENT )
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
```

Ok. And the winner is...  Let's benchmark with two use cases.
The first test has many accent and diacritic marks e.g. `AÄÁaäá EÉeé IÍiíï...`
and the second has none e.g. `Aa Ee Ii Oo Uu...`.
Run the [`benchmark/unaccent.rb`](unaccent.rb) script.
Resulting in:


```
text=>AÄÁaäá EÉeé IÍiíï...<, n=20000:
                               user     system      total        real
each_char                  4.953000   0.000000   4.953000 (  4.958531)
each_char_v2               4.265000   0.000000   4.265000 (  4.265561)
each_char_reduce           5.641000   0.000000   5.641000 (  5.638152)
each_char_reduce_v2        5.125000   0.000000   5.125000 (  5.113069)
gsub                       6.078000   0.000000   6.078000 (  6.079772)
gsub_v2                    5.500000   0.000000   5.500000 (  5.492944)
scan                      10.062000   0.000000  10.062000 ( 10.050102)

text=>Aa Ee Ii...<, n=20000:
                               user     system      total        real
each_char                  1.313000   0.000000   1.313000 (  1.304258)
each_char_v2               1.328000   0.000000   1.328000 (  1.327656)
each_char_reduce           1.594000   0.000000   1.594000 (  1.583752)
each_char_reduce_v2        1.641000   0.000000   1.641000 (  1.650390)
gsub                       0.140000   0.000000   0.140000 (  0.127486)
gsub_v2                    0.125000   0.000000   0.125000 (  0.127581)
scan                       3.141000   0.000000   3.141000 (  3.129562)
```

Voila. And the winner is...  

Hold on. Rob Biedenharn writes in with one more optimization.
Did you know? `gsub` can take a hash mapping as its second argument
resulting in v3:

``` ruby
def unaccent_gsub_v3a( text, mapping=UNACCENT )
  text.gsub( NON_ALPHA_CHAR_REGEX, mapping )
end
```

Hold on. Samuel Williams writes in with one more optimization.
Why not replace the `NON_ALPHA_CHAR_REGEX`, that is, `/[^A-Za-z0-9 ]/`
with a regex matching only known accented chars?

``` ruby
UNACCENT_REGEX = Regexp.union( UNACCENT.keys )
def unaccent_gsub_v3b( text, mapping=UNACCENT, regex=UNACCENT_REGEX )
  text.gsub( regex, mapping)
end
```


Hold on. Let's add some more optimizations to the humble `each_char` version too.
For all 7-bit (less than 0x7F) unicode latin basic (also known as ascii)
char(acter)s no mapping (ever) needed. Let's try:

``` ruby
def unaccent_each_char_v2_7bit( text, mapping )
  buf = String.new
  text.each_char do |ch|
    buf <<   if ch.ord < 0x7F
               ch
             else
               mapping[ch] || ch
             end
  end
  buf
end
```

Maybe the mapping lookup using an array index by an integer number
is faster than hash mapping lookup by single-character string?
Let's try:

``` ruby
UNACCENT_FASTER = UNACCENT.reduce( [] ) do |ary,(ch,value)|
  ary[ ch.ord ] = value
  ary
end

def unaccent_each_char_v2_7bit_faster( text, mapping_faster=UNACCENT_FASTER )
  buf = String.new
  text.each_char do |ch|
    buf <<  if ch.ord < 0x7F   
               ch
            else
               mapping_faster[ ch.ord ] || ch
            end
  end
  buf
end
```

Voila. And the winner is...  

```
text=>AÄÁaäá EÉeé IÍiíï...<, n=20000:
                               user     system      total        real
each_char                  4.953000   0.000000   4.953000 (  4.958531)
each_char_v2               4.265000   0.000000   4.265000 (  4.265561)
each_char_v2_7bit          4.266000   0.000000   4.266000 (  4.268788)
each_char_v2_7bit_faster   3.375000   0.000000   3.375000 (  3.379573)
each_char_reduce           5.641000   0.000000   5.641000 (  5.638152)
each_char_reduce_v2        5.125000   0.000000   5.125000 (  5.113069)
gsub                       6.078000   0.000000   6.078000 (  6.079772)
gsub_v2                    5.500000   0.000000   5.500000 (  5.492944)
gsub_v3a                   4.203000   0.000000   4.203000 (  4.248036)
gsub_v3b                   5.094000   0.000000   5.094000 (  5.098041)
scan                      10.062000   0.000000  10.062000 ( 10.050102)

text=>Aa Ee Ii...<, n=20000:
                               user     system      total        real
each_char                  1.313000   0.000000   1.313000 (  1.304258)
each_char_v2               1.328000   0.000000   1.328000 (  1.327656)
each_char_v2_7bit          0.984000   0.000000   0.984000 (  0.981193)
each_char_v2_7bit_faster   0.984000   0.000000   0.984000 (  0.977593)
each_char_reduce           1.594000   0.000000   1.594000 (  1.583752)
each_char_reduce_v2        1.641000   0.000000   1.641000 (  1.650390)
gsub                       0.140000   0.000000   0.140000 (  0.127486)
gsub_v2                    0.125000   0.000000   0.125000 (  0.127581)
gsub_v3a                   0.125000   0.000000   0.125000 (  0.124071)
gsub_v3b                   0.047000   0.000000   0.047000 (  0.056792)
scan                       3.141000   0.000000   3.141000 (  3.129562)
```

Can you find a faster way? Show us.


---

Notes:

Frank J. Cameron writes in if you have only single-character mappings (e.g. no `æ=>ae`, `ß=>ss` etc.) than `String#tr`
is the winner and unmatched speed king (or queen):

``` ruby
TR_KEYS = UNACCENT.keys.join
TR_VALS = UNACCENT.values.join
def unaccent_tr( text )
   text.tr( TR_KEYS, TR_VALS )
end
```

Going native? Use C-code all the way down and try the wrapper for the UNIX `iconv()` function family translating strings between various encodings:

``` ruby
require 'iconv'
def unaccent_iconv( text )
   Iconv.iconv( 'ascii//translit//ignore', 'utf-8', text )
end
```
