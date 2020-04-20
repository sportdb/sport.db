# Notes

## Todos


todo/fix:  use config / configurations; remove all globals e.g.:
- COUNTRIES
- CLUBS
- LEAGUES !!!!!



fix/todo: move find_league  to sportdb-league index use find_by! and find_by !!!!
in sportdb-readers (and others?)

```
def self.find_league( name )
  league = nil
  m = config.leagues.match( name )
  # pp m

  if m.nil?
    puts "** !!! ERROR !!! no league match found for >#{name}<, add to leagues table; sorry"
    exit 1
  elsif m.size > 1
    puts "** !!! ERROR !!! ambigious league name; too many leagues (#{m.size}) found:"
    pp m
    exit 1
  else
    league = m[0]
  end

  league
end
```
