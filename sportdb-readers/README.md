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


``` ruby
## turn on logging to console
ActiveRecord::Base.logger = Logger.new( STDOUT )

## assumes football.db datasets for England in ./england directory
##   see github.com/openfootball/england
SportDb::EventReaderV2.read( './england/2015-16/.conf.txt' )
SportDb::MatchReaderV2.read( './england/2015-16/1-premierleague-i.txt' )
SportDb::MatchReaderV2.read( './england/2015-16/1-premierleague-ii.txt' )

## let's try another season
SportDb::EventReaderV2.read( './england/2019-20/.conf.txt' )
SportDb::MatchReaderV2.read( './england/2019-20/1-premierleague.txt' )
```

That's it. All leagues, seasons, clubs, match days and rounds, match fixtures and results,
and more are now in your (SQL) database of choice.


## License

The `sportdb-readers` scripts are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.


## Questions? Comments?

Send them along to the
[Open Sports & Friends Forum/Mailing List](http://groups.google.com/group/opensport).
Thanks!
