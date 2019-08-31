
class Alphabet

##  "simple" unaccent (remove accents/diacritics and unfold ligatures) translation table / mapping
UNACCENT = Reader.parse( <<TXT )
    Ä A   ä a
    Á A   á a
          à a
          ã a
          â a
    Å A   å a
    Æ AE  æ ae   # ae ligature
          ā a
          ă a
          ą a    # ą - U+0105 (261) - LATIN SMALL LETTER A WITH OGONEK

    Ç C   ç c    # ç - U+00E7 (231) - LATIN SMALL LETTER C WITH CEDILLA
          ć c
    Č C   č c

    É E   é e
          è e
          ê e
          ë e
          ė e
          ę e

          ğ g

    İ I
    Í I   í i
          î i
          ī i
          ı i    # ı - U+0131 (305) - LATIN SMALL LETTER DOTLESS I

    Ł L   ł l

          ñ n
          ń n
          ň n

    Ö O   ö o
          ó o
          õ o
          ô o
          ø o
          ő o
    Œ OE  œ oe   # oe ligature

          ř r

    Ś S   ś s
    Ş S   ş s   # ş - U+015F (351) - LATIN SMALL LETTER S WITH CEDILLA
    Ș S   ș s   # ș - U+0219 (537) - LATIN SMALL LETTER S WITH COMMA BELOW
    Š S   š s
          ß ss  # ß - U+00DF (223) - LATIN SMALL LETTER SHARP S

    Ţ t   ţ t   # ţ - U+0163 (355) - LATIN SMALL LETTER T WITH CEDILLA
    Ț t   ț t   # ț - U+021B (539) - LATIN SMALL LETTER T WITH COMMA BELOW

          þ p   # þ - U+00FE (254) - LATIN SMALL LETTER THORN
                #### fix/check!!!! icelandic - use p is p or th - why? why not?

    Ü U   ü u
    Ú U   ú u
          ū u

          ý y

          ź z
          ż z
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
    Å å
    Æ æ   # LATIN LETTER AE  - ae ligature

    Ç ç   # LATIN LETTER C WITH CEDILLA
    Č č

    É é

    İ i
    Í í

    Ł ł

    Ö ö
    Œ œ   # LATIN LIGATURE OE

    Ś ś
    Ş ş   # LATIN LETTER S WITH CEDILLA
    Ș ș   # LATIN LETTER S WITH COMMA BELOW
    Š š

    Ţ ţ   # LATIN LETTER T WITH CEDILLA
    Ț ț   # LATIN LETTER T WITH COMMA BELOW

    Ü ü
    Ú ú

    Ž ž
TXT

end  # class Alphabet
