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

The sportdb gem lets you load fixtures in plain text into your sports database

```
SYNOPSIS
    sportdb [global options] command [command options] [arguments...]

VERSION
    1.8

GLOBAL OPTIONS
    -d, --dbpath=PATH - Database path (default: .)
    -n, --dbname=NAME - Database name (default: sport.db)
    --verbose         - (Debug) Show debug messages
    --version         - Show version

COMMANDS
    create        - Create DB schema
    setup, s      - Create DB schema 'n' load all world and sports data
    update, up, u - Update all sports data
    load, l       - Load sports fixtures
    logs          - Show logs
    props         - Show props
    pull          - Pull (auto-update) event fixtures from upstream sources  
    serve, server - Start web service (HTTP JSON API)
    stats         - Show stats
    test          - (Debug) Test command suite
    help          - Shows a list of commands or help for one command
```


### `setup` Command

```
NAME
    setup - Create DB schema 'n' load all world and sports data

SYNOPSIS
    sportdb [global options] setup [command options] NAME

COMMAND OPTIONS
    -i, --include=PATH  - Sports data path (default: .)
    --worldinclude=PATH - World data path (default: none)

EXAMPLES
    sportdb setup --include ./at-austria --worldinclude ./world.db
    sportdb setup 2013_14 --include ./at-austria --worldinclude ./world.db
```


### `update` Command

```
NAME
    update - Update all sports data

SYNOPSIS
    sportdb [global options] update [command options] NAME

COMMAND OPTIONS
    --delete           - Delete all sports data records
    -i, --include=PATH - Sports data path (default: .)

EXAMPLES
    sportdb update --include ./at-austria
    sportdb update --include ./at-austria --delete
    sportdb update 2013_14 --include ./at-austria --delete
```

### `load` Command

```
NAME
    load - Load sports fixtures

SYNOPSIS
    sportdb [global options] load [command options] NAME

COMMAND OPTIONS
    --delete - Delete all sports data records

EXAMPLES
    sportdb load --include ./at-austria 2013_14/bl
    sportdb load --include ./at-austria 2013_14/bl 2013_14/cup
```


### `pull` Command

```
NAME
    pull - Pull (auto-update) event fixtures from upstream sources

SYNOPSIS
    sportdb [global options] pull

EXAMPLES
    sportdb pull
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


## License

![](https://publicdomainworks.github.io/buttons/zero88x31.png)

The `sportdb` scripts are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.


## Questions? Comments?

Send them along to the
[Open Sports & Friends Forum/Mailing List](http://groups.google.com/group/opensport).
Thanks!
