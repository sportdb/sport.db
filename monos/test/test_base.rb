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

  def test_env
    puts Mono.env
  end

end # class TestBase

