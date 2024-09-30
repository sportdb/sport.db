# sportdb-search - find national teams, clubs, leagues & more

* home  :: [github.com/sportdb/sport.db](https://github.com/sportdb/sport.db)
* bugs  :: [github.com/sportdb/sport.db/issues](https://github.com/sportdb/sport.db/issues)
* gem   :: [rubygems.org/gems/sportdb-search](https://rubygems.org/gems/sportdb-search)
* rdoc  :: [rubydoc.info/gems/sportdb-search](http://rubydoc.info/gems/sportdb-search)




## Usage

Let's use the [/clubs datasets](https://github.com/openfootball/clubs)
(3000+ football clubs from around the world)
to match name "variants" e.g. `Arsenal`  to canonical global unique
names e.g. `Arsenal FC, London, England`:

``` ruby
require 'sportdb/search'


Club = Sports::Club

m = Club.match_by( name: 'Arsenal' )
m.size     # 3 club matches found
#=> 3
m[0].name; m[0].city; m[0].country
#=> "Arsenal FC", "London", "England"
m[1].name; m[1].city; m[1].country
#=> "Arsenal Tula", "Tula", "Russia"
m[2].name; m[2].city; m[2].country
#=> "Arsenal de Sarandí", "Sarandí", "Argentina"


m = Club.match_by( name: 'Arsenal', country: 'eng' )
# -or- try alternative names (and auto-generated spelling variants)
m = Club.match_by( name: 'Arsenal FC', country: 'eng' )
m = Club.match_by( name: 'Arsenal F.C.', country: 'eng' )
m = Club.match_by( name: '...A.r.s.e.n.a.l... F.C...', country: 'eng' )
m.size     # 1 club match found
#=> 1
m[0].name; m[0].city; m[0].country
#=> "Arsenal FC", "London", "England"

m = Club.match_by( name: 'Arsenal', country: 'ar' )
# -or- try alternative names (and auto-generated spelling variants)
m = Club.match_by( name: 'Arsenal Sarandí', country: 'ar' )
m = Club.match_by( name: 'Arsenal Sarandi', country: 'ar' )
m.size     # 1 club match found
#=> 1
m[0].name; m[0].city; m[0].country
#=> "Arsenal de Sarandí", "Sarandí", "Argentina"


# try some more
m = Club.match_by( name: 'AZ' )
m[0].name; m[0].city; m[0].country
#=> "AZ Alkmaar", "Alkmaar", "Netherlands"

m = Club.match_by( name: 'Bayern' )
# -or- try alternative names (and auto-generated spelling variants)
m = Club.match_by( name: 'Bayern München' )
m = Club.match_by( name: 'Bayern Munchen' )
m = Club.match_by( name: 'Bayern Muenchen' )
m[0].name; m[0].city; m[0].country
#=> "Bayern München", "München", "Germany"

# and so on
# ...
```


That's it.



## License

The `sportdb-search` scripts are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.


## Questions? Comments?

Yes, you can. More than welcome.
See [Help & Support »](https://github.com/openfootball/help)



