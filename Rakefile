require 'hoe'
require './lib/sportdb/version.rb'

## NB: plugin (hoe-manifest) not required; just used for future testing/development
## Hoe::plugin :manifest   # more options for manifests (in the future; not yet)


Hoe.spec 'sportdb' do
  
  self.version = SportDb::VERSION
  
  self.summary = 'sportdb - sport.db command line tool'
  self.description = summary

  self.urls    = ['https://github.com/geraldb/sport.db.ruby']

  self.author  = 'Gerald Bauer'
  self.email   = 'opensport@googlegroups.com'

  # switch extension to .markdown for gihub formatting
  #  -- NB: auto-changed when included in manifest
  self.readme_file  = 'README.md'
  self.history_file = 'HISTORY.md'

  self.extra_deps = [
    ['props' ],
    ['logutils'],
    ['textutils'],
    ['worlddb', '>= 2.0.2'],  # NB: worlddb already includes
                               #         - logutils
                               #         - textutils
    ['tagutils'],     # tags n tagging tables
    ['fetcher', '>= 0.3'],

    ## 3rd party
    ['gli', '>= 2.5.6'],

    ['activerecord']  # NB: will include activesupport,etc.
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

