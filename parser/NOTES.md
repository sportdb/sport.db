#  Parser (World Service) Experiments  w/ racc 


## todos

- [ ]  add a new BLANK token for blank lines (instead of NEWLINE)!!!
         make sure empty / blank lines get passed through (by outline parser!!)
         and always RESET tokenize_line to "standard" (regex) mode on BLANK!!!  


- [ ]  use "old" tokenizer pattern match
         and 1) change  text vs text  to  team vs team
         and 2) change  text minute   to  player minute!!!!


- [ ]  split parser into def sections (e.g. group def/rouund def) 
           and  body - why? why not?

- [ ]   merge o.g. and pen. into goal_minutes regex
          AND handle in tokenizer (as one terminal) - why? why not?

- [ ]   rework minutes rule;
        break into goal_minutes and "classic" minutes (for reuse),
          that is, no o.g. or pen. etc.

- [ ]   cards - check options for yellow-red card
           use YR or such - why? why not? or Y/R or ???

- [ ]  add a new match NAME_WITH_MINUTE regex
         to switch into GOALS mode!!
           break out with end-of-line / newline!
       allow continuation with , if last token in line!!

- [ ]  use same "trick" of , if last token in line!!
         for current goal_line

- [ ]  change goal_line tokens to PLAYER/NAME !!!
- [ ]  change generic TEXT vs TEXT tokens in match 
         to TEAM vs TEAM!!!

- [ ]  lineup - maybe change too to "auto-magic" 
           line coninuations with , if last token in line!!
            and remove the dot end of lineup marker requirement;
             use simple NEWLINE instead!!


## "Hard Problems"

Matchday 1    and Messi 24

-  name with minute   or text ?
    how to tell the difference if no minute marker e.g. `24'`??? 


## open (format) questions - discuss

- [ ]   use `()` to auto-switch into name mode (for goals/etc) - why? why not?



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






