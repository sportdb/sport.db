###
#  to run use
#     ruby -I ./lib -I ./test test/test_reader.rb


require 'helper'

class TestReader < MiniTest::Test

  def test_parse
    h = Alphabet::Reader.parse( <<TXT )
      ## hello

      Ä  A   ä  a   ## hello
      Á  A   á  a
             à  a
             ã  a
             â  a   ### yada yada
      Å  A   å  a
             æ   ae

    Ç C ç c
        ć c

         ß ss
TXT

    pp h

    assert_equal 'A',   h['Ä']
    assert_equal 'a',   h['ä']
    assert_equal 'ae',  h['æ']

    assert_equal 'ss',  h['ß']
  end

end # class TestReader
