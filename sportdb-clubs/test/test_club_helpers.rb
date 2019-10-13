# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_club_helpers.rb


require 'helper'

class TestClubHelpers < MiniTest::Test

  def strip_lang( name ) SportDb::Import::Club.strip_lang( name ); end
  def strip_year( name ) SportDb::Import::Club.strip_year( name ); end
  def strip_norm( name ) SportDb::Import::Club.strip_norm( name ); end
  def strip_wiki( name ) SportDb::Import::Club.strip_wiki( name ); end


  def test_lang
    assert_equal 'Bayern Munich', strip_lang( 'Bayern Munich [en]' )
  end

  def test_year
    assert_equal 'FC Linz',      strip_year( 'FC Linz (1946-2001, 2013-)' )

    assert_equal 'Admira Wien',  strip_year( 'Admira Wien (-????)' )
    assert_equal 'Admira Wien',  strip_year( 'Admira Wien (-____)' )
  end

  def test_norm
    assert_equal 'Estudiantes LP',      strip_norm( 'Estudiantes (LP)')
    assert_equal 'Central Córdoba SdE', strip_norm( 'Central Córdoba (SdE)')
  end

  def test_wiki
    assert_equal 'FC Wacker Innsbruck',   strip_wiki( 'FC Wacker Innsbruck (2002)' )
    assert_equal 'SK Austria Klagenfurt', strip_wiki( 'SK Austria Klagenfurt (2007)' )

    assert_equal 'Willem II',  strip_wiki( 'Willem II (football club)' )
  end
end # class TestClubHelpers
