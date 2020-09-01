###
#  to run use
#     ruby -I ./lib -I ./test test/test_base.rb

require 'helper'

class TestBase < MiniTest::Test

  def test_version
    puts Mono::Module::VERSION
    puts Mono::Module.banner
    puts Mono::Module.root
  end

  def test_root
     puts Mono.root
  end

end # class TestBase

