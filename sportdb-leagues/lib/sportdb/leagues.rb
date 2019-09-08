# encoding: utf-8


###
# gems / libraries
require 'alphabets'      # downcase_i18n, unaccent, variants, ...


###
#  sport.db gems / libraries
require 'sportdb/countries'



###
# our own code
require 'sportdb/leagues/version' # let version always go first
require 'sportdb/leagues/league'
require 'sportdb/leagues/league_reader'
require 'sportdb/leagues/league_index'


puts SportDb::Leagues.banner   # say hello
