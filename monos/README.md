# monos - monorepo / mono source tree tools and (startup) scripts


* home  :: [github.com/sportdb/sport.db](https://github.com/sportdb/sport.db)
* bugs  :: [github.com/sportdb/sport.db/issues](https://github.com/sportdb/sport.db/issues)
* gem   :: [rubygems.org/gems/monos](https://rubygems.org/gems/monos)
* rdoc  :: [rubydoc.info/gems/monos](http://rubydoc.info/gems/monos)
* forum :: [opensport](http://groups.google.com/group/opensport)




## Usage

The `mono` (or short `mo`) command line tool lets you run
git commands on multiple repo(sitories) with a single command.

Add all repo(sitories) to the `monorepo.yml` that you want
to be part of the "virtual" all-in-one / single mono source tree.
Example:

``` yml
####################
#  checkout skripts (auto-update machinery)
yorobot:
- cache.csv      ## incl. self
- sport.db.more
- football.db
- football.csv

###############
#  use latest sportdb machinery (from source)
sportdb:
- sport.db
- sport.db.sources
- football.db

#####################
# football.db - open football
openfootball:
- leagues
- clubs
```


### MOPATH - The monorepo (single source tree) root

Use the `MOPATH` environment variable to set the monorepo (single source tree) root
path. The builtin default for now is `/sites`.




### Commands

`status` • `sync`

### `status` Command

Use the `status` command to check for changes (will use `git status --short`) on all repos. Example:

´´´
$ mono status
$ mono       # status is the default command
$ mo status  # mo is a "shortcut" convenience alias for mono
$ mo stat
$ mo
´´´

resulting in something like:

´´´
2 change(s) in 9 repo(s) @ 3 org(s)

== yorobot@cache.csv - CHANGES:
 M monos/Manifest.txt
 M monos/README.md
 M monos/Rakefile
 M monos/lib/mono/git/status.rb
 M monos/lib/mono/git/sync.rb
 M monos/lib/mono/version.rb
RM monos/lib/monoscript.rb -> monos/lib/monos.rb
 M monos/test/test_base.rb
?? monos/bin/

== yorobot@football.csv - CHANGES:
?? footballdata/
´´´



### `sync` Command

Note:  `install` or `get` or `up` are all aliases that you can use for `sync`.

Note: `moget` is a shortcut convenience command for `mono get` (or, that is, `mono sync`).


Use the `sync` command to sync up (pull) changes (will use `git pull --ff-only`) on all existing repos and `git clone` for new not-yet-cloned repos.

Example:

´´´
$ mono sync
$ mono install    # install is an alias for sync
$ mono get        # get is another alias for sync
$ mo sync         # mo is a "shortcut" convenience alias for mono
$ mo get
$ moget           # moget is a "shortcut" convenience alis for mono get
´´´



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
