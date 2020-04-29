# footballdb-leagues - the world's top football leagues & cups


* home  :: [github.com/sportdb/sport.db](https://github.com/sportdb/sport.db)
* bugs  :: [github.com/sportdb/sport.db/issues](https://github.com/sportdb/sport.db/issues)
* gem   :: [rubygems.org/gems/footballdb-leagues](https://rubygems.org/gems/footballdb-leagues)
* rdoc  :: [rubydoc.info/gems/footballdb-leagues](http://rubydoc.info/gems/footballdb-leagues)
* forum :: [opensport](http://groups.google.com/group/opensport)



## Usage

Note: This library ships with a built-in copy of the
[open (public domain) football.db /leagues datasets](https://github.com/openfootball/leagues)
(100+ football leagues & cups from around the world)
bundled up into a single [`leagues.txt`](config/leagues.txt) datafile
for easy zero-configuration "out-of-the-box" usage.


Get and pretty print (pp) all leagues & cups:

``` ruby
require 'footballdb/leagues/auto'

pp League.all
```

resulting in:

```
[#<League @name="English Premier League", @country="England", ...>,
 #<League @name="English Championship",   @country="England", ...>,
 #<League @name="English League One",     @country="England", ...>,
 #<League @name="English League Two",     @country="England", ...>,
 ...
]
```

Let's find football leagues in the world
with the name `Premier League`:

``` ruby
m = League.match( 'Premier League' )
m.size     # 7 league matches found
#=> 7
m[0].name; m[0].country
#=> "English Premier League", "England"
m[1].name; m[1].country
#=> "Welsh Premier League", "Wales"
m[2].name;  m[2].country
#=> "Russian Premier League", "Russia"
# ...

m = League.match_by( name: 'Premier League', country: 'eng' )
# -or- try more alternative (unique) names
m = League.match( 'England Premier League' )
m = League.match( 'ENG 1' )
m = League.match( 'ENG PL' )
m.size     # 1 league match found
#=> 1
m[0].name; m[0].country
#=> "English Premier League",  "England"

m = League.match_by( name: 'Premier League', country: 'ru' )
# -or- try more alternative (unique) names
m = League.match( 'Russia Premier League' )
m = League.match( 'RUS 1' )
m = League.match( 'RUS PL' )
m.size     # 1 league match found
#=> 1
m[0].name; m[0].country
#=> "Russian Premier League", "Russia"


# try some more
m = League.match( 'Brasileiro Série A' )
m[0].name; m[0].country
#=> "Brasileiro Série A", "Brazil"

m = League.match( 'Major League Soccer' )
# -or- try more alternative (unique) names
m = League.match( 'USA MLS' )
m = League.match( 'USA 1' )
m[0].name; m[0].country
#=> "Major League Soccer", "United States"

# and so on
# ...
```


Let's print all names that have duplicate (more than one) matching league:

``` ruby
League.mappings.each do |name, leagues|
  if leagues.size > 1
    puts "#{leagues.size} matching leagues for `#{name}`:"
    leagues.each do |league|
      puts "  - #{league.name}, #{league.country.name} (#{league.country.key})"
    end
    puts
  end
end
```

resulting in:

```
2 matching leagues for `bundesliga`:
  - German Bundesliga, Germany (de)
  - Austrian Bundesliga, Austria (at)

5 matching leagues for `primeradivisión`:
  - Primera División, Paraguay (py)
  - Primera División, Peru (pe)
  - Primera División, Uruguay (uy)
  ...

7 matching leagues for `premierleague`:
  - English Premier League, England (eng)
  - Welsh Premier League, Wales (wal)
  - Russian Premier League, Russia (ru)
  ...
...
```

That's it.



## License

The `footballdb-leagues` scripts are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.


## Questions? Comments?

Send them along to the
[Open Sports & Friends Forum/Mailing List](http://groups.google.com/group/opensport).
Thanks!
