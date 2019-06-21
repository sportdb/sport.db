# sportdb-import - tools 'n' scripts for importing sports (football) data in alternate (text) formats incl. comma-separated values (csv) format"


* home  :: [github.com/sportdb/sport.db](https://github.com/sportdb/sport.db)
* bugs  :: [github.com/sportdb/sport.db/issues](https://github.com/sportdb/sport.db/issues)
* gem   :: [rubygems.org/gems/sportdb-text](https://rubygems.org/gems/sportdb-import)
* rdoc  :: [rubydoc.info/gems/sportdb-text](http://rubydoc.info/gems/sportdb-import)
* forum :: [opensport](http://groups.google.com/group/opensport)


## Usage

Let's import all datafiles for all seasons (from 1888-89 to today) 
for [England](https://github.com/footballcsv/england), use: 

``` ruby
require 'sportdb/import' 

SportDb.connect( adapter:  'sqlite3', 
                 database: './eng.db' ) 

## build database schema / tables 
SportDb.create_all 

## turn on logging to console 
ActiveRecord::Base.logger = Logger.new(STDOUT) 

pack = CsvMatchImporter.new( './england' ) 
pack.import_leagues 
```

That's it.


## License

The `sportdb-import` scripts are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.


## Questions? Comments?

Send them along to the
[Open Sports & Friends Forum/Mailing List](http://groups.google.com/group/opensport).
Thanks!
