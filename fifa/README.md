# fifa - the world's football countries and codes (incl. non-member countries and irregular codes)


* home  :: [github.com/sportdb/sport.db](https://github.com/sportdb/sport.db)
* bugs  :: [github.com/sportdb/sport.db/issues](https://github.com/sportdb/sport.db/issues)
* gem   :: [rubygems.org/gems/fifa](https://rubygems.org/gems/fifa)
* rdoc  :: [rubydoc.info/gems/fifa](http://rubydoc.info/gems/fifa)
* forum :: [opensport](http://groups.google.com/group/opensport)


## Usage

Get and pretty print (pp) all countries

``` ruby
require 'fifa'

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

Or get all countries / members by continental confederation:

- Asian Football Confederation (AFC; 47 members) (a)
- Confederation of African Football (CAF; 56 members)
- Confederation of North, Central American and Caribbean Association Football (CONCACAF; 41 members) (b)
- Confederación Sudamericana de Fútbol (CONMEBOL; 10 members)
- Oceania Football Confederation (OFC; 14 members) (a)
- Union of European Football Associations (UEFA; 55 members) (c)

(a) Australia has been a member of the AFC since 2006.

(b) French Guiana, Guyana and Suriname are CONCACAF members although they are in South America. The French Guiana team is a member of CONCACAF but not of FIFA.

(c) Teams representing the nations of Armenia, Azerbaijan, Cyprus, Georgia, Israel, Kazakhstan, Russia and Turkey are UEFA members, although the majority or entirety of their territory is outside of continental Europe. Monaco is not member of UEFA or FIFA.


``` ruby
Fifa.members( 'FIFA' ).size          #=> 211 members  -or-
Fifa.members( 'World' ).size         #=> 211 members

Fifa.members( 'AFC' ).size           #=> 47 members   -or-
Fifa.members( 'Asia' ).size          #=> 47 members

Fifa.members( 'CAF').size            #=> 56 members  -or-
Fifa.members( 'Africa' ).size        #=> 56 members

Fifa.members( 'CONCACAF').size       #=> 41 members  -or-
Fifa.members( 'North, Central America and Caribbean').size   #=> 41 members

Fifa.members( 'CONMEBOL' ).size      #=> 10 members  -or-
Fifa.members( 'South America' ).size #=> 10 members

Fifa.members( 'OFC' ).size           #=> 14 members  -or-
Fifa.members( 'Oceania' ).size       #=> 14 members

Fifa.members( 'UEFA' ).size          #=> 55 members  -or-
Fifa.members( 'Europe' ).size        #=> 55 members

...
```

That's it.



## What's FIFA¹?

The World's Football Association / Governing Body
uses its own country list and (three-letter²) codes - see
the [List of FIFA country codes @ Wikipedia](https://en.wikipedia.org/wiki/List_of_FIFA_country_codes)
or the [`countries.txt`](https://github.com/sportdb/sport.db/blob/master/fifa/config/countries.txt) list shipping with this library.

Trivia - The FIFA member list includes 211 countries (in 2019) while the United Nations (UN)
member list only includes 193 countries.
For example, for historic reasons the FIFA includes:

- England › UK (ENG)
- Wales › UK (WAL)
- Scotland › UK (SCO)
- Northern Ireland › UK (NIR)

but doesn't include the United Kingdom (UK) itself.
Or the FIFA includes (non-sovereign) dependent territories or autonomous regions
that have their own national team or leagues, for example:

- Gibraltar › UK (GIB)
- Faroe Islands › DK (FRO)
- Hong Kong › CN (HKG)
- Bermuda › UK (BER)
- Puerto Rico › US (PUR)
- and others


Note: This library includes non-FIFA member codes and irregular codes
from countries in use by regional confederations too, for example:

- Vatican City (VAT)
- Monaco (MCO)
- Micronesia (FSM)
- Palau (PLW)
- Réunion › FR (REU)
- Zanzibar › TZ (ZAN)
- Saint Martin › FR (SMN)
- Sint Maarten › NL (SMA)
- and others


¹: [Fédération Internationale de Football Association (FIFA) @ Wikipedia](https://en.wikipedia.org/wiki/FIFA)

²: Northern Cyprus (TRNC)	has a four-letter FIFA country code  


## License

The `fifa` scripts are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.


## Questions? Comments?

Send them along to the
[Open Sports & Friends Forum/Mailing List](http://groups.google.com/group/opensport).
Thanks!
