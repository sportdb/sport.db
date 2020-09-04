###
#  to run use
#     ruby -I ./lib -I ./test test/test_base.rb

require 'helper'

class TestBase < MiniTest::Test

  def test_version
    puts Mono::VERSION
    puts Mono::Module.banner
    puts Mono::Module.root
  end

  def test_root
    puts Mono.root
  end

  def test_env
    puts Mono.env
  end


  def test_git_config
    Git.config_get( 'user.name' )
    Git.config_get( 'user.name', show_origin: true )

    Git.config_get_regexp( 'user' )
    Git.config_get_regexp( 'user', show_origin: true )
  end

end # class TestBase

