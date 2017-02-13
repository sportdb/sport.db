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

