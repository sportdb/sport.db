require 'pp'

###
## see https://github.com/seattlerb/hoe/blob/master/lib/hoe.rb
def intuit_values( input )
  readme = input
             .lines
             .chunk { |l| l[/^(?:=+|#+)/] || "" }
             .map(&:last)
             .each_slice(2)
             .map { |k, v|
                kp = k.join

                puts "------"
                puts "kp: >#{kp}<"
                puts "v: >#{v}< : #{v.class.name}"


                kp = kp.strip.chomp(":").split.last.downcase if k.size == 1
                [kp, v.join.strip]
              }
             .to_h
end


## text = File.open( 'monos/README.md', 'r:utf-8' ) {|f| f.read }

text =<<TXT
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

`status` • `sync` • `env`

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



### `sync` Command


Use the `sync` command to sync up (pull) changes (will use `git pull --ff-only`) on all existing repos and `git clone` for new not-yet-cloned repos. Example:

```
$ mono sync
$ mono install    # install is an alias for sync
$ mono get        # get is another alias for sync
$ mo sync         # mo is a "shortcut" convenience alias for mono
$ mo get
$ moget           # moget is a "shortcut" convenience alis for mono get
```

Note:  `install` or `get` or `up` are all aliases that you can use for `sync`.

Note: `moget` is a shortcut convenience command for `mono get` (or, that is, `mono sync`).



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



TXT


pp intuit_values( text )