## first add git support
##   note: use the "modular" version WITHOUT auto-include gitti,
##          thus, require 'gitti/base' (and NOT 'gitti')
require 'gitti/base'

module Mono
  ## note: make Git, GitProject, GitRepoSet, etc. available without Gitti::
  include Gitti
end


## some more stdlibs
# require 'optparse'



###
# our own code
require 'mono/version' # let version always go first
require 'mono/base'

require 'mono/commands/status'
require 'mono/commands/fetch'
require 'mono/commands/sync'
require 'mono/commands/env'
require 'mono/commands/run'
require 'mono/tool'



puts MonoCore.banner   # say hello
