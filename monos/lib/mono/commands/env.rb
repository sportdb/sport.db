module Mono

  def self.env   ## check environment setup
    puts "Mono.root (MOPATH): >#{Mono.root}<"
    puts "Mono::Module.root:  >#{Mono::Module.root}<"
    puts "git version:"
    Git.version
    puts
    puts "monorepo.yml:"
    pp   Mono.monofile
  end

end # module Mono
