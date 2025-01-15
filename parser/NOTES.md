#  Parser (World Service) Experiments  w/ racc 


## What's News? / What's Different?


- [ ]  change :num (e.g. (1), (2), ..)  to :ord  (for ordinal number)
       - keep :num in reserve for latter for number without ()

- [ ]  change :vs  to only include  v  (NO more variants e.g. vs. VS. V VS etc.)




## More

When the parser calls `next_token` on the tokenizer, 
it expects a two element array or a nil to be returned. 
The first element of the array must contain the name of the token, 
and the second element can be anything (but most people just add the matched text). 
When a nil is returned, that indicates there are no more tokens 
left in the tokenizer.

- <https://practicingruby.com/articles/parsing-json-the-hard-way>
- <https://martinfowler.com/bliki/HelloRacc.html>






