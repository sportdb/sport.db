module Mono

  def self.env   ## check environment setup
    puts "Mono.root (MOPATH): >#{Mono.root}<"
    puts "MonoCore.root:  >#{MonoCore.root}<"
    puts

    ## add ruby version and path - why? why not? e.g.
    ##  ruby:
    ## bin:        C:/ri330/Ruby2.0.0/bin/ruby.exe
    ## version:    ruby 2.3.3p222 (2016-11-21 revision 56859) [i386-mingw32]

    puts "git version:"
    Git.version
    ## Git.config( 'user.name' )
    ## Git.config( 'user.email', show_origin: true )

    ## dump/print all user.* settings e.g. user.name, user.email
    Git.config( /user/, show_origin: true )

    puts
    puts "monorepo.yml:"
    pp   Mono.monofile
  end

end # module Mono
