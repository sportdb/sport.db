require 'pp'
require 'time'
require 'date'
require 'yaml'
require 'open3'
require 'fileutils'
require 'optparse'


###
# our own code
require 'mono/version' # let version always go first
require 'mono/base'
require 'mono/git/base'
require 'mono/git/sync'
require 'mono/git/status'
require 'mono/git/tool'




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



puts Mono::Module.banner   # say hello
