# encoding: utf-8

require 'sportdb/formats'


###
# our own code
require 'sportdb/match/formats/version' # let version always go first
require 'sportdb/match/formats/mapper'
require 'sportdb/match/formats/mapper_teams'
require 'sportdb/match/formats/match_parser'
require 'sportdb/match/formats/match_parser_auto_conf'



puts SportDb::MatchFormats.banner   # say hello
