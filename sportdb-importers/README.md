# sportdb-importers - tools 'n' scripts for importing sports (football) data in alternate (text) formats incl. comma-separated values (csv) format"


* home  :: [github.com/sportdb/sport.db](https://github.com/sportdb/sport.db)
* bugs  :: [github.com/sportdb/sport.db/issues](https://github.com/sportdb/sport.db/issues)
* gem   :: [rubygems.org/gems/sportdb-importers](https://rubygems.org/gems/sportdb-importers)
* rdoc  :: [rubydoc.info/gems/sportdb-importers](http://rubydoc.info/gems/sportdb-importers)
* forum :: [opensport](http://groups.google.com/group/opensport)



## Usage

Let's import all datafiles for all seasons (from 1888-89 to today)
for [England](https://github.com/footballcsv/england), use:

``` ruby
require 'sportdb/importers'

## note: requires a local copy of the football.db clubs datasets
##          see https://github.com/openfootball/clubs
SportDb::Import.config.clubs_dir = './clubs'


SportDb.connect( adapter:  'sqlite3',
                 database: './eng.db' )

SportDb.create_all   ## build database schema / tables


## note: requires a local copy of the football.csv england datasets
##          see https://github.com/footballcsv/england
pack = CsvPackage.new( './england' )
pack.import
```

That's it.


## License

The `sportdb-importers` scripts are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.


## Questions? Comments?

Send them along to the
[Open Sports & Friends Forum/Mailing List](http://groups.google.com/group/opensport).
Thanks!
