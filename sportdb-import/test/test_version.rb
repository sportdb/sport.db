# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_version.rb


require 'helper'

class TestVersion < MiniTest::Test

  def test_version
    pp SportDb::Import::VERSION
    pp SportDb::Import.banner
    pp SportDb::Import.root

    assert true
  end

end # class TestVersion
