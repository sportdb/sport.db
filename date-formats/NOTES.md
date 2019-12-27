# Date (and Time) Formats


## Regex / Patterns

###  Word boundary `\b` 

WARNING - Word boundary `\b` does NOT work for non-latin alphabets
The word boundary test `\b` checks that there should be `\w` on the one side from the position 
and "not `\w`" – on the other side.

But `\w` means a latin letter a-z (or a digit or an underscore), so the test does NOT work for other characters, 
e.g. cyrillic letters or hieroglyphs.


## More Formats

### Brazil

```
[Sáb, 13/Maio]
[Dom, 14/Maio]
[Seg, 15/Maio]
[Sáb, 20/Maio]
[Dom, 21/Maio]
[Seg, 22/Maio]
[Sáb, 27/Maio]
[Dom, 28/Maio]
[Seg, 29/Maio]
[Sáb, 03/Junho]
[Dom, 04/Junho]
[Seg, 05/Junho]
[Ter, 06/Junho]
[Qua, 07/Junho]
[Qui, 08/Junho]
[Sáb, 10/Junho]
[Dom, 11/Junho]
[Seg, 12/Junho]
[Qua, 14/Junho]
[Qui, 15/Junho]
[Sáb, 17/Junho]
[Dom, 18/Junho]
[Seg, 19/Junho]
[Qua, 21/Junho]
[Qui, 22/Junho]
[Sáb, 24/Junho]
Dom, 25/Junho
Seg, 26/Junho
[Sáb, 01/07]
[Dom, 02/07]
[Seg, 03/07]
[Sáb, 08/07]
[Dom, 09/07]
[Seg, 10/07]
[Qua, 12/07]
[Qui, 13/07]
[Sáb, 15/07]
[Dom, 16/07]
[Seg, 17/07]
[Qua, 19/07]
[Qui, 20/07]
[Sáb, 22/07]
[Dom, 23/07]
[Seg, 24/07]
[Sáb, 29/07]
[Dom, 30/07]
Seg, 31/07
Qua, 09/08
Qua, 02/08
Qui, 03/08
Sáb, 05/08
Dom, 06/08
Sáb, 12/08
```



## Gems / Libraries

- <https://github.com/twitter/twitter-cldr-rb> - uses Unicode's Common Locale Data Repository (CLDR) to format certain types of text into their localized equivalents. Currently supported types of text include dates, times, currencies, decimals, percentages, and symbols.

- <https://github.com/ruby-i18n/ruby-cldr> - library for exporting and using data from Unicode's Common Locale Data Repository (CLDR)



## Date Formats (& More)

### Unicode's Common Locale Data Repository (CLDR)

contains tons of high-quality locale data such as formatting rules for dates, times, numbers, currencies as well as language, country, calendar-specific names etc.

<http://cldr.unicode.org>
