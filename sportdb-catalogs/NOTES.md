# Notes


```
old gem deps were.
  - fifa >= 2020.5.18
  - footballdb-clubs >= 2020.7.7
  - footballdb-leagues >= 2020.7.7
  - sportdb-formats >= 1.1.3

new gem deps:
   - sportdb-formats
   - sqlite3
   - footballdb-data  (clubs & leagues & world countries)


- [ ] add back FIFA gem - why? why not?
```



```
search club with or without unaccent to normalize ???
 no match - retry with unaccented variant if different
        e.g. example is Preussen Münster  (with mixed accent and unaccented letters) that would go unmatched for now
         Preussen Münster => preussenmünster (norm) 
                           => preussenmunster (norm+unaccent)
    
      todo/fix - make always use norm+unaccent ?? rebuild names
                          always add all unaccent veriants  -  why? why not?
```


