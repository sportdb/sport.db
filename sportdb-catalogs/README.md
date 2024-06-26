# sportdb-catalogs - sport.db (search & find) catalogs for countries, leagues, clubs, national teams, and more


* home  :: [github.com/sportdb/sport.db](https://github.com/sportdb/sport.db)
* bugs  :: [github.com/sportdb/sport.db/issues](https://github.com/sportdb/sport.db/issues)
* gem   :: [rubygems.org/gems/sportdb-catalogs](https://rubygems.org/gems/sportdb-catalogs)
* rdoc  :: [rubydoc.info/gems/sportdb-catalogs](http://rubydoc.info/gems/sportdb-catalogs)




## Usage  

Let's use the [/clubs datasets](https://github.com/openfootball/clubs)
(1500+ football clubs from around the world)
to match name "variants" e.g. `Arsenal`  to canonical global unique
names e.g. `Arsenal FC, London, England`:

``` ruby
require 'sportdb/catalogs'

## note: requires a local copy of the football.db clubs datasets
##          see https://github.com/openfootball/clubs
SportDb::Import.config.clubs_dir = './clubs'

CLUBS = SportDb::Import.catalog.clubs

m = CLUBS.match( 'Arsenal' )
m.size     # 3 club matches found
#=> 3
m[0].name; m[0].city; m[0].country
#=> "Arsenal FC", "London", "England"
m[1].name; m[1].city; m[1].country
#=> "Arsenal Tula", "Tula", "Russia"
m[2].name; m[2].city; m[2].country
#=> "Arsenal de Sarandí", "Sarandí", "Argentina"


m = CLUBS.match_by( name: 'Arsenal', country: 'eng' )
# -or- try alternative names (and auto-generated spelling variants)
m = CLUBS.match_by( name: 'Arsenal FC', country: 'eng' )
m = CLUBS.match_by( name: 'Arsenal F.C.', country: 'eng' )
m = CLUBS.match_by( name: '...A.r.s.e.n.a.l... F.C...', country: 'eng' )
m.size     # 1 club match found
#=> 1
m[0].name; m[0].city; m[0].country
#=> "Arsenal FC", "London", "England"

m = CLUBS.match_by( name: 'Arsenal', country: 'ar' )
# -or- try alternative names (and auto-generated spelling variants)
m = CLUBS.match_by( name: 'Arsenal Sarandí', country: 'ar' )
m = CLUBS.match_by( name: 'Arsenal Sarandi', country: 'ar' )
m.size     # 1 club match found
#=> 1
m[0].name; m[0].city; m[0].country
#=> "Arsenal de Sarandí", "Sarandí", "Argentina"


# try some more
m = CLUBS.match( 'AZ' )
m[0].name; m[0].city; m[0].country
#=> "AZ Alkmaar", "Alkmaar", "Netherlands"

m = CLUBS.match( 'Bayern' )
# -or- try alternative names (and auto-generated spelling variants)
m = CLUBS.match( 'Bayern München' )
m = CLUBS.match( 'Bayern Munchen' )
m = CLUBS.match( 'Bayern Muenchen' )
m[0].name; m[0].city; m[0].country
#=> "Bayern München", "München", "Germany"

# and so on
# ...
```


That's it.



## License

The `sportdb-catalogs` scripts are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.


## Questions? Comments?

Yes, you can. More than welcome.
See [Help & Support »](https://github.com/openfootball/help)
