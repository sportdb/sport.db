# Alphabets Benchmarks


## How many ways to unaccent a text string?

How to turn `AÄÁÆaäáæ EÉeé IÍiíï NÑnñ OÖÓŒoöóœ Ssß UÜÚuüú`
into `AAAAEaaaae EEee IIiii NNnn OOOOEooooe Ssss UUUuuu`?

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
  'Æ'=>'AE', 'æ'=>'ae',
  'É'=>'E',  'é'=>'e',
  'Í'=>'I',  'í'=>'i',
             'ï'=>'i',
  'Ñ'=>'N',  'ñ'=>'n',
  'Ö'=>'O',  'ö'=>'o',
  'Ó'=>'O',  'ó'=>'o',
  'Œ'=>'OE', 'œ'=>'oe', 
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
  text.gsub( regex, mapping )
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

Hold on. Starting with Ruby 2.4 the `String#new` method adds a new capacity parameter:

> The optional size argument specifies the size of internal buffer. 
> This may improve performance, when the string will be concatenated many times (and call many realloc).

Let's try starting with a String buffer the size of the passed-in text plus a buffer of four.


``` ruby
def unaccent_each_char_v2_7bit_faster_cap( text, mapping_faster=UNACCENT_FASTER )
  buf = String.new( capacity: text.size+4 )
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

<!--
Hold on. Let's use String slices if possible and let's track a start index and length 
for copying unmapped (1 : 1) runs all-at-once instead of moving over every single-character one at-a-time. 

``` ruby
# To be done or exercise for the reader.
```
-->


Can you find a faster way? Show us.


---

Notes:

Frank J. Cameron writes in if you have only single-character mappings (e.g. no ligatures such as `æ=>ae`, `ß=>ss` etc.) 
than `String#tr` is the winner and unmatched speed king (or queen):

``` ruby
def unaccent_tr( text )
   text.tr( 'ÄÁäáÉéÍíïÑñÖÓöóÜÚüú', 'AAaaEeIiiNnOOooUUuu' )
end

unaccent_tr( 'AÄÁaäáEÉéIÍiíïNÑnñOÖÓoöósUÜÚuüú' )
#=> "AAAaaaEEeIIiiiNNnnOOOooosUUUuuu"     # Yes!
unaccent_tr( 'AÆaæsß' )
#=> "AÆaæsß"                              # Oh, no! "AAEaaesss" expected.
```

Going native? Use C-code all the way down and try the wrapper for the UNIX `iconv()` function family translating strings between various encodings:

``` ruby
require 'iconv'
def unaccent_iconv( text )
   Iconv.iconv( 'ascii//translit//ignore', 'utf-8', text )
end

unaccent_iconv( 'AÄÁaäáEÉéIÍiíïNÑnñOÖÓoöósUÜÚuüú' )
#=> "AAAaaaEEeIIiiiNNnnOOOooosUUUuuu"    # Yes!
unaccent_iconv( 'AÆaæsß' )
#=> "AÆaæsß"                             # Oh, no! "AAEaaesss" expected.
```

Note: Transliteration will NOT work for ligatures such as `Æ æ ß` and others.


Hold on. What about unicode normalization and decomposition?
Let's try:

``` ruby
'AÄÁaäáEÉéIÍiíïNÑnñOÖÓoöósUÜÚuüú'.unicode_normalize(:nfd).gsub( /\p{M}/, '' )
#=> "AAAaaaEEeIIiiiNNnnOOOooosUUUuuu"    # Yes!
'AÆaæsß'.unicode_normalize(:nfd).gsub( /\p{M}/, '' )
#=> "AÆaæsß"                             # Oh, no! "AAEaaesss" expected.
```

Note: The normalization form decomposed (`:nfd`) uses separate codepoints for graphemes (such as accent or diacritics marks) 
in contrast to the normalization form composed (`:nfc`), that is, the default. Once the unicode characters are decomposed you can delete all accent or diacritics marks using the unicode regex property (`\p`) for the mark (`M`) category, that is, `\p{M}`. 
Unfortunately, the normalization will NOT work for ligatures such as `Æ æ ß` and others.

For more about Ruby and Unicode, see the great Ruby ♡ Unicode series by Jan Lelis at the Idiosyncratic Ruby website:

- [Ruby has Character](https://idiosyncratic-ruby.com/66-ruby-has-character) - Ruby comes with good support for Unicode-related features. Read on if you want to learn more about important Unicode fundamentals and how to use them in Ruby...
- [Proper Unicoding](https://idiosyncratic-ruby.com/41-proper-unicoding) - Ruby's Regexp engine has a powerful feature built in: It can match for Unicode character properties. But what exactly are properties you can match for?
- [Regex with Class](https://idiosyncratic-ruby.com/30-regex-with-class) - Ruby's regex engine defines a lot of shortcut character classes. Besides the common meta characters (`\w`, etc.), there is also the POSIX style expressions and the unicode property syntax. This is an overview of all character classes...

