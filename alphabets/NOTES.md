# Notes

## Todos


## Terminology

Use Upcase, Downcase AND Titlecase (!)

- Example: Ö  -> Upcase: OE, Downcase: oe, Titlecase: Oe (!)
- Example: Æ  -> Upcase: AE, Downcase: ae, Titlecase: Ae (!)



## Libraries

**Ruby**

- <https://github.com/SixArm/sixarm_ruby_unaccent> - Replace a string's accent characters with ASCII characters. Based on Perl Text::Unaccent from CPAN.

- <https://github.com/fractalsoft/diacritics> - support downcase, upcase and permanent link with diacritical characters

**Perl**

- <https://metacpan.org/pod/Unicode::Diacritic::Strip> - strip diacritics from Unicode text

**JavaScript**

- <https://github.com/dundalek/latinize> -  convert accents (diacritics) from strings to latin characters 

- <https://github.com/tyxla/remove-accents> - removes the accents from a string, converting them to their corresponding non-accented ascii characters


## Links

**Unicode w/ Ruby - Ruby ♡ Unicode**

- <https://idiosyncratic-ruby.com/66-ruby-has-character>

Ruby has Character - Ruby comes with good support for Unicode-related features. Read on if you want to learn more about important Unicode fundamentals and how to use them in Ruby...

- <https://idiosyncratic-ruby.com/41-proper-unicoding>

Proper Unicoding - Ruby's Regexp engine has a powerful feature built in: It can match for Unicode character properties. But what exactly are properties you can match for?

- <https://idiosyncratic-ruby.com/30-regex-with-class>

Regex with Class - Ruby's regex engine defines a lot of shortcut character classes. Besides the common meta characters (\w, etc.), there is also the POSIX style expressions and the unicode property syntax. This is an overview of all character classes


**Unicode**

- <https://unicode.org/reports/tr15/> - Unicode Standard Annex #15 - UNICODE NORMALIZATION FORMS

**W3C**

- <https://www.w3.org/TR/charmod-norm/>
- <https://www.w3.org/International/wiki/Case_folding>

In Western European languages, the letter 'i' (U+0069) upper cases to a dotless 'I' (U+0049). In Turkish, this letter upper cases to a dotted upper case letter 'İ' (U+0130). Similarly, 'I' (U+0049) lower cases to 'ı' (U+0131), which is a dotless lowercase letter i.

**Wikipedia**

- <https://en.wikipedia.org/wiki/Diacritic>

**More**

- [The Absolute Minimum Every Software Developer Absolutely, Positively Must Know About Unicode and Character Sets (No Excuses!)](https://www.joelonsoftware.com/2003/10/08/the-absolute-minimum-every-software-developer-absolutely-positively-must-know-about-unicode-and-character-sets-no-excuses/)
by Joel Spolsky, 2003


## Mappings

Open questions ...

```
 Þ  =>  TH    ???
 þ  =>  th    ???
```


## Alphabets

Add more alphabets... why? why not?


- Portuguese [Â, "abcdefghijklmnopqrstuvwxyzáâãàçéêíóôõú", "ABCDEFGHIJKLMNOPQRSTUVWXYZÁÂÃÀÇÉÊÍÓÔÕÚ"]
- Russian [Щ, Ъ, Э, "абвгдеёжзийклмнопрстуфхцчшщъыьэюя", "АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ"]
- Greek [Β, Μ, Χ, Ω, Ή, Ύ, Ώ, ΐ, ΰ, Ϊ, Ϋ]
- Slovak ["aáäeéiíoóôuúyýbcčdďfghjklĺľmnňpqrŕsštťvwxzž", "AÁÄEÉIÍOÓÔUÚYÝBCČDĎFGHJKLĹĽMNŇPQRŔSŠTŤVWXZŽ"]
- Italian ["aàbcdeèéfghiìíîlmnoòópqrstuùúvz", "AÀBCDEÈÉFGHIÌÍÎLMNOÒÓPQRSTUÙÚVZ"]
- Romanian ["aăâbcdefghiîjklmnopqrsștțuvwxyz", "AĂÂBCDEFGHIÎJKLMNOPQRSȘTȚUVWXYZ"]
- Danish [å, â, ô, Å, Â, Ô]

```
    def de
      { # German
        downcase:  %w(ä ö ü ß),
        upcase:    %w(Ä Ö Ü ẞ),
        permanent: %w(ae oe ue ss)
      }
    end

    def pl
      { # Polish
        downcase:  %w(ą ć ę ł ń ó ś ż ź),
        upcase:    %w(Ą Ć Ę Ł Ń Ó Ś Ż Ź),
        permanent: %w(a c e l n o s z z)
      }
    end

    def cs
      { # Czech uses acute (á é í ó ú ý), caron (č ď ě ň ř š ť ž), ring (ů)
        # aábcčdďeéěfghiíjklmnňoópqrřsštťuúůvwxyýzž
        # AÁBCČDĎEÉĚFGHIÍJKLMNŇOÓPQRŘSŠTŤUÚŮVWXYÝZŽ
        downcase:  %w(á é í ó ú ý č ď ě ň ř š ť ů ž),
        upcase:    %w(Á É Í Ó Ú Ý Č Ď Ě Ň Ř Š Ť Ů Ž),
        permanent: %w(a e i o u y c d e n r s t u z)
      }
    end

    def fr
      { # French
        # abcdefghijklmnopqrstuvwxyzàâæçéèêëîïôœùûüÿ
        # ABCDEFGHIJKLMNOPQRSTUVWXYZÀÂÆÇÉÈÊËÎÏÔŒÙÛÜŸ
        downcase:  %w(à â é è ë ê ï î ô ù û ü ÿ ç œ æ),
        upcase:    %w(À Â É È Ë Ê Ï Î Ô Ù Û Ü Ÿ Ç Œ Æ),
        permanent: %w(a a e e e e i i o u u ue y c oe ae)
      }
    end

    def it
      { # Italian
        downcase:  %w(à è é ì î ò ó ù),
        upcase:    %w(À È É Ì Î Ò Ó Ù),
        permanent: %w(a e e i i o o u)
      }
    end

    def eo
      { # Esperantohas the symbols ŭ, ĉ, ĝ, ĥ, ĵ and ŝ
        downcase:  %w(ĉ ĝ ĥ ĵ ŝ ŭ),
        upcase:    %w(Ĉ Ĝ Ĥ Ĵ Ŝ Ŭ),
        permanent: %w(c g h j s u)
      }
    end

    def is
      { # Iceland
        downcase:  %w(ð þ),
        upcase:    %w(Ð Þ),
        permanent: %w(d p)
      }
    end

    def pt
      { # Portugal uses á, â, ã, à, ç, é, ê, í, ó, ô, õ and ú
        downcase:  %w(ã ç),
        upcase:    %w(Ã Ç),
        permanent: %w(a c)
      }
    end

    def sp
      { # Spanish
        downcase:  ['ñ', 'õ', '¿', '¡'],
        upcase:    ['Ñ', 'Õ', '¿', '¡'],
        permanent: ['n', 'o', '', '']
      }
    end

    def hu
      { # Hungarian
        downcase:  %w(ő),
        upcase:    %w(Ő),
        permanent: %w(oe)
      }
    end

    def nn
      { # Norwegian
        downcase:  %w(æ å),
        upcase:    %w(Æ Å),
        permanent: %w(ae a)
      }
    end
```
