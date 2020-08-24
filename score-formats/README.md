#  score-formats - read / parse and print sports match scores (incl. half time, full time, extra time, penalties and more)


* home  :: [github.com/sportdb/sport.db](https://github.com/sportdb/sport.db)
* bugs  :: [github.com/sportdb/sport.db/issues](https://github.com/sportdb/sport.db/issues)
* gem   :: [rubygems.org/gems/score-formats](https://rubygems.org/gems/score-formats)
* rdoc  :: [rubydoc.info/gems/score-formats](http://rubydoc.info/gems/score-formats)
* forum :: [opensport](http://groups.google.com/group/opensport)



## Usage


The idea is to follow the `Date` class and make `Score`
into a top-level free-standing class. Let's say you have the match score:

6-5 pen. 2-2 a.e.t. 1-1 (1-0)

Using

``` ruby
require "score/formats"

score = Score.parse( "6-5 pen. 2-2 a.e.t. 1-1 (1-0)" )
score.ht  #=> [1,0]
score.ft  #=> [1,1]
score.et  #=> [2,2]
score.p   #=> [6,5]
```

you can parse the score into its components, that is, the
half time (ht), full time (ft), extra time (et)
and the penalties (p) shootout score.

Like `Date` you can initialize `Score` with "to-the-metal"
integer numbers e.g.:

``` ruby
score = Score.new( 1, 0, 1, 1, 2, 2, 6, 5 )
score.ht  #=> [1,0]
score.ft  #=> [1,1]
score.et  #=> [2,2]
score.p   #=> [6,5]
```

For now `Score` offers in addition to the read-only `ht`, `ft`, `et`, `p`  accessors some more methods:


Use `ht?`, `ft?`, `et?`, `p?` for checking if the score components are present e.g.

``` ruby
score = Score.new
score.ht?  #=> false
score.ft?  #=> false
score.et?  #=> false
score.p?   #=> false

# -or-

score = Score.parse( "8-2 (4-1)" )
score.ht?  #=> true
score.ft?  #=> true
score.et?  #=> false
score.p?   #=> false
```

Use `to_a` to get an array of score component pairs (or an empty array for none) e.g.

``` ruby
score = Score.parse( "8-2 (4-1)" )
score.to_a  #=> [[4,1], [8-2]]

# -or-
score = Score.parse( "0-0" )
score.to_a  #=> [0,0]
```

Use `values` to get an array of "flat" integer numbers e.g.

``` ruby
score = Score.parse( "6-5 pen. 2-2 a.e.t. 1-1 (1-0)" )
score.values #=> [1,0,1,1,2,2,6,5]
```

Use `to_h` to get a hash with key / value pairs e.g.

``` ruby
score = Score.parse( "6-5 pen. 2-2 a.e.t. 1-1 (1-0)" )
score.to_h #=> { ht: [1,0],
           #     ft: [1,1],
           #     et: [2,2],
           #     p:  [6,5] }

# -or -
score = Score.parse( "8-2 (4-1)" )
score.to_h #=> { ht: [4,1],
           #     ft: [8,2] }
```

Use the `:db` format to get a hash with "flat" key / value pairs e.g.

``` ruby
score = Score.parse( "6-5 pen. 2-2 a.e.t. 1-1 (1-0)" )
score.to_h( :db ) #=> { score1i:  1, score2i:  0,
                  #     score1:   1, score2:   1,
                  #     score1et: 2, score2et: 2,
                  #     score1p:  6, score2p:  5 }

# -or -
score = Score.parse( "8-2 (4-1)" )
score.to_h( :db ) #=> { score1i:  4,   score2i:  1,
                  #     score1:   8,   score2:   2,
                  #     score1et: nil, score2et: nil,
                  #     score1p:  nil, score2p:  nil}
```

Use `to_s` to pretty print / get the score (as string) e.g.

``` ruby
score = Score.new( 1, 0, 1, 1, 2, 2, 6, 5 )
score.to_s #=> "6-5 pen. 2-2 a.e.t. 1-1 (1-0)"

# -or -

score = Score.new( 0, 0, 0, 0 )
score.to_s #=> "0-0"

# -or -

score = Score.new
score.to_s #=> "-"
```



## Bonus: Multi-language internationalization (i18n) support

_Sprichst du Deutsch? • ¿Hablas español? • Parles tu français?_

Using the `lang` option you can switch the language.
For now only `de`, that is, German (Deutsch) is built-in / supported.
Example:

``` ruby
score = Score.parse( "2:2 (1:1, 1:0) n.V. 6:5 i.E.", lang: "de" )
score.ht  #=> [1,0]
score.ft  #=> [1,1]
score.et  #=> [2,2]
score.p   #=> [6,5]
```

That's all for now.




## Installation

Use

    gem install score-formats

or add the gem to your Gemfile

    gem 'score-formats'



## License

The `score-formats` scripts are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.


## Questions? Comments?

Send them along to the
[Open Sports & Friends Forum/Mailing List](http://groups.google.com/group/opensport).
Thanks!
