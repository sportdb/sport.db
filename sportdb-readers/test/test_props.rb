# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_props.rb


require 'helper'

class TestProps < MiniTest::Test

  ENG_CLUBS_PROPS_TXT =<<TXT
####################################
# English League Teams
#
#  note: three letter codes (tags) taken from official premierleague.com site

Key,           Name,                    Code
chelsea,       Chelsea FC,              CHE
arsenal,       Arsenal FC,              ARS
tottenham,     Tottenham Hotspur,       TOT
westham,       West Ham United,         WHU
crystalpalace, Crystal Palace,          CRY
manutd,        Manchester United,       MUN
mancity,       Manchester City,         MCI
TXT

  def test_parse_csv
    recs = parse_csv( ENG_CLUBS_PROPS_TXT )
    pp recs

    assert_equal [{ key: 'chelsea', name: 'Chelsea FC', code: 'CHE' },
                  { key: 'arsenal', name: 'Arsenal FC', code: 'ARS' }], recs[0..1]
  end


  def test_parse
    SportDb.connect( adapter: 'sqlite3', database: ':memory:' )
    SportDb.create_all   ## build schema

    ## turn on logging to console
    ActiveRecord::Base.logger = Logger.new(STDOUT)

    SportDb::Import::ClubPropsReader.parse( ENG_CLUBS_PROPS_TXT )
  end  # method test_parse

end # class TestProps
