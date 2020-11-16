# Notes


## Todos / Ideas

- [ ] add -e --environment switch / option
      for switching dev and "production" mode (load source or gems) or such - why? why not?


## Usage

``` ruby
$LOAD_PATH.unshift( "/Sites/..." )
require 'sportdb/setup'
SportDb::Boot.setup

puts
puts "SportDb::Boot.root: #{SportDb::Boot.root}"
puts "SPORTDB_DIR:        #{SportDb::Boot.root}/sportdb"
puts "OPENFOOTBALL_DIR:   #{SportDb::Boot.root}/openfootball"
```


For local test run try:

```
$ ruby sandbox/test_boot.rb
```


