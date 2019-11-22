# sportdb - sport.db Command Line Tool


<!--
[![Build Status](https://secure.travis-ci.org/geraldb/sport.db.ruby.png?branch=master)](http://travis-ci.org/geraldb/sport.db.ruby)
-->

* home  :: [github.com/sportdb/sport.db](https://github.com/sportdb/sport.db)
* bugs  :: [github.com/sportdb/sport.db/issues](https://github.com/sportdb/sport.db/issues)
* gem   :: [rubygems.org/gems/sportdb](https://rubygems.org/gems/sportdb)
* rdoc  :: [rubydoc.info/gems/sportdb](http://rubydoc.info/gems/sportdb)
* forum :: [groups.google.com/group/opensport](https://groups.google.com/group/opensport)


## Usage

The sportdb tool lets you read in (parse) datasets (e.g. leagues, clubs, match schedules, etc.) 
in plain text into your sports SQL database of choice (e.g. SQLite, PostgreSQL, etc.)

```
SYNOPSIS
    sportdb [global options] command [command options] [arguments...]

VERSION
    2.0

GLOBAL OPTIONS
    -d, --dbpath=PATH - Database path (default: .)
    -n, --dbname=NAME - Database name (default: sport.db)
    --verbose         - (Debug) Show debug messages
    --version         - Show version

COMMANDS
    new, n        - Build DB w/ quick starter Datafile templates
    build, b      - Build DB (download/create/read); use ./Datafile - zips get downloaded to ./tmp
    serve, server - Start web service (HTTP JSON API)

MORE COMMANDS    
    create        - Create DB schema
    download, dl  - Download datasets; use ./Datafile - zips get downloaded to ./tmp
    read, r       - Read datasets; use ./Datafile - zips required in ./tmp
    logs          - Show logs
    props         - Show props
    stats         - Show stats
    test          - (Debug) Test command suite
    help          - Shows a list of commands or help for one command
```


### `new` Command

```
NAME
    new - Build DB w/ quick starter Datafile templates
SYNOPSIS
    sportdb [global options] new NAME

EXAMPLES
    sportdb new eng2019-20
    sportdb new eng
```


### `build` Command

```
NAME
    build - Build DB (download/create/read); use ./Datafile - zips get downloaded to ./tmp

SYNOPSIS
    sportdb [global options] build

EXAMPLES
    sportdb build
```


### `serve` Command

```
NAME
    serve - Start web service (HTTP JSON API)

SYNOPSIS
    sportdb [global options] serve

EXAMPLES
    sportdb serve
```


## Install

Just install the gem:

    $ gem install sportdb



## More Documentation / Getting Started Guides

See the **[football.db League Starter Sample - Mauritius Premier League](https://github.com/openfootball/league-starter)**
if you want to start from scratch (zero) with your very own league.

See the **[football.db Quick Starter Datafile Templates](https://github.com/openfootball/quick-starter)** if you want to read in ready-to-use /
ready-to-fork packages incl. the English Premier League, the German
Bundesliga, the Spanish Primera División and some more.



## License

![](https://publicdomainworks.github.io/buttons/zero88x31.png)

The `sportdb` scripts are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.


## Questions? Comments?

Send them along to the
[Open Sports & Friends Forum/Mailing List](http://groups.google.com/group/opensport).
Thanks!
