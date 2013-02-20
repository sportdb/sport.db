require 'hoe'
require './lib/sportdb/version.rb'

## NB: plugin (hoe-manifest) not required; just used for future testing/development
Hoe::plugin :manifest   # more options for manifests (in the future; not yet)


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
    ['worlddb', '~> 1.0.1'],  # NB: worlddb already includes
                               #         - commander
                               #         - logutils
                               #         - textutils
    
    ## 3rd party
    ['commander', '~> 4.1.3']   # remove? -- already included as dep in worlddb

    ## ['activerecord', '~> 3.2'],  # NB: will include activesupport,etc.
    ### ['sqlite3',      '~> 1.3']  # NB: install on your own; remove dependency
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