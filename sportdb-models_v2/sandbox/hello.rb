###
#  to run use
#    $ ruby sandbox/hello.rb


$LOAD_PATH.unshift( './lib' )
## our own code
require 'sportdb/models_v2'



#################################
# setup db -> schema / tables

SportDbV2.open_mem  # was setup_in_memory_db

## test helpers here
## SportDb.delete!
## SportDb.tables

puts "bye"