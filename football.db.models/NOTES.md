# Notes


## Format

- Split player stat.cvs in two sections e.g. one for defensive and one for offensive ??

- or use two different files e.g. stats_offensive and stats_definsive (now mostly for GK goalkeepers?)

- how to mark a new header in .csv - use a "document" separator e.g. ---
- or use a comment line e.g. #############

- check if github supports blank lines for .csv rendering? or comments? or multiple headers?
- if not - change extension to .txt ??? (assuming it's a csv2 or csv+ file and NOT classic csv?)


```
Header 1, Header 2, Header 3
1,1,1,1
1,1,11,
New Header, New header 2,
2,2,2,2
2,2,2,2
```


```
############
# defensive
Header 1, Header 2, Header 3
1,1,1,1
1,1,11,

---

############
# offensive
New Header, New header 2,
2,2,2,2
2,2,2,2
```