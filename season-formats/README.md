# season-formats - read / parse and print seasons (using an academic or calendar year)


* home  :: [github.com/sportdb/sport.db](https://github.com/sportdb/sport.db)
* bugs  :: [github.com/sportdb/sport.db/issues](https://github.com/sportdb/sport.db/issues)
* gem   :: [rubygems.org/gems/season-formats](https://rubygems.org/gems/season-formats)
* rdoc  :: [rubydoc.info/gems/season-formats](http://rubydoc.info/gems/season-formats)



## Usage


The idea is to follow the `Date` class and make `Season`
into a top-level free-standing class. Let's say you have
the season (using an academic year):

```
2020/21     # or
2020/1      # or
2020/2021   # or
2020-21
...
```


Using

``` ruby
require "season/formats"

season = Season.parse( "2020/21" )    # or
season = Season.parse( "2020/1" )     # or
season = Season.parse( "2020/2021" )  # or
season = Season.parse( "2020-21" )    # or

season.start_year       #=> 2020
season.end_year         #=> 2021

season.academic?        # or
season.academic_year?   #=> true

season.to_s             #=> "2020/21"
season.to_path          #=> "2020-21"
```

you can parse the season into its components, that is, the
start year (`start_year`) and end year (`end year`).

Using the `academic?` /  `academic_year?`
or `calendar?` / `calendar_year?` / `year?`  helpers
lets you check if the season uses an academic year (e.g. 2020/2021)
or a calendar year (e.g. 2020).


``` ruby
season = Season.parse( "2020" )

season.start_year       #=> 2020
season.end_year         #=> 2020

season.calendar?        # or
season.calendar_year?   # or
season.year?            #=> true

season.to_s             #=> "2020"
season.to_path          #=> "2020"
```

Using `to_s` gets you back a canonical / normalized name
(e.g. 2020/21 or 2020). For use in file names / paths
use `to_path` (2020-21 or 2020).




Like `Date` you can initialize `Season` with a "to-the-metal"
year or years as integer numbers e.g.:

``` ruby
season = Season.new( 2020, 2021 )

season.start_year       #=> 2020
season.end_year         #=> 2021

season.academic?        # or
season.academic_year?   #=> true

season.to_s             #=> "2020/21"
season.to_path          #=> "2020-21"

# -or-

season = Season.new( 2020 )

season.start_year       #=> 2020
season.end_year         #=> 2020

season.calendar?        # or
season.calendar_year?   # or
season.year?            #=> true

season.to_s             #=> "2020"
season.to_path          #=> "2020"
```


If you want to support / allow both string and integers in your
arguments, use the `Kernel#Season` method, that is,
a shortcut for `Season.convert`. Example:

``` ruby
season = Season( "2020/21" )    # or
season = Season( "2020/1" )     # or
season = Season( "2020/2021" )  # or
season = Season( "2020-21" )    # or
season = Season( 2020, 2021 )   # or
season = Season( 202021 )       # or
season = Season( 20202021 )

# -or-
season = Season( "2020" )    # or
season = Season( 2020 )
```



### Bonus: Using Ranges with Seasons

Yes, you can use the Season class for ruby's built-in ranges.
Example:

``` ruby
seasons = Season( '2010/11' )..Season( '2019/20' )
seasons.to_a
# => [2010/11, 2011/12, 2012/13, 2013/14, 2014/15,
#     2015/16, 2016/17, 2017/18, 2018/19, 2019/20]

seasons = Season( '2010' )..Season( '2019' )
seasons.to_a
# => [2010, 2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019]
```

The "magic" is possible thanks to `Season#succ / next`
and `Season#prev`.

``` ruby
Season( '2019/20' ).succ        # or
Season( '2019/20' ).next        #=>  2020/21

Season( '2019/20' ).succ.succ   # or
Season( '2019/20' ).next.next   #=>  2021/22

# -or-

Season( '2019' ).succ     # or
Season( '2019' ).next     #=>  2020
```


That's all for now.



## Installation

Use

    gem install season-formats

or add the gem to your Gemfile

    gem 'season-formats'



## License

The `season-formats` scripts are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.



## Questions? Comments?

Yes, you can. More than welcome.
See [Help & Support »](https://github.com/openfootball/help)
