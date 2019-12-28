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

Pre-configured date formats for now include:

**Base - Work for All Languages**

- `YYYY_MM_DD_hh_mm`  e.g. 2020-01-19 22:00  or 2020-1-19 22:00
- `YYYY_MM_DD` e.g. 2020-01-19   or 2020-1-19
- `DD_MM_YYYY_hh_mm` e.g. 19.01.2020 22.00  or 19.1.2020 22:00
- `DD_MM_hh_mm` e.g. 19.01. 22.00  or 19.1. 22:00
- `DD_MM_YYYY` e.g. 19.01.2020  or 19.1.2020
- `DD_MM`  e.g. 19.01.  or 19.1.

**English (`en`)**

- `DD_MONTH_YYYY_hh_mm` e.g. 19 Jan 2020 22:00
- `MONTH_DD_YYYY_hh_mm` e.g. Jan 19 2020 22:00 or Jan 19, 2020 22:00
- `MONTH_DD_hh_mm` e.g. Jan 19 22:00
- `MONTH_DD_YYYY` e.g. Jan 19 2020 or Jan 19, 2020 or January 19, 2020
- `DAY_MONTH_DD` e.g. Sun Jan 19 or Sun, Jan 19 or Sunday, January 19
- `MONTH_DD` e.g. Jan 19 or Jan/19
- `DD_MONTH` e.g. 19 Jan or 19/Jan

**Spanish / Español (`es`)**

- `DAY_DD_MONTH_hh_mm` e.g. Dom 19 Ene 22:00 or Dom 19 Ene 22h00
- `DAY_DD_MONTH` e.g. Dom 19 Ene or Dom 19 Enero
- `DD_MONTH` e.g. 19 Ene
- `DAY_DD_MM` e.g. Dom 19.01. or Dom 19.1.

**Portuguese / Português (`pt`)**

- `DD_MM_YYYY_DAY` e.g.  19/1/2020 Domenica
- `DAY_DD_MONTH` e.g. Dom 19 Jan  or  Dom 19 Janeiro
- `DAY_DD_MM` e.g. Dom 19/01  or Dom 19/1

**French / Français (`fr`)**

- `DAY_DD_MONTH` e.g. Dim. 19 Janv or Dim. 19 Janvier

**Italian / Italiano (`it`)**

- `DAY_MM_DD` e.g. Dom. 19.1.

**German / Deutsch (`de`)**

- `DAY_MM_DD` e.g. So 19.1. or So 19.01.



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
 \b/x
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
