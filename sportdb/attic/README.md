## Usage

The sportdb gem lets you load fixtures in plain text into your sports database

```

COMMANDS
    setup, s      - Create DB schema 'n' load all world and sports data
    update, up, u - Update all sports data
    load, l       - Load sports fixtures
    pull          - Pull (auto-update) event fixtures from upstream sources  
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
