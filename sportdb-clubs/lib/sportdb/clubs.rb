# encoding: utf-8


###
# gems / libraries
require 'alphabets'      # downcase_i18n, unaccent, variants, ...


###
#  sport.db gems / libraries
require 'sportdb/countries'



###
# our own code
require 'sportdb/clubs/version' # let version always go first
require 'sportdb/clubs/club'
require 'sportdb/clubs/club_reader'
require 'sportdb/clubs/club_index'



puts SportDb::Clubs.banner   # say hello
