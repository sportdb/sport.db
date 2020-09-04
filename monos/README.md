# monos - monorepo / mono source tree tools and (startup) scripts


* home  :: [github.com/sportdb/sport.db](https://github.com/sportdb/sport.db)
* bugs  :: [github.com/sportdb/sport.db/issues](https://github.com/sportdb/sport.db/issues)
* gem   :: [rubygems.org/gems/monos](https://rubygems.org/gems/monos)
* rdoc  :: [rubydoc.info/gems/monos](http://rubydoc.info/gems/monos)
* forum :: [opensport](http://groups.google.com/group/opensport)




## Usage

The `mono` (or short `mo`) command line tool lets you run
git commands on multiple repo(sitories) with a single command.



### Setup

#### 1) The monorepo (single source tree) root - `MOPATH`

Use the `MOPATH` environment variable to set the monorepo (single source tree) root
path. The builtin default for now is `/sites`.

#### 2) The configuration / manifest file to list all repos - `monorepo.yml`


Add all repo(sitories) to the `monorepo.yml` that you want
to be part of the "virtual" all-in-one / single mono source tree
in your project. Example:

``` yaml
sportdb:
- sport.db
- sport.db.sources
- football.db

yorobot:
- cache.csv
- sport.db.more
- football.db
- football.csv

openfootball:
- leagues
- clubs
```



### Commands

`status` • `fetch` • `sync` • `run` •`env`

### `status` Command

Use the `status` command to check for changes (will use `git status --short`) on all repos. Example:

```
$ mono status
$ mono       # status is the default command
$ mo status  # mo is a "shortcut" convenience alias for mono
$ mo stat
$ mo
```

resulting in something like:

```
2 change(s) in 9 repo(s) @ 3 org(s)

-- sportdb@sport.db - CHANGES:
 M monos/Manifest.txt
 M monos/README.md
 M monos/Rakefile
 M monos/lib/mono/git/status.rb
 M monos/lib/mono/git/sync.rb
 M monos/lib/mono/version.rb
RM monos/lib/monoscript.rb -> monos/lib/monos.rb
 M monos/test/test_base.rb
?? monos/bin/

-- yorobot@football.csv - CHANGES:
?? footballdata/
```


### `fetch` Command

Use the `fetch` command to fetch all (remote) changes (will use `git fetch`) on all existing repos and warn about not-yet-cloned repos. Example:

```
$ mono fetch
$ mo fetch         # mo is a "shortcut" convenience alias for mono
```



### `sync` Command


Use the `sync` command to sync up (pull) changes (will use `git pull --ff-only`) on all existing repos and `git clone` for new not-yet-cloned repos. Example:

```
$ mono sync
$ mono install    # install is an alias for sync
$ mono get        # get is another alias for sync
$ mo sync         # mo is a "shortcut" convenience alias for mono
$ mo get
```

Note:  `install` or `get` or `up` are all aliases that you can use for `sync`.


### `run` Command

Use the `run` command to run any command in all repos. Example:

```
$ mono run git ls-files
$ mono exec git ls-files   # exec is an alias for run
$ mo run git ls-files      # mo is a "shortcut" convenience alias for mono
$ mo exec git ls-files

# -or-

$ mono run tree
$ mono exec tree
$ mo run tree
$ mo exec tree
```

Note: `exec` is an alias that you can use for `run`.



### `env` Command

Use the `env` command to check your `mono` environment setup.


That's all for now.



## Installation

Use

    gem install monos


## License

The `monos` scripts are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.


## Questions? Comments?

Send them along to the
[Open Sports & Friends Forum/Mailing List](http://groups.google.com/group/opensport).
Thanks!
