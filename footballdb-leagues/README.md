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
require 'footballdb/leagues'

pp League.all
```

resulting in:


...



## License

The `footballdb-leagues` scripts are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.


## Questions? Comments?

Send them along to the
[Open Sports & Friends Forum/Mailing List](http://groups.google.com/group/opensport).
Thanks!
