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
    puts "---"
    Git.config( 'user.name' )
    Git.config( 'user.name', show_origin: true )
    Git.config( 'user.name', show_scope: true )

    puts "---"
    Git.config( /user/ )   ## note: pass in regex for regex match/search
    Git.config( /user/, show_origin: true )
    Git.config( /user/, show_scope: true )

    puts "---"
    Git.config( /user\./ )   ## note: pass in regex for regex match/search

    puts "---"
    ## note: if NOT found Git.config will exit(1) !!!
    ## Git.config( /proxy/, show_origin: true )
    ## Git.config( /http/,  show_origin: true )

    puts "---"
  end

end # class TestBase

