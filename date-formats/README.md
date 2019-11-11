# date-formats - read / parse and print dates (and times) from around the world


* home  :: [github.com/sportdb/sport.db](https://github.com/sportdb/sport.db)
* bugs  :: [github.com/sportdb/sport.db/issues](https://github.com/sportdb/sport.db/issues)
* gem   :: [rubygems.org/gems/date-formats](https://rubygems.org/gems/date-formats)
* rdoc  :: [rubydoc.info/gems/date-formats](http://rubydoc.info/gems/date-formats)
* forum :: [opensport](http://groups.google.com/group/opensport)


## Usage

Did you know?
Ruby's built-in standard date parser (that is, `Date.parse`)
only supports English month and day names.
Example:

```ruby
Date.parse( '1 Jan' )
#=> <Date: 2019-01-01 ((2458485j,0s,0n),+0s,2299161j)>
```

Let's try Spanish:

```ruby
Date.parse( '1 Ene' )
#=> invalid date (ArgumentError) in `parse`
```

What to do? Let's welcome the `date-formats` library
that lets you parse dates in foreign languages.
Example:

```ruby
require `date/formats`
DateFormats.parse( '1 Ene', lang: 'es' )
#=> <Date: 2019-01-01 ((2458485j,0s,0n),+0s,2299161j)>
```

Or in French:

```ruby
DateFormats.parse( 'Lundi 1 Janvier', lang: 'fr')
#=> <Date: 2019-01-01 ((2458485j,0s,0n),+0s,2299161j)>
```

How does it work?
The  `date-formats` library uses text patterns (that is, regular expressions)
for defining and parsing new date formats.
See the [`formats.rb`](lib/date-formats/formats.rb) script for all
current supported formats and languages.

For example, the Spanish date `1 Ene` gets matched by:

```ruby
/\b
 (?<day>\d{1,2})
   \s
 (?<month_name>#{MONTH_ES})
 \b/x
```

Where `MONTH_ES` is any of:

```
Enero      Ene
Febrero    Feb
Marzo      Mar
Abril      Abr
Mayo       May
Junio      Jun
Julio      Jul
Agosto     Ago
Septiembre  Sept  Sep  Set
Octubre    Oct
Noviembre  Nov
Diciembre  Dic
```

And the French date `Lundi 1 Janvier` gets matched by:

```ruby
/\b
 (?<day_name>#{DAY_FR})
   \s+
 (?<day>\d{1,2})
   \.?        # note: make dot optional
   \s+
 (?<month_name>#{MONTH_FR})
 (?=\s+|$|[\]])/x  ## note: allow end-of-string/line too
```

Where `DAY_FR` is any of:

```
Lundi     Lun  L
Mardi     Mar  Ma
Mercredi  Mer  Me
Jeudi     Jeu  J
Vendredi  Ven  V
Samedi    Sam  S
Dimanche  Dim  D
```

And `MONTH_FR` is any of:

```
Janvier    Janv   Jan
Février    Févr   Fév
Mars              Mar
Avril      Avri   Avr
Mai
Juin
Juillet    Juil
Août
Septembre  Sept
Octobre    Octo   Oct
Novembre   Nove   Nov
Décembre   Déce   Déc
```

And so on.


## License

The `date-formats` scripts are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.


## Questions? Comments?

Send them along to the
[Open Sports & Friends Forum/Mailing List](http://groups.google.com/group/opensport).
Thanks!
