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
each_char            1.781000   0.000000   1.781000 (  1.801168)
each_char_v2         1.531000   0.000000   1.531000 (  1.515729)
each_char_reduce     1.985000   0.000000   1.985000 (  1.984208)
each_char_reduce_v2  1.656000   0.000000   1.656000 (  1.658758)
gsub                 1.500000   0.000000   1.500000 (  1.489751)
gsub_v2              1.187000   0.000000   1.187000 (  1.195290)
scan                 2.547000   0.000000   2.547000 (  2.570355)

text=>Aa Ee Ii Oo Uu...<, n=20000:
                          user     system      total        real
each_char            0.468000   0.000000   0.468000 (  0.467562)
each_char_v2         0.485000   0.000000   0.485000 (  0.467827)
each_char_reduce     0.531000   0.000000   0.531000 (  0.534984)
each_char_reduce_v2  0.531000   0.000000   0.531000 (  0.541277)
gsub                 0.047000   0.000000   0.047000 (  0.046810)
gsub_v2              0.047000   0.000000   0.047000 (  0.050223)
scan                 0.766000   0.000000   0.766000 (  0.749982)
```

Voila. And the winner is...  `gsub` with the optimized mapping lookup shortcut.
Can you find a faster way? Show us.
