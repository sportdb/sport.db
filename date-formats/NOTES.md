# Date (and Time) Formats


## Regex / Patterns

###  Word boundary `\b`

WARNING - Word boundary `\b` does NOT work for non-latin alphabets
The word boundary test `\b` checks that there should be `\w` on the one side from the position
and "not `\w`" – on the other side.

But `\w` means a latin letter a-z (or a digit or an underscore), so the test does NOT work for other characters,
e.g. cyrillic letters or hieroglyphs.


## More Formats

Add here



## Gems / Libraries

- <https://github.com/twitter/twitter-cldr-rb> - uses Unicode's Common Locale Data Repository (CLDR) to format certain types of text into their localized equivalents. Currently supported types of text include dates, times, currencies, decimals, percentages, and symbols.

- <https://github.com/ruby-i18n/ruby-cldr> - library for exporting and using data from Unicode's Common Locale Data Repository (CLDR)



## Date Formats (& More)

### Unicode's Common Locale Data Repository (CLDR)

contains tons of high-quality locale data such as formatting rules for dates, times, numbers, currencies as well as language, country, calendar-specific names etc.

<http://cldr.unicode.org>
