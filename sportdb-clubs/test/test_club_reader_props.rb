# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_club_reader_props.rb


require 'helper'

class TestClubPropsReader < MiniTest::Test

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

  CLUBS = SportDb::Import.catalog.clubs

  def test_parse
    SportDb::Import::ClubPropsReader.parse( ENG_CLUBS_PROPS_TXT )

    m = CLUBS.match( 'Chelsea FC' )
    club = m[0]
    assert_equal 'chelsea',     club.key
    assert_equal 'Chelsea FC',  club.name
    assert_equal 'CHE',         club.code

    m = CLUBS.match( 'Arsenal FC' )
    club = m[0]
    assert_equal 'arsenal',     club.key
    assert_equal 'Arsenal FC',  club.name
    assert_equal 'ARS',         club.code
  end  # method test_parse

end # class TestClubPropsProps
