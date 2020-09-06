###
#  to run use
#     ruby -I ./lib -I ./test test/test_base.rb

require 'helper'

class TestBase < MiniTest::Test

  Git = Mono::Git

  def test_version
    puts MonoCore::VERSION
    puts MonoCore.banner
    puts MonoCore.root

    puts Mono::VERSION
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
    # Git.config( 'user.name', show_scope: true )

    puts "---"
    Git.config( /user/ )   ## note: pass in regex for regex match/search
    Git.config( /user/, show_origin: true )
    # Git.config( /user/, show_scope: true )

    puts "---"
    Git.config( /user\./ )   ## note: pass in regex for regex match/search

    puts "---"
    ## note: if NOT found Mono::Git.config will exit(1) !!!
    ## Mono::Git.config( /proxy/, show_origin: true )
    ## Mono::Git.config( /http/,  show_origin: true )

    puts "---"
  end

end # class TestBase

