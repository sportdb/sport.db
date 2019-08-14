# encoding: utf-8

require 'pp'


###
# our own code
require 'alphabets/version' # let version always go first
require 'alphabets/reader'
require 'alphabets/alphabets'
require 'alphabets/utils'
require 'alphabets/variants'



## add "global" convenience helper
def downcase_i18n( name )
  Alphabet.downcase_i18n( name )
end

def unaccent( name )
  Alphabet.unaccent( name )   ## using "default" language character mapping / table
end

def undiacritic( name ) unaccent( name ); end    ## alias for unaccent



def variants( name )    ## todo/check: rename to unaccent_variants or unaccent_names - why? why not?
  Variant.find( name )
end


## add convenience aliases - also add Alpha - why? why not?
Abc       = Alphabet
Alphabets = Alphabet
Alpha     = Alphabet


puts Alphabet.banner   # say hello
