# Notes


## text parsing notes

- [ ]  allow space before quote - why? why not?
       - UDI'19/Beter Bed     -- yes, works
       - UDI '19/Beter Bed    -- allow/support - yes/no?   (confusion with '19 minute??)


- [ ]  v/vs/v./vs.  - support all versus variants - why? why not?
       - remove  v./vs. variants - avoids confusion with Carlos V. etc.
       - only allow downcase - why? why not?
       - for now V/VS/V./VS.  supported tooo!!!!
         - V. Köln, Carlos V. etc.

=>  try only v/vs in downcase/lowercase only - why? why not?



## regex notes

```
(?=X)	Positive lookahead	"Ruby"[/.(?=b)/] #=> "u"
(?!X)	Negative lookahead	"Ruby"[/.(?!u)/] #=> "u"
(?<=X)	Positive lookbehind	"Ruby"[/(?<=u)./] #=> "b"
(?<!X)	Negative lookbehind	"Ruby"[/(?<!R|^)./] #=> "b"

  see https://idiosyncratic-ruby.com/11-regular-extremism.html
```


