# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_norm.rb


require 'helper'

class TestNorm < MiniTest::Test

  def test_norm    ## strip (remove) non-norm characters e.g. ()'- etc.
    [
      ['Estudiantes (LP)',            'Estudiantes LP'],
      ['Saint Patrick’s Athletic FC', 'Saint Patricks Athletic FC'],
      ['Myllykosken Pallo −47',       'Myllykosken Pallo 47'],
    ].each do |rec|
       assert_equal rec[1], SportDb::Import::Club.strip_norm( rec[0] )
    end
  end

  def test_variant
    ## hungarian
    assert_equal ['Raba ETO Gyor'],                   Variant.find( 'Rába ETO Győr' )
    assert_equal ['Raba ETO Gyor', 'Rába ETO Gyoer'], Variant.find( 'Rába ETO Györ' )

    ## romanian
    assert_equal ['Targu Mures'], Variant.find( 'Târgu Mureș' )
    assert_equal ['Targu Mures'], Variant.find( 'Târgu Mureş' )
  end

end # class TestNorm
