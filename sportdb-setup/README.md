# sportdb-setup

scripts to bootup sportdb in dev (source) mode from monorepo (single source tree)


## Todos / Ideas

- [ ] add -e --environment switch / option
      for switching dev and "production" mode (load source or gems) or such - why? why not?



## Usage

``` ruby
## add require "mono"  here - why? why not?
##   use Mono.root

$LOAD_PATH.unshift( "/Sites/..." )
require 'sportdb/setup'
SportDb::Boot.setup

puts
puts "SPORTDB_DIR:      #{SPORTDB_DIR}"
puts "OPENFOOTBALL_DIR: #{OPENFOOTBALL_DIR}"
```

For local test run try:

```
$ ruby sandbox/test_boot.rb
```


