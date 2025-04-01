# Notes


biggie:
- (re)use text files in /leagues; do NOT duplicate
- workaround for now; export two .csv datasets
- use a (sqlite) database AND use the structs in the sportdb-structs gem!!!



## TODOs

- [ ]  use a new leagues gem - breakout from timezones!!!!
         - depends on sportdb-structs (like fifa - uses country; leagues - uses league struct AND country (fifa) - why? why not?)
         -   do NOT use a (sqlite) database for now - why? why not?
         -   check/use League/LeaguePeriod structs - why? why not?
         -   use new LeagueCode  with LeaguePeriod entry? 


- [ ]  change (canonical reference) league keys to league code e.g. eng.1, eng.2, etc.
         - use tier 1|2|3 to keep code generic and "independent" of name changes
                  e.g. Super League, Premier League, Bundesliga, etc. 
         - use league key for key derived from name e.g. eng_premierleague or such
                key might be anything and change 

- [ ]  build a league (lookup) index 
         (1a) lookup by canonical code
         (1b) lookup by canonical code AND alt codes
- [ ]  build/generate a SUMMARY page (like in fifa for countries)

- [ ]  maybe bundle-up leagues index into a leagues gem or such - why? why not?



more

```
- [ ]  league codes
        -  incl. country (domestic) or no country (intl), clubs or national teams,
        -   alt codes  (by season begin/end or start/end??)

- [ ]  use without (sqlite) db - why? why not?
```
