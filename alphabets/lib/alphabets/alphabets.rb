
class Alphabet

##  "simple" unaccent (remove accents/diacritics and unfold ligatures) translation table / mapping
UNACCENT = Reader.parse( <<TXT )
    Ä A   ä a
    Á A   á a
    À A   à a
    Ã A   ã a
    Â A   â a
    Å A   å a
    Æ AE  æ ae   # ae ligature
          ā a
          ă a
    Ą A   ą a    # ą - U+0105 (261) - LATIN SMALL LETTER A WITH OGONEK

    Ç C   ç c    # ç - U+00E7 (231) - LATIN SMALL LETTER C WITH CEDILLA
    Ć C   ć c
    Č C   č c

    Ď D   ď d
    Ð D   ð d    # iceland - d

    É E   é e
    È E   è e
    Ê E   ê e
    Ë E   ë e
          ė e
    Ę E   ę e
    Ě E   ě e

          ğ g

    İ I
    Í I   í i
    Ì I   ì i
    Î I   î i
          ī i
          ı i    # ı - U+0131 (305) - LATIN SMALL LETTER DOTLESS I
    Ï I   ï i

    Ł L   ł l

    Ñ N   ñ n
    Ń N   ń n
    Ň N   ň n

    Ö O   ö o
    Ő OE  ő oe    # hungarian - just use O/o  - why? (it's not a ligature) why not?
    Ó O   ó o
    Ò O   ò o
    Õ O   õ o
    Ô O   ô o
          ø o
    Œ OE  œ oe   # oe ligature

    Ř R   ř r

    Ś S   ś s
    Ş S   ş s   # ş - U+015F (351) - LATIN SMALL LETTER S WITH CEDILLA
    Ș S   ș s   # ș - U+0219 (537) - LATIN SMALL LETTER S WITH COMMA BELOW
    Š S   š s
          ß ss  # ß - U+00DF (223) - LATIN SMALL LETTER SHARP S

    Ţ T   ţ t   # ţ - U+0163 (355) - LATIN SMALL LETTER T WITH CEDILLA
    Ț T   ț t   # ț - U+021B (539) - LATIN SMALL LETTER T WITH COMMA BELOW
    Ť T   ť t

    Þ P   þ p   # þ - U+00FE (254) - LATIN SMALL LETTER THORN
                #### fix/check!!!! icelandic - use p is p or th - why? why not?

    Ü U   ü u
    Ú U   ú u
    Ù U   ù u
          ū u
    Ů U   ů u
    Û U   û u

    Ý Y   ý y
    Ÿ Y   ÿ y

    Ź Z   ź z
    Ż Z   ż z
    Ž Z   ž z
TXT

##
# Notes:
#  Romanian did NOT initially get its Ș/ș and Ț/ț (with comma) letters,
#  because these letters were initially unified with Ş/ş and Ţ/ţ (with cedilla)
#  by the Unicode Consortium, considering the shapes with comma beneath
#  to be glyph variants of the shapes with cedilla.
#  However, the letters with explicit comma below were later added to the Unicode standard and are also in ISO 8859-16.


##  de,at,ch translation for umlauts
UNACCENT_DE = Reader.parse( <<TXT )
    Ä AE  ä ae    ### note: Use upcase AE, OE, UE and NOT titlecase Ae, Oe, Ue - why? why not? e.g.VÖST => VOEST or Ö => OE
    Ö OE  ö oe
    Ü UE  ü ue
          ß ss
TXT

  ## add UNACCENT_ES - why? why not?  is Espanyol catalan spelling or spanish (castillian)?
  # 'ñ'=>'ny',    ## e.g. Español => Espanyol

DOWNCASE = %w[A B C D E F G H I J K L M N O P Q R S T U V W X Y Z].reduce({}) do |h,ch|
    h[ch] = ch.downcase
    h
  end.merge( Reader.parse( <<TXT ) )
    Ä ä
    Á á
    À à
    Â â
    Å å
    Æ æ   # LATIN LETTER AE  - ae ligature
    Ą ą
    Ã ã

    Ç ç   # LATIN LETTER C WITH CEDILLA
    Č č
    Ć ć

    Ď ď

    Ð ð    # iceland - d

    É é
    È è
    Ë ë
    Ê ê
    Ę ę
    Ě ě

    İ i
    Í í
    Ì ì
    Ï ï
    Î î

    Ł ł

    Ń ń
    Ň ň
    Ñ ñ

    Ö ö
    Ő ő
    Œ œ   # LATIN LIGATURE OE
    Ó ó
    Ò ò
    Ô ô
    Õ õ

    Þ þ    # iceland - p

    Ř ř

    Ś ś
    Ş ş   # LATIN LETTER S WITH CEDILLA
    Ș ș   # LATIN LETTER S WITH COMMA BELOW
    Š š

    Ţ ţ   # LATIN LETTER T WITH CEDILLA
    Ț ț   # LATIN LETTER T WITH COMMA BELOW
    Ť ť

    Ü ü
    Ú ú
    Ù ù
    Ů ů
    Û û

    Ý ý
    Ÿ ÿ

    Ž ž
    Ż ż
    Ź ź
TXT

end  # class Alphabet
