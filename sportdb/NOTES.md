# Notes 'n' Tips


## Usage in Console / Interactive Shell


Try the built-in console script. In your interactive Ruby shell type:

    >> require 'sportdb/console'
    # => Welcome to sport.db, version 1.9.7 (world.db, version 1.9.3)!

This will try to connect to the `sport.db` SQLite database in your working folder.
To get started try some queries, for example:

    >> Team.count
    # => 157
    >> t = Team.find_by_key( 'barcelona' )
    # => ...

and so on.



## Todo / Fix

```
before sportdb/service
sportdb-service/0.4.0 on Ruby 2.3.3 (2016-11-21) [i386-mingw32]
after auto-load (require) sportdb addons
sportdb/2.1.1 on Ruby 2.3.3 (2016-11-21) [i386-mingw32]
sportdb/2.1.1 on Ruby 2.3.3 (2016-11-21) [i386-mingw32]
[debug] Executing serve
working directory:     /sites/tmp/sportdb/mauritius
Connecting to db using settings:
{:adapter=>"sqlite3", :database=>"./sport.db"}
before add middleware ConnectionManagement

*** error: uninitialized constant SportDb::Service::Server
/gems/sportdb-2.1.1/lib/sportdb/cli/main.rb:209:in `block (2 levels) in <class:Toolii>'
/gems/gli-2.16.1/lib/gli/command_support.rb:131:in `execute'
/gems/gli-2.16.1/lib/gli/app_support.rb:296:in `block in call_command'
/gems/2.3.0/gems/gli-2.16.1/lib/gli/app_support.rb:309:in `call_command'
/gems/2.3.0/gems/gli-2.16.1/lib/gli/app_support.rb:83:in `run'
/gems/sportdb-2.1.1/lib/sportdb/cli/main.rb:16:in `run'
/gems/sportdb-2.1.1/lib/sportdb.rb:26:in `main'
/gems/sportdb-2.1.1/bin/sportdb:5:in `<top (required)>'
/bin/sportdb:22:in `load'
/bin/sportdb:22:in `<main>'

SportDb::Service::VERSION
#=> "0.4.0"
SportDb::Service::Server
#=> NameError: uninitialized constant SportDb::Service::Server
SportDb::Service.constants
=> [:VERSION]
```
