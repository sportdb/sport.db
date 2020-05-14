# sportdb-importers - tools 'n' scripts for importing sports (football) data in alternate (text) formats incl. comma-separated values (csv) format"


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
Round, Date,              Team 1,               FT,  HT,  Team 2
1,     (Fri)  9 Aug 2019, Liverpool FC,         4-1, 4-0, Norwich City FC
1,     (Sat) 10 Aug 2019, West Ham United FC,   0-5, 0-1, Manchester City FC
1,     (Sat) 10 Aug 2019, AFC Bournemouth,      1-1, 0-0, Sheffield United FC
1,     (Sat) 10 Aug 2019, Burnley FC,           3-0, 0-0, Southampton FC
1,     (Sat) 10 Aug 2019, Crystal Palace FC,    0-0, 0-0, Everton FC
1,     (Sat) 10 Aug 2019, Watford FC,           0-3, 0-1, Brighton & Hove Albion FC
1,     (Sat) 10 Aug 2019, Tottenham Hotspur FC, 3-1, 0-1, Aston Villa FC
1,     (Sun) 11 Aug 2019, Leicester City FC,    0-0, 0-0, Wolverhampton Wanderers FC
1,     (Sun) 11 Aug 2019, Newcastle United FC,  0-1, 0-0, Arsenal FC
1,     (Sun) 11 Aug 2019, Manchester United FC, 4-0, 1-0, Chelsea FC
...
```
(Source: [england/2019-20/eng.1.csv](https://github.com/footballcsv/england/blob/master/2010s/2019-20/eng.1.csv))


And let's import all datafiles for all seasons (from 1888-89 to today)
for England, use:

``` ruby
## note: requires a local copy of the football.csv england datasets
##          see https://github.com/footballcsv/england
SportDb.read_csv( './england' )
# or use a zip archive
SportDb.read_csv( './england.zip' )
```

That's it.



## License

The `sportdb-importers` scripts are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.


## Questions? Comments?

Send them along to the
[Open Sports & Friends Forum/Mailing List](http://groups.google.com/group/opensport).
Thanks!
