# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_club_helpers.rb


require 'helper'

class TestClubHelpers < MiniTest::Test

  Club = SportDb::Import::Club

  def strip_norm( name ) Club.strip_norm( name ); end
  def strip_lang( name ) Club.strip_lang( name ); end
  def strip_year( name ) Club.strip_year( name ); end
  def strip_wiki( name ) Club.strip_wiki( name ); end



  def test_norm    ## strip (remove) non-norm characters e.g. ()'- etc.
    [
      ['Estudiantes (LP)',            'Estudiantes LP'],
      ['Central Córdoba (SdE)',       'Central Córdoba SdE'],
      ['Saint Patrick’s Athletic FC', 'Saint Patricks Athletic FC'],
      ['Myllykosken Pallo −47',       'Myllykosken Pallo 47'],
    ].each do |rec|
       assert_equal rec[1], strip_norm( rec[0] )
    end
  end

  def test_variants
    ## hungarian
    assert_equal ['Raba ETO Gyor'],                   Variant.find( 'Rába ETO Győr' )
    assert_equal ['Raba ETO Gyor', 'Rába ETO Gyoer'], Variant.find( 'Rába ETO Györ' )

    ## romanian
    assert_equal ['Targu Mures'], Variant.find( 'Târgu Mureș' )
    assert_equal ['Targu Mures'], Variant.find( 'Târgu Mureş' )
  end




  def test_lang
    assert_equal 'Bayern Munich', strip_lang( 'Bayern Munich [en]' )
  end

  def test_year
    assert_equal 'FC Linz',      strip_year( 'FC Linz (1946-2001, 2013-)' )

    assert_equal 'Admira Wien',  strip_year( 'Admira Wien (-????)' )
    assert_equal 'Admira Wien',  strip_year( 'Admira Wien (-____)' )
  end


  def test_wiki
    assert_equal 'FC Wacker Innsbruck',   strip_wiki( 'FC Wacker Innsbruck (2002)' )
    assert_equal 'SK Austria Klagenfurt', strip_wiki( 'SK Austria Klagenfurt (2007)' )

    assert_equal 'Willem II',  strip_wiki( 'Willem II (football club)' )
  end
end # class TestClubHelpers
