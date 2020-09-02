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

require 'mono/commands/status'
require 'mono/commands/sync'
require 'mono/commands/env'
require 'mono/tool'



puts Mono::Module.banner   # say hello
