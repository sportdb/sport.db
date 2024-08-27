###
#  to run use
#     ruby test/test_outline_reader.rb


require_relative  'helper'

class TestOutlineReader < Minitest::Test

  def test_parse
    outline = SportDb::OutlineReader.parse( <<TXT )
=============================
= ÖFB Cup 2011/12
=============================

FC Red Bull Salzburg      ## Bundesliga
FK Austria Wien
TXT

    pp outline

    assert_equal 2, outline.size

    assert_equal [:h1, 'ÖFB Cup 2011/12'],       outline[0]
    assert_equal [:p,  ['FC Red Bull Salzburg',
                        'FK Austria Wien']],     outline[1]
  end

end # class TestOutlineReader
