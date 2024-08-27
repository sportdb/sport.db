# sportdb-quick - football.txt (quick) match readers and more




## Usage


``` ruby
require 'sportdb/quick'


# path = "./euro/2024--germany/euro.txt"
path =  "./deutschland/2024-25/1-bundesliga.txt"

matches = SportDb::QuickMatchReader.read( path )
pp matches

#  try json for matches
data = matches.map {|match| match.as_json }
pp data
```


