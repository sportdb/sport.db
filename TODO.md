# TODOs


## Gems / libs to push publish

- [ ] sportdb-langs
  - up pt.yml
- [ ] sportdb-formats
  - up csv match parser
- [ ] sportdb-readers
  - fix br - is pt!


## More

[ ] remove warning for event w/o defined fixtures

    [info] parsing data 'world-cup!/2010/cup' (../openfootball/world-cup/2010/cup.yml)...
    [warn] no fixtures found for event - >world-cup!/2010/cup<; assume fixture name is the same as event

[ ] remove warning for "unknown" fixtures attribute

    [error] unknown event attrib fixtures; skipping attrib


[x] allow results with two digits e.g. 10-0  - Spain - Thaiti in Confeds Cup! it is possible

[x] add support for predefined matchdays for groups and autocomplete of matchday for group stage (by date range lookup)
    try championsliga or copa libertadores for example events

### command line

- [ ] move/fold sport.db.console into sport.db.ruby - use lib/sportdb/console.rb (see worlddb)
- [ ] move/fold sport.db.keys into sport.db.ruby  - why? why not??
