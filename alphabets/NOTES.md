# Notes

## Todos


## Terminology

Use Upcase, Downcase AND Titlecase (!)

- Example: Ö  -> Upcase: OE, Downcase: oe, Titlecase: Oe (!)
- Example: Æ  -> Upcase: AE, Downcase: ae, Titlecase: Ae (!)



## Libraries

- <https://github.com/SixArm/sixarm_ruby_unaccent> - Replace a string's accent characters with ASCII characters. Based on Perl Text::Unaccent from CPAN.



## Links

**Unicode w/ Ruby - Ruby ♡ Unicode**

- <https://idiosyncratic-ruby.com/66-ruby-has-character>

Ruby has Character - Ruby comes with good support for Unicode-related features. Read on if you want to learn more about important Unicode fundamentals and how to use them in Ruby...

- <https://idiosyncratic-ruby.com/41-proper-unicoding>

Proper Unicoding - Ruby's Regexp engine has a powerful feature built in: It can match for Unicode character properties. But what exactly are properties you can match for?

- <https://idiosyncratic-ruby.com/30-regex-with-class>

Regex with Class - Ruby's regex engine defines a lot of shortcut character classes. Besides the common meta characters (\w, etc.), there is also the POSIX style expressions and the unicode property syntax. This is an overview of all character classes


**W3C**

- <https://www.w3.org/TR/charmod-norm/>
- <https://www.w3.org/International/wiki/Case_folding>

In Western European languages, the letter 'i' (U+0069) upper cases to a dotless 'I' (U+0049). In Turkish, this letter upper cases to a dotted upper case letter 'İ' (U+0130). Similarly, 'I' (U+0049) lower cases to 'ı' (U+0131), which is a dotless lowercase letter i.