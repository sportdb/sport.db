# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_version.rb


require 'helper'

class TestVersion < MiniTest::Test

  def test_version
    pp SportDb::Module::Importers::VERSION
    pp SportDb::Module::Importers.banner
    pp SportDb::Module::Importers.root

    pp SportDb::Module.constants

    assert true
  end

end # class TestVersion
