require 'hoe'
require './lib/sportdb/version.rb'

## NB: plugin (hoe-manifest) not required; just used for future testing/development
Hoe::plugin :manifest   # more options for manifests (in the future; not yet)

###########
#### NB: if you try this script at home
#    you need to create a (symbolic) link to the sport.db fixtures
#     e.g. use ln -s ../sport.db  data  or similar


Hoe.spec 'sportdb' do
  
  self.version = SportDB::VERSION
  
  self.summary = 'sportdb - sport.db command line tool'
  self.description = summary

  self.urls    = ['https://github.com/geraldb/sport.db.ruby']
  
  self.author  = 'Gerald Bauer'
  self.email   = 'opensport@googlegroups.com'
    
  # switch extension to .markdown for gihub formatting
  #  -- NB: auto-changed when included in manifest
  # self.readme_file  = 'README.md'
  # self.history_file = 'History.md'
  
  self.extra_deps = [
    ## ['activerecord', '~> 3.2'],  # NB: will include activesupport,etc.
    ### ['sqlite3',      '~> 1.3']  # NB: install on your own; remove dependency
    ['worlddb', '~> 0.8.0']
  ]

  self.licenses = ['Public Domain']

  self.spec_extras = {
   :required_ruby_version => '>= 1.9.2'
  }

  self.post_install_message =<<EOS
******************************************************************************

Questions? Comments? Send them along to the mailing list.
https://groups.google.com/group/opensport

******************************************************************************
EOS
  
end