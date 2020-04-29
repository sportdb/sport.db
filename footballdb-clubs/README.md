# footballdb-clubs - the world's top football clubs


* home  :: [github.com/sportdb/sport.db](https://github.com/sportdb/sport.db)
* bugs  :: [github.com/sportdb/sport.db/issues](https://github.com/sportdb/sport.db/issues)
* gem   :: [rubygems.org/gems/footballdb-clubs](https://rubygems.org/gems/footballdb-clubs)
* rdoc  :: [rubydoc.info/gems/footballdb-clubs](http://rubydoc.info/gems/footballdb-clubs)
* forum :: [opensport](http://groups.google.com/group/opensport)


## Usage

Note: This library ships with a built-in copy of the
[open (public domain) football.db /clubs datasets](https://github.com/openfootball/clubs)
(2500+ football clubs from around the world)
bundled up into a single [`clubs.txt`](config/clubs.txt) datafile
for easy zero-configuration "out-of-the-box" usage.


Get and pretty print (pp) all clubs:

``` ruby
require 'footballdb/clubs/auto'

pp Club.all
```

resulting in:

```
[#<Club @name="Al Ahly",              @city="Cairo", @country="Egypt", ...>,
 #<Club @name="Al Mokawloon Al Arab", @city="Cairo", @country="Egypt", ...>,
 #<Club @name="El Dakhleya",          @city="Cairo", @country="Egypt", ...>,
 #<Club @name="El Entag El Harby",    @city="Cairo", @country="Egypt", ...>,
 ...
]
```


Let's match football club name "variants" e.g. `Arsenal`
to canonical global unique names e.g. `Arsenal FC, London, England`:


``` ruby
m = Club.match( 'Arsenal' )
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
m = Club.match( 'AZ' )
m[0].name; m[0].city; m[0].country
#=> "AZ Alkmaar", "Alkmaar", "Netherlands"

m = Club.match( 'Bayern' )
# -or- try alternative names (and auto-generated spelling variants)
m = Club.match( 'Bayern München' )
m = Club.match( 'Bayern Munchen' )
m = Club.match( 'Bayern Muenchen' )
m[0].name; m[0].city; m[0].country
#=> "Bayern München", "München", "Germany"

# and so on
# ...
```

Let's print all names that have duplicate (more than one) matching club:

``` ruby
Club.mappings.each do |name, clubs|
  if clubs.size > 1
    puts "#{clubs.size} matching clubs for `#{name}`:"
    clubs.each do |club|
      puts "  - #{club.name}, #{club.city}, #{club.country.name} (#{club.country.key})"
    end
    puts
  end
end
```

resulting in:

```
2 matching clubs for `valencia`:
  - Valencia FC, Léogâne, Haiti (ht)
  - Valencia CF, Valencia, Spain (es)

2 matching clubs for `apollon`:
  - Apollon Limassol FC, , Cyprus (cy)
  - Apollon Smyrnis FC, Athens, Greece (gr)

3 matching clubs for `arsenal`:
  - Arsenal FC, London, England (eng)
  - Arsenal Tula, Tula, Russia (ru)
  - Arsenal de Sarandí, Sarandí, Argentina (ar)

2 matching clubs for `liverpool`:
  - Liverpool FC, Liverpool, England (eng)
  - Liverpool Montevideo, Montevideo, Uruguay (uy)

2 matching clubs for `barcelona`:
  - FC Barcelona, Barcelona, Spain (es)
  - Barcelona Guayaquil, Guayaquil, Ecuador (ec)

3 matching clubs for `nacional`:
  - CD Nacional Madeira, Funchal, Portugal (pt)
  - Club Nacional, Asunción, Paraguay (py)
  - Nacional de Montevideo, Montevideo, Uruguay (uy)

2 matching clubs for `sanjose`:
  - San Jose Earthquakes, San Jose, United States (us)
  - Club Deportivo San José, Oruro, Bolivia (bo)

...
```


Let's match football club names to find the wikipedia page name and url
(for the English edition):

``` ruby
m = Club.match( 'Club Brugge KV' )
m[0].wikipedia      #=> "Club Brugge KV"
m[0].wikipedia_url  #=> "https://en.wikipedia.org/wiki/Club_Brugge_KV"

m = Club.match( 'RSC Anderlecht' )
m[0].wikipedia      #=> "R.S.C. Anderlecht"
m[0].wikipedia_url  #=> "https://en.wikipedia.org/wiki/R.S.C._Anderlecht"

# and so on
# ...
```

Note:  Find all football club wikipedia page names in the built-in copy
bundled-up into a single [`clubs.wiki.txt`](config/clubs.wiki.txt) datafile.



That's it.


## License

The `footballdb-clubs` scripts are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.


## Questions? Comments?

Send them along to the
[Open Sports & Friends Forum/Mailing List](http://groups.google.com/group/opensport).
Thanks!
