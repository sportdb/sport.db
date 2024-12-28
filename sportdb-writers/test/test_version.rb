###
#  to run use
#     ruby test/test_version.rb


require_relative 'helper'

class TestVersion < Minitest::Test

  def test_version
    pp SportDb::Module::Writers::VERSION
    pp SportDb::Module::Writers.banner
    pp SportDb::Module::Writers.root
  end

end # class TestVersion
