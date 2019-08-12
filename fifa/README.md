# fifa - the world's football countries and codes (incl. non-member countries and irregular codes)


* home  :: [github.com/sportdb/sport.db](https://github.com/sportdb/sport.db)
* bugs  :: [github.com/sportdb/sport.db/issues](https://github.com/sportdb/sport.db/issues)
* gem   :: [rubygems.org/gems/fifa](https://rubygems.org/gems/fifa)
* rdoc  :: [rubydoc.info/gems/fifa](http://rubydoc.info/gems/fifa)
* forum :: [opensport](http://groups.google.com/group/opensport)


## What's FIFA?

The World's Football Association / Governing Body
uses its own country list and (three-letter) codes - see
the [List of FIFA country codes @ Wikipedia](https://en.wikipedia.org/wiki/List_of_FIFA_country_codes)
or the [`countries.txt`](https://github.com/sportdb/sport.db/blob/master/fifa/config/countries.txt) list shipping with this library.

Triva - The FIFA member list includes 211 countries while the United Nations (UN)
member list only includes 191 countries.
For example, for historic reasons the FIFA includes:

- England (ENG)
- Wales (WAL)
- Scotland (SCO)
- Northern Ireland (NIR)

but doesn't include the United Kingdom (UK) itself.
Or the FIFA includes (non-sovereign) dependent territories or autonomous regions
that have their own national team or leagues, for example:

- Gibraltar (GIB)
- Faroe Islands	(FRO)
- Hong Kong (HKG)
- and others.


Note: This library includes non-FIFA member codes and irregular codes
from countries in use by regional confederations too, for exmaple:

- Vatican City	(VAT)
- Zanzibar	(ZAN)
- and others.



## Usage

Get and pretty print all countries

``` ruby
pp Fifa.countries
```

resulting in:

```
[#<Country @fifa="AFG", @key="af", @name="Afghanistan">,
 #<Country @fifa="ALB", @key="al", @name="Albania">,
 #<Country @fifa="ALG", @key="dz", @name="Algeria">,
 #<Country @fifa="ASA", @key="as", @name="American Samoa">,
 #<Country @fifa="AND", @key="ad", @name="Andorra">,
 #<Country @fifa="ANG", @key="ao", @name="Angola">,
 #<Country @fifa="AIA", @key="ai", @name="Anguilla">,
 #<Country @fifa="ATG", @key="ag", @name="Antigua and Barbuda">,
 #<Country @fifa="ARG", @key="ar", @name="Argentina">,
 #<Country @fifa="ARM", @key="am", @name="Armenia">,
 #<Country @fifa="ARU", @key="aw", @name="Aruba">,
 #<Country @fifa="AUS", @key="au", @name="Australia">,
 #<Country @fifa="AUT", @key="at", @name="Austria">,
 #<Country @fifa="AZE", @key="az", @name="Azerbaijan">,
 ...
]
```

Note: If you prefer you can use the all-upcase `FIFA` name as an alias for `Fifa`.


Let's lookup some countries by the fifa (three-letter) code:

``` ruby
eng = Fifa['ENG']
# -or-
eng = Fifa['eng']
eng = Fifa[:eng]

eng.key    #=> "eng"
eng.name   #=> "England"
eng.fifa   #=> "ENG"


aut  = Fifa['AUT']
# -or-
aut  = Fifa['aut']
aut  = Fifa[:aut]

aut.key    #=> "at"
aut.name   #=> "Austria"
aut.fifa   #=> "AUT"

...
```


That's it.


## License

The `fifa` scripts are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.


## Questions? Comments?

Send them along to the
[Open Sports & Friends Forum/Mailing List](http://groups.google.com/group/opensport).
Thanks!
