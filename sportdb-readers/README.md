# sportdb-readers - sport.db readers for leagues, seasons, clubs, match schedules and results, and more


* home  :: [github.com/sportdb/sport.db](https://github.com/sportdb/sport.db)
* bugs  :: [github.com/sportdb/sport.db/issues](https://github.com/sportdb/sport.db/issues)
* gem   :: [rubygems.org/gems/sportdb-readers](https://rubygems.org/gems/sportdb-readers)
* rdoc  :: [rubydoc.info/gems/sportdb-readers](http://rubydoc.info/gems/sportdb-readers)
* forum :: [opensport](http://groups.google.com/group/opensport)



## Usage


**Step 1**

Setup the (SQL) database. Let's use and build a single-file SQLite database (from scratch),
as an example:

``` ruby
require 'sportdb/readers'

SportDb.connect( adapter:  'sqlite3',
                 database: './england.db' )
SportDb.create_all       ## build database schema (tables, indexes, etc.)
```

**Step 2**

Let's read in some leagues, seasons, clubs, and match schedules and results.
Let's use the public domain football.db datasets for England (see [`openfootball/england`](https://github.com/openfootball/england)), as an example:


```
= English Premier League 2015/16

Matchday 1

[Sat Aug 8]
  Manchester United      1-0  Tottenham Hotspur
  AFC Bournemouth        0-1  Aston Villa
  Everton FC             2-2  Watford FC
  Leicester City         4-2  Sunderland AFC
  Norwich City           1-3  Crystal Palace
  Chelsea FC             2-2  Swansea City
[Sun Aug 9]
  Arsenal FC             0-2  West Ham United
  Newcastle United       2-2  Southampton FC
  Stoke City             0-1  Liverpool FC
[Mon Aug 10]
  West Bromwich Albion   0-3  Manchester City

...
```

and let's try:

``` ruby
## assumes football.db datasets for England in ./england directory
##   see github.com/openfootball/england
SportDb::MatchReader.read( './england/2015-16/1-premierleague-i.txt' )
SportDb::MatchReader.read( './england/2015-16/1-premierleague-ii.txt' )

## let's try another season
SportDb::MatchReader.read( './england/2019-20/1-premierleague.txt' )
```

All leagues, seasons, clubs, match days and rounds, match fixtures and results,
and more are now in your (SQL) database of choice.

The proof of the pudding - Let's query the (SQL) database using the sport.db ActiveRecord models:

``` ruby
include SportDb::Models

pl_2015_16 = Event.find_by( key: 'eng.1.2015/16' )
#=> SELECT * FROM events WHERE key = 'eng.1.2015/16' LIMIT 1

pl_2015_16.teams.count  #=> 20
#=> SELECT COUNT(*) FROM teams
#      INNER JOIN events_teams ON teams.id = events_teams.team_id
#      WHERE events_teams.event_id = 1

pl_2015_16.games.count  #=> 380
#=>  SELECT COUNT(*) FROM games
#      INNER JOIN rounds ON games.round_id = rounds.id
#      WHERE rounds.event_id = 1

pl_2019_20 = Event.find_by( key: 'eng.1.2019/20' )
pl_2015_16.teams.count  #=> 20
pl_2015_16.games.count  #=> 380

# -or-

pl = League.find_by( key: 'eng.1' )
#=> SELECT * FROM leagues WHERE key = 'eng.1' LIMIT 1

pl.seasons.count   #=> 2
#=> SELECT COUNT(*) FROM seasons
#     INNER JOIN events ON seasons.id = events.season_id
#     WHERE events.league_id = 1

# and so on and so forth.
```



Or as an alternative use the `read` convenience all-in-one shortcut helper:

``` ruby
## assumes football.db datasets for England in ./england directory
##   see github.com/openfootball/england
SportDb.read( './england/2015-16/1-premierleague-i.txt' )
SportDb.read( './england/2015-16/1-premierleague-ii.txt' )

## let's try another season
SportDb.read( './england/2019-20/1-premierleague.txt' )
```

Bonus: Or as an alternative pass in the "package" directory or a zip archive and let `read` figure
out what datafiles to read:

``` ruby
## assumes football.db datasets for England in ./england directory
##   see github.com/openfootball/england
SportDb.read( './england' )
## -or-   use a zip archive download
SportDb.read( './england.zip' )
```

That's it.



## License

The `sportdb-readers` scripts are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.


## Questions? Comments?

Send them along to the
[Open Sports & Friends Forum/Mailing List](http://groups.google.com/group/opensport).
Thanks!
