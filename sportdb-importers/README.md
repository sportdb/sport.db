# sportdb-importers - tools 'n' scripts for importing sports (football) data in alternate (text) formats incl. comma-separated values (csv) format


* home  :: [github.com/sportdb/sport.db](https://github.com/sportdb/sport.db)
* bugs  :: [github.com/sportdb/sport.db/issues](https://github.com/sportdb/sport.db/issues)
* gem   :: [rubygems.org/gems/sportdb-importers](https://rubygems.org/gems/sportdb-importers)
* rdoc  :: [rubydoc.info/gems/sportdb-importers](http://rubydoc.info/gems/sportdb-importers)
* forum :: [opensport](http://groups.google.com/group/opensport)


## Usage


**Step 1**

Setup the (SQL) database. Let's use and build a single-file SQLite database (from scratch),
as an example:

``` ruby
require 'sportdb/importers'

SportDb.connect( adapter:  'sqlite3',
                 database: './england.db' )
SportDb.create_all       ## build database schema (tables, indexes, etc.)
```


**Step 2**

Let's use the public domain football.csv datasets for England (see [`footballcsv/england`](https://github.com/footballcsv/england)), as an example:

```
Round, Date,            Team 1,               FT,  HT,  Team 2
1,     Fri Aug 9 2019,  Liverpool FC,         4-1, 4-0, Norwich City FC
1,     Sat Aug 10 2019, West Ham United FC,   0-5, 0-1, Manchester City FC
1,     Sat Aug 10 2019, AFC Bournemouth,      1-1, 0-0, Sheffield United FC
1,     Sat Aug 10 2019, Burnley FC,           3-0, 0-0, Southampton FC
1,     Sat Aug 10 2019, Crystal Palace FC,    0-0, 0-0, Everton FC
1,     Sat Aug 10 2019, Watford FC,           0-3, 0-1, Brighton & Hove Albion FC
1,     Sat Aug 10 2019, Tottenham Hotspur FC, 3-1, 0-1, Aston Villa FC
1,     Sun Aug 11 2019, Leicester City FC,    0-0, 0-0, Wolverhampton Wanderers FC
1,     Sun Aug 11 2019, Newcastle United FC,  0-1, 0-0, Arsenal FC
1,     Sun Aug 11 2019, Manchester United FC, 4-0, 1-0, Chelsea FC
...
```
(Source: [england/2019-20/eng.1.csv](https://github.com/footballcsv/england/blob/master/2010s/2019-20/eng.1.csv))


and let's try:

``` ruby
## assumes football.csv datasets for England in ./england directory
##   see github.com/footballcsv/england
SportDb.read_csv( './england/2019-20/eng.1.csv' )

## let's try another season
SportDb.read_csv( './england/2018-19/eng.1.csv' )
SportDb.read_csv( './england/2018-19/eng.2.csv' )
```

All leagues, seasons, clubs, match days and rounds, match fixtures and results,
and more are now in your (SQL) database of choice.


Bonus: Let's import all datafiles for all seasons (from 1888-89 to today)
for England, use:

``` ruby
## note: requires a local copy of the football.csv england datasets
##          see https://github.com/footballcsv/england
SportDb.read_csv( './england' )
# -or-    use a zip archive
SportDb.read_csv( './england.zip' )
```

That's it.


## Frequently Asked Questions (FAQ) and Answers

### Q: What CSV formats can I use?

For now the importers support two flavors.

Alternative 1)  One league and season per datafile and
the basename (e.g. `eng.1` ) holds the league code
and the directory (e.g. `2019-20`) the season.

```
Matchday, Date,            Time,  Team 1,    FT,  Team 2
1,        Fri Aug 9 2019,  20:00, Liverpool, 4-1, Norwich City
1,        Sat Aug 10 2019, 12:30, West Ham,  0-5, Manchester City
...
```

Alternative 2) Any or many leagues or seasons per datafile,
for example, week by week (see [`/updates`](https://github.com/footballcsv/cache.updates))
or year by year (see [`/internationals`](https://github.com/footballcsv/cache.internationals)).

```
Date,            League, Team 1,             FT,  Team 2
Wed Jun 10 2020, DE 3,   SpVgg Unterhaching, 1-3, Eintracht Braunschweig
Thu Jun 11 2020, AT 2,   FC Blau-Weiß Linz,  1-2, Austria Klagenfurt
Thu Jun 11 2020, ES 1,   Sevilla FC,         2-0, Real Betis
...
```

Note: For now the convention is that the datafile basename
MUST be all numbers, that is, `0` to `9` (plus `-` or `_`) e.g.
`01` (as in `2020/01.csv`) or `2020` (as in `2000s/2020.csv`).


### Q: What codes or names for league & cups can I use?

The importers ship with hundreds of zero-config preconfigured
code and names for leagues & cups.
See the [/leagues](https://github.com/openfootball/leagues) datasets for all builtin national and international football club leagues & cups from around the world.

Or to query in ruby try:

``` ruby
require `sportdb/config`

LEAGUES = SportDb::Import.catalog.leagues

LEAGUES.find( 'ENG 1' )      #=> Premier League   › England
LEAGUES.find( 'EPL' )        #=> Premier League   › England
LEAGUES.find( 'ENG 2' )      #=> Championship     › England
LEAGUES.find( 'ENG CS' )     #=> Championship     › England
LEAGUES.find( 'ES' )         #=> Primera División › Spain
LEAUGES.find( 'ESP 1')       #=> Primera División › Spain
...
```



## License

The `sportdb-importers` scripts are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.


## Questions? Comments?

Send them along to the
[Open Sports & Friends Forum/Mailing List](http://groups.google.com/group/opensport).
Thanks!
