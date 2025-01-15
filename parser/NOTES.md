#  Parser (World Service) Experiments  w/ racc 


## What's News? / What's Different?


- [ ]  change :num (e.g. (1), (2), ..)  to :ord  (for ordinal number)
       - keep :num in reserve for latter for number without ()

- [ ]  change :vs  to only include  v  (NO more variants e.g. vs. VS. V VS etc.)


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


## More

When the parser calls `next_token` on the tokenizer, 
it expects a two element array or a nil to be returned. 
The first element of the array must contain the name of the token, 
and the second element can be anything (but most people just add the matched text). 
When a nil is returned, that indicates there are no more tokens 
left in the tokenizer.

- <https://practicingruby.com/articles/parsing-json-the-hard-way>
- <https://martinfowler.com/bliki/HelloRacc.html>






