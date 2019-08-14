
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
          ą a

    Ç C   ç c
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
          ı i    # small dotless i

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
    Ş S   ş s
    Š S   š s
          ș s   # U+0219
          ß ss

          ţ t   # U+0163
          ț t   # U+021B

          þ p    #### fix/check!!!! icelandic - use p is p or th - why? why not?

    Ü U   ü u
    Ú U   ú u
          ū u

          ý y

          ź z
          ż z
    Ž Z   ž z
TXT


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
    Æ æ   # ae ligature

    Ç ç
    Č č

    É é

    İ i
    Í í

    Ł ł

    Ö ö
    Œ œ   # oe ligature

    Ś ś
    Ş ş
    Š š

    Ü ü
    Ú ú

    Ž ž
TXT

end  # class Alphabet
