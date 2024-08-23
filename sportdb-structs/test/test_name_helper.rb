###
#  to run use
#     ruby  test/test_name_helper.rb


require_relative 'helper'


class TestNameHelper < Minitest::Test

  include SportDb::NameHelper


  def test_strip_norm    ## strip (remove) non-norm characters e.g. ()'- etc.
    [['Estudiantes (LP)',            'Estudiantes LP'],
     ['Central Córdoba (SdE)',       'Central Córdoba SdE'],
     ['Saint Patrick’s Athletic FC', 'Saint Patricks Athletic FC'],
     ['Myllykosken Pallo −47',       'Myllykosken Pallo 47'],
    ].each do |rec|
       assert_equal rec[1], strip_norm( rec[0] )
    end
  end

  def test_strip_year
    [['A (1911-1912)',              'A'],
     ['B (1911-1912, 1913-1915)',   'B'],
     ['C (1911-___)',               'C'],
     ['D (1911-???)',               'D'],
     ['FC Linz (1946-2001, 2013-)', 'FC Linz'],
     ['Admira Wien (-????)',        'Admira Wien'],
     ['Admira Wien (-____)',        'Admira Wien'],
    ].each do |rec|
      assert_equal rec[1], strip_year( rec[0] )
    end
  end

  def test_strip_lang
    [['Bayern Munich [en]', 'Bayern Munich'],
    ].each do |rec|
      assert_equal rec[1], strip_lang( rec[0] )
    end
  end


  def test_variants
    ## hungarian
    assert_equal ['Raba ETO Gyor'],                   variants( 'Rába ETO Győr' )
    assert_equal ['Raba ETO Gyor', 'Rába ETO Gyoer'], variants( 'Rába ETO Györ' )

    ## romanian
    assert_equal ['Targu Mures'], variants( 'Târgu Mureș' )
    assert_equal ['Targu Mures'], variants( 'Târgu Mureş' )
  end


=begin
### fix: move to ClubReader!!!!! not for general use
  def test_wiki
    assert_equal 'FC Wacker Innsbruck',   strip_wiki( 'FC Wacker Innsbruck (2002)' )
    assert_equal 'SK Austria Klagenfurt', strip_wiki( 'SK Austria Klagenfurt (2007)' )

    assert_equal 'Willem II',  strip_wiki( 'Willem II (football club)' )
  end
=end
end # class TestNameHelper
